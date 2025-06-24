#!/usr/bin/env bash

# Exit on error, undefined variables, and pipe failures
set -euo pipefail

# Configuration
WALLPAPER_DIR="${HOME}/Pictures/Wallpapers"
CACHE_DIR="${HOME}/.cache/swww"
TRANSITION_FPS=144
TRANSITION_DURATION=1

# Ensure cache directory exists
mkdir -p "${CACHE_DIR}"

# Find all image files (case-insensitive)
mapfile -t wallpapers < <(find -L "${WALLPAPER_DIR}" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) -print0 | sort -z | tr '\0' '\n')

# Check if any wallpapers were found
if [[ ${#wallpapers[@]} -eq 0 ]]; then
    echo "No wallpapers found in ${WALLPAPER_DIR}" >&2
    exit 1
fi

# Process each wallpaper
for path in "${wallpapers[@]}"; do
    # Extract and clean up the filename for the label
    name=$(basename "${path}")
    name=$(sed -E 's/\.[^.]+$//; s/[-_]+/ /g; s/  +/ /g' <<< "${name}")

    # Prepare the execution command
    base_cmd="swww img --transition-fps ${TRANSITION_FPS} --transition-duration ${TRANSITION_DURATION} -t any"
    if [[ "${path}" =~ \.png$ ]]; then
        exec_cmd="${base_cmd} \"${path}\" && cp \"${path}\" \"${CACHE_DIR}/current.png\""
    else
        exec_cmd="${base_cmd} \"${path}\" && convert \"${path}\" \"${CACHE_DIR}/current.png\""
    fi

    # Output the formatted line
    printf 'image=%s;label=%s;exec=%s;\n' "${path}" "${name}" "${exec_cmd}"
done
