#!/usr/bin/env bash
# Be tolerant of cancel/unsupported cases in UI selection
set -uo pipefail

# Kitty Command Palette
# Uses the built-in `choose` kitten for a fuzzy searchable menu,
# then dispatches the selection via kitty remote control.

choices=(
  "New Tab"
  "New Window"
  "Close Tab"
  "Close Pane"
  "Close Other Panes"
  "Next Tab"
  "Previous Tab"
  "Split Horizontal"
  "Split Vertical"
  "Split Smart"
  "Rotate Split Axis"
  "Focus Left"
  "Focus Right"
  "Focus Up"
  "Focus Down"
  "Move Left"
  "Move Right"
  "Move Up"
  "Move Down"
  "Move To Edge Left"
  "Move To Edge Right"
  "Move To Edge Up"
  "Move To Edge Down"
  "Swap With Left"
  "Swap With Right"
  "Swap With Up"
  "Swap With Down"
  "Resize Wider"
  "Resize Narrower"
  "Resize Taller"
  "Resize Shorter"
  "Balance Panes"
  "Increase Font Size"
  "Decrease Font Size"
  "Reset Font Size"
  "Next Layout"
  "Goto Layout: Tall"
  "Goto Layout: Stack"
  "Goto Layout: Splits"
  "Goto Layout: Fat"
  "Find: Scrollback/Search"
  "Find: Last Command Output"
  "Hints: Generic"
  "Hints: URLs"
  "Hints: Paths"
  "Hints: Words"
  "Unicode Input"
  "Reload Config"
  "Show Keymap"
)

# Choose implementation: prefer kitty's choose kitten, else fall back to fzf
choose_cmd() {
  if kitty +kitten choose --help >/dev/null 2>&1; then
    kitty +kitten choose --title 'Kitty Command Palette' --placeholder 'Type to filter…'
    return
  fi
  if command -v fzf >/dev/null 2>&1; then
    fzf --prompt='Kitty: ' --height=80% --reverse
    return
  fi
  return 127
}

# Capture selection without failing the whole script on cancel
selection="$(printf '%s\n' "${choices[@]}" | choose_cmd || true)"

# Exit if user cancels
if [[ -z "${selection}" ]]; then
  exit 0
fi

case "${selection}" in
  "New Tab")              kitty @ action new_tab ;;
  "New Window")           kitty @ action new_window ;;
  "Close Tab")            kitty @ action close_tab ;;
  "Close Pane")           kitty @ action close_window ;;
  "Close Other Panes")    kitty @ action close_other_windows_in_tab ;;
  "Next Tab")             kitty @ action next_tab ;;
  "Previous Tab")         kitty @ action previous_tab ;;
  "Split Horizontal")     kitty @ launch --location=hsplit ;;
  "Split Vertical")       kitty @ launch --location=vsplit ;;
  "Split Smart")          kitty @ launch --location=split ;;
  "Rotate Split Axis")    kitty @ action layout_action rotate ;;
  "Focus Left")           kitty @ action neighboring_window left ;;
  "Focus Right")          kitty @ action neighboring_window right ;;
  "Focus Up")             kitty @ action neighboring_window up ;;
  "Focus Down")           kitty @ action neighboring_window down ;;
  "Move Left")            kitty @ action move_window left ;;
  "Move Right")           kitty @ action move_window right ;;
  "Move Up")              kitty @ action move_window up ;;
  "Move Down")            kitty @ action move_window down ;;
  "Move To Edge Left")    kitty @ action layout_action move_to_screen_edge left ;;
  "Move To Edge Right")   kitty @ action layout_action move_to_screen_edge right ;;
  "Move To Edge Up")      kitty @ action layout_action move_to_screen_edge top ;;
  "Move To Edge Down")    kitty @ action layout_action move_to_screen_edge bottom ;;
  # Kitty does not have a dedicated swap command; move_window effectively swaps
  "Swap With Left")       kitty @ action move_window left ;;
  "Swap With Right")      kitty @ action move_window right ;;
  "Swap With Up")         kitty @ action move_window up ;;
  "Swap With Down")       kitty @ action move_window down ;;
  "Resize Wider")         kitty @ action resize_window wider ;;
  "Resize Narrower")      kitty @ action resize_window narrower ;;
  "Resize Taller")        kitty @ action resize_window taller ;;
  "Resize Shorter")       kitty @ action resize_window shorter 3 ;;
  "Balance Panes")        kitty @ action resize_window reset ;;
  "Increase Font Size")   kitty @ action increase_font_size ;;
  "Decrease Font Size")   kitty @ action decrease_font_size ;;
  "Reset Font Size")      kitty @ action change_font_size all 0 ;;
  "Next Layout")          kitty @ action next_layout ;;
  "Goto Layout: Tall")    kitty @ action goto_layout tall ;;
  "Goto Layout: Stack")   kitty @ action goto_layout stack ;;
  "Goto Layout: Splits")  kitty @ action goto_layout splits ;;
  "Goto Layout: Fat")     kitty @ action goto_layout fat ;;
  "Find: Scrollback/Search") kitty @ action show_scrollback ;;
  "Find: Last Command Output") kitty @ action show_last_command_output ;;
  "Hints: Generic")       kitty @ launch --type=overlay kitten hints ;;
  "Hints: URLs")          kitty @ launch --type=overlay kitten hints --type=url ;;
  "Hints: Paths")         kitty @ launch --type=overlay kitten hints --type=path ;;
  "Hints: Words")         kitty @ launch --type=overlay kitten hints --type=word ;;
  "Unicode Input")        kitty @ launch --type=overlay kitten unicode_input ;;
  "Reload Config")        kitty @ action load_config_file ;;
  "Show Keymap")          kitty @ launch --type=overlay --cwd=current kitten ~/.config/kitty/keymap.py ;;
  *) exit 0 ;;
esac
