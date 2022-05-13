#!/usr/bin/env bash

sketchybar -m --set windows label="$(yabai -m query --windows --space | jq -cr 'sort_by(.id) | map(if ."has-focus" then "[*\(.app)*]"  else "[ \(.app) ]" end) | join(" ")')"
