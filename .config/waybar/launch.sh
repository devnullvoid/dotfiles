#!/bin/bash

PROGRAM_NAME="waybar"

  pkill -x "$PROGRAM_NAME" #--signal SIGUSR2
  "$PROGRAM_NAME" &
  disown
