#! /usr/bin/env sh

if [ $# -ne 0 ]; then
	for event in window_destroyed space_changed; do
		yabai -m signal --add label="${0}_${event}" event="${event}" action="${0}"
	done
	exit
fi

{
	yabai -m query --windows --space | jq -er 'map(select(.focused == 1)) | length > 0' ||
		yabai -m window --focus mouse
	sketchybar --trigger refresh_windows
} >/dev/null 2>&1
