from datetime import datetime
import subprocess
import re
from kitty.boss import get_boss
from kitty.fast_data_types import Screen, add_timer, get_options
from kitty.utils import color_as_int
from kitty.tab_bar import (
    DrawData,
    ExtraData,
    Formatter,
    TabBarData,
    as_rgb,
    draw_attributed_string,
    draw_title,
)

opts = get_options()
icon_fg = as_rgb(color_as_int(opts.foreground))
icon_bg = as_rgb(color_as_int(opts.background))
bat_text_color = as_rgb(color_as_int(opts.color15))
clock_color = as_rgb(color_as_int(opts.color15))
date_color = as_rgb(color_as_int(opts.color8))
SEPARATOR_SYMBOL, SOFT_SEPARATOR_SYMBOL = ('', '')
DIVIDER, SOFT_DIVIDER = ('', '')
RIGHT_MARGIN = 1
REFRESH_TIME = 1
ICON = ' 󰣇 '
UNPLUGGED_ICONS = {
    10: '󰁺',
    20: '󰁻',
    30: '󰁼',
    40: '󰁽',
    50: '󰁾',
    60: '󰁿',
    70: '󰂀',
    80: '󰂁',
    90: '󰂂',
    100: '󰁹',
}
PLUGGED_ICONS = {
    1: '󰂄',
}
UNPLUGGED_COLORS = {
    15: as_rgb(color_as_int(opts.color1)),
    16: as_rgb(color_as_int(opts.color15)),
}
PLUGGED_COLORS = {
    15: as_rgb(color_as_int(opts.color1)),
    16: as_rgb(color_as_int(opts.color6)),
    99: as_rgb(color_as_int(opts.color6)),
    100: as_rgb(color_as_int(opts.color2)),
}


def _draw_icon(screen: Screen, index: int, tab=None, draw_data=None) -> int:
    try:
        if index != 1:
            return 0
        fg, bg = screen.cursor.fg, screen.cursor.bg
        # Draw icon
        screen.cursor.fg = icon_fg
        screen.cursor.bg = icon_bg
        screen.draw(ICON)
        # Draw divider after icon with correct colors
        screen.cursor.fg = icon_bg
        # Determine tab backgrounds for divider
        active_tab_bg = as_rgb(color_as_int(opts.active_tab_background)) #as_rgb(draw_data.active_tab_bg) if draw_data else icon_bg
        inactive_tab_bg = as_rgb(color_as_int(opts.inactive_tab_background)) #as_rgb(draw_data.inactive_tab_bg) if draw_data else icon_bg
        is_active_tab = tab.is_active if tab and hasattr(tab, 'is_active') else False
        # print(f"is_active_tab: %s", is_active_tab)
        if is_active_tab:
            screen.cursor.bg = active_tab_bg
        else:
            screen.cursor.bg = inactive_tab_bg
        screen.draw(SEPARATOR_SYMBOL)
        screen.cursor.fg, screen.cursor.bg = fg, bg
        screen.cursor.x = len(ICON) + len(SEPARATOR_SYMBOL)
        return screen.cursor.x
    except Exception as e:
        import sys
        print(f"tab_bar.py error in _draw_icon: {e}", file=sys.stderr)
        return 0




