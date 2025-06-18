#!/bin/bash

if pgrep -x "waybar" > /dev/null; then
  # If running, kill the waybar process
  pkill -x "waybar"
else
  waybar&
  trap "killall waybar" EXIT
  while inotifywait -r -e create,modify ~/.config/waybar/*; do killall -SIGUSR2 waybar; done
fi
