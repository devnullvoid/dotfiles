#!/usr/bin/env bash

# emoji-picker.sh - Select an emoji using a fuzzy finder and copy to clipboard
# Dependencies: wl-copy (for Wayland clipboard)
#               One of: fzf, skim (sk), or tv (for fuzzy finding)

set -e

EMOJI_DIR="$HOME/.local/share/bemoji"
EMOJI_FILES=("$EMOJI_DIR/emojis.txt" "$EMOJI_DIR/math.txt" "$EMOJI_DIR/nerdfont.txt")
DEFAULT_PREVIEW_WINDOW="right:25%:wrap"


# Parse command line arguments
SHOW_PREVIEW=true
SELECTED_FILES=()
MENU_PROGRAM=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --no-preview)
            SHOW_PREVIEW=false
            shift
            ;;
        --emojis-only)
            SELECTED_FILES=("$EMOJI_DIR/emojis.txt")
            shift
            ;;
        --math-only)
            SELECTED_FILES=("$EMOJI_DIR/math.txt")
            shift
            ;;
        --nerdfont-only)
            SELECTED_FILES=("$EMOJI_DIR/nerdfont.txt")
            shift
            ;;
        --menu=*)
            MENU_PROGRAM="${1#--menu=}"
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [--no-preview] [--emojis-only|--math-only|--nerdfont-only] [--menu=PROGRAM]"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [--no-preview] [--emojis-only|--math-only|--nerdfont-only] [--menu=PROGRAM]"
            exit 1
            ;;
    esac
done

# If no specific files were selected, use all files
if [ ${#SELECTED_FILES[@]} -eq 0 ]; then
  SELECTED_FILES=("${EMOJI_FILES[@]}")
fi

# Check if the emoji directory exists
if [ ! -d "$EMOJI_DIR" ]; then
    echo "Error: Emoji directory not found at $EMOJI_DIR"
    exit 1
fi

# Check if the selected files exist
for file in "${SELECTED_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo "Error: File not found: $file"
        exit 1
    fi
done

# Function to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}


# Determine which fuzzy/menu program to use
# Priority: --menu arg > $EMOJI_PICKER_MENU env > first available
if [ -z "$MENU_PROGRAM" ]; then
    if [ -n "$EMOJI_PICKER_MENU" ]; then
        MENU_PROGRAM="$EMOJI_PICKER_MENU"
    fi
fi

# Auto-detect if still unset
if [ -z "$MENU_PROGRAM" ]; then
    for prog in fzf sk tv rofi wofi bemenu fuzzel dmenu; do
        if command_exists "$prog"; then
            MENU_PROGRAM="$prog"
            break
        fi
    done
fi

if [ -z "$MENU_PROGRAM" ]; then
    echo "Error: No supported menu/fuzzy finder found. Please install fzf, sk, tv, rofi, wofi, bemenu, fuzzel, or dmenu."
    exit 1
fi

# Check if wl-copy exists for Wayland clipboard
if ! command_exists wl-copy; then
    echo "Error: wl-copy not found. Please install wl-clipboard package."
    exit 1
fi


# Function to run the appropriate fuzzy/menu program
run_menu() {
    local input="$1"
    case "$MENU_PROGRAM" in
        fzf)
            if [ "$SHOW_PREVIEW" = true ]; then
                echo "$input" | fzf --layout=reverse --preview="echo {}" --preview-window="$DEFAULT_PREVIEW_WINDOW"
            else
                echo "$input" | fzf --layout=reverse --preview-window=hidden
            fi
            ;;
        sk)
            if [ "$SHOW_PREVIEW" = true ]; then
                echo "$input" | sk --layout=reverse --preview="echo {}"
            else
                echo "$input" | sk --layout=reverse
            fi
            ;;
        tv)
            if [ "$SHOW_PREVIEW" = true ]; then
                echo "$input" | tv --preview-command="echo {}" --preview-window="$DEFAULT_PREVIEW_WINDOW"
            else
                echo "$input" | tv --preview-window=hidden
            fi
            ;;
        rofi)
            echo "$input" | rofi -dmenu -i -p "Pick an emoji:" ;;
        wofi)
            echo "$input" | wofi --dmenu -p "Pick an emoji:" ;;
        bemenu)
            echo "$input" | bemenu -p "Pick an emoji:" ;;
        fuzzel)
            echo "$input" | fuzzel --dmenu -p "Pick an emoji:" ;;
        dmenu)
            echo "$input" | dmenu -i -p "Pick an emoji:" ;;
        *)
            echo "$input" | "$MENU_PROGRAM" ;;
    esac
}

# Combine all selected emoji files
emoji_data=$(cat "${SELECTED_FILES[@]}")


# Run the menu/fuzzy finder and get selection
selected=$(run_menu "$emoji_data")

# Exit if nothing was selected
if [ -z "$selected" ]; then
    echo "No emoji selected."
    exit 0
fi

# Extract just the emoji character (first character) from the selected line
emoji=$(echo "$selected" | awk '{print $1}')

# Copy to clipboard
echo -n "$emoji" | wl-copy

# Notify user
echo "Emoji copied to clipboard: $emoji"