def _draw_left_status(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    if screen.cursor.x >= screen.columns - right_status_length:
        return screen.cursor.x
    tab_bg = screen.cursor.bg
    tab_fg = screen.cursor.fg
    default_bg = as_rgb(int(draw_data.default_bg))
    if extra_data.next_tab:
        next_tab_bg = as_rgb(draw_data.tab_bg(extra_data.next_tab))
        needs_soft_separator = next_tab_bg == tab_bg
    else:
        next_tab_bg = default_bg
        needs_soft_separator = False
    if screen.cursor.x <= len(ICON):
        screen.cursor.x = len(ICON)
    screen.draw(' ')
    screen.cursor.bg = tab_bg
    # Truncate tab title if too long
    title = tab.title if hasattr(tab, 'title') else ''
    if len(title) > max_title_length:
        title = title[:max_title_length-1] + '…'
    fg, bg = screen.cursor.fg, screen.cursor.bg
    draw_attributed_string(title, screen)
    screen.cursor.fg, screen.cursor.bg = fg, bg
    if not needs_soft_separator:
        screen.draw(' ')
        screen.cursor.fg = tab_bg
        screen.cursor.bg = next_tab_bg
        screen.draw(SEPARATOR_SYMBOL)
    else:
        prev_fg = screen.cursor.fg
        if tab_bg == tab_fg:
            screen.cursor.fg = default_bg
        elif tab_bg != default_bg:
            c1 = draw_data.inactive_bg.contrast(draw_data.default_bg)
            c2 = draw_data.inactive_bg.contrast(draw_data.inactive_fg)
            if c1 < c2:
                screen.cursor.fg = default_bg
        screen.draw(' ' + SOFT_SEPARATOR_SYMBOL)
        screen.cursor.fg = prev_fg
    end = screen.cursor.x
    return end


def _draw_right_status(screen: Screen, is_last: bool, cells: list) -> int:
    if not is_last:
        return 0
    draw_attributed_string(Formatter.reset, screen)
    screen.cursor.x = screen.columns - right_status_length
    screen.cursor.fg = 0
    for color, status in cells:
        screen.cursor.fg = color
        screen.draw(status)
    screen.cursor.bg = 0
    return screen.cursor.x


def _redraw_tab_bar(_):
    tm = get_boss().active_tab_manager
    if tm is not None:
        tm.mark_tab_bar_dirty()


# Linux
def get_battery_cells() -> list:
    try:
        with open("/sys/class/power_supply/BAT0/status", "r") as f:
            status = f.read()
        with open("/sys/class/power_supply/BAT0/capacity", "r") as f:
            percent = int(f.read())
        if status == "Discharging\n":
            icon_color = UNPLUGGED_COLORS[
                min(UNPLUGGED_COLORS.keys(), key=lambda x: abs(x - percent))
            ]
            icon = UNPLUGGED_ICONS[
                min(UNPLUGGED_ICONS.keys(), key=lambda x: abs(x - percent))
            ]
        elif status == "Not charging\n":
            icon_color = UNPLUGGED_COLORS[
                min(UNPLUGGED_COLORS.keys(), key=lambda x: abs(x - percent))
            ]
            icon = PLUGGED_ICONS[
                min(PLUGGED_ICONS.keys(), key=lambda x: abs(x - percent))
            ]
        else:
            icon_color = PLUGGED_COLORS[
                min(PLUGGED_COLORS.keys(), key=lambda x: abs(x - percent))
            ]
            icon = PLUGGED_ICONS[
                min(PLUGGED_ICONS.keys(), key=lambda x: abs(x - percent))
            ]
        percent_cell = (bat_text_color, str(percent) + "% ")
        icon_cell = (icon_color, icon)
        return [percent_cell, icon_cell]
    except FileNotFoundError:
        return []

# Mac
# def get_battery_cells() -> list:
#     try:
#         result = subprocess.run(['pmset', '-g', 'batt'],
#                                 capture_output=True, text=True)
#         output = result.stdout
#         status_search = re.search(r'(\w+)\s*;', output)
#         percent_search = re.search(r'(\d+)%', output)
#
#         if status_search and percent_search:
#             status = status_search.group(1)
#             percent = int(percent_search.group(1))
#
#             if status == "discharging":
#                 icon_color = UNPLUGGED_COLORS[min(
#                     UNPLUGGED_COLORS.keys(), key=lambda x: abs(x - percent))]
#                 icon = UNPLUGGED_ICONS[min(
#                     UNPLUGGED_ICONS.keys(), key=lambda x: abs(x - percent))]
#             else:
#                 icon_color = PLUGGED_COLORS[min(
#                     PLUGGED_COLORS.keys(), key=lambda x: abs(x - percent))]
#                 icon = PLUGGED_ICONS[min(
#                     PLUGGED_ICONS.keys(), key=lambda x: abs(x - percent))]
#
#             percent_cell = (bat_text_color, str(percent) + "% ")
#             icon_cell = (icon_color, icon)
#             return [percent_cell, icon_cell]
#     except Exception as e:
#         print(f"Error: {e}")
#         return []


timer_id = None
right_status_length = -1


def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    try:
        global timer_id
        global right_status_length
        if timer_id is None:
            timer_id = add_timer(_redraw_tab_bar, REFRESH_TIME, True)
        date = datetime.now().strftime(' %Y.%m.%d')
        clock = datetime.now().strftime(' %H:%M')
        cells = get_battery_cells()
        cells.append((date_color, date))
        cells.append((clock_color, clock))
        right_status_length = RIGHT_MARGIN
        for cell in cells:
            right_status_length += len(str(cell[1]))

        _draw_icon(screen, index, tab=tab, draw_data=draw_data)

        # Dynamically calculate max title length for tabs
        # Estimate: available width = total columns - right_status_length - icon/divider - (tabs * padding)
        total_tabs = len(get_boss().active_tab_manager.tabs) if get_boss() and get_boss().active_tab_manager else 1
        icon_and_divider = len(ICON) + len(SEPARATOR_SYMBOL) + 2  # +2 for spaces
        available_width = screen.columns - right_status_length - icon_and_divider
        per_tab = max(6, int(available_width / total_tabs) - 2)  # -2 for padding, min 6 chars

        _draw_left_status(
            draw_data,
            screen,
            tab,
            before,
            per_tab,
            index,
            is_last,
            extra_data,
        )
        _draw_right_status(
            screen,
            is_last,
            cells,
        )
        return screen.cursor.x
    except Exception as e:
        import sys
        print(f"tab_bar.py error in draw_tab: {e}", file=sys.stderr)
        return screen.cursor.x
