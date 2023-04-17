#!/usr/bin/env bash


# icon mapping
icon_default=󰍹
icon_company=
icon_comm=󱩛
icon_term=
icon_build=
icon_vm=
icon_private=

while read -r label
do
  read -r index
  item=space_$label
  icon=icon_$label
  sketchybar -m --add space $item right                \
                --set $item associated_display=1       \
                      associated_space=$index          \
                      icon=${!icon:=}                 \
                      icon.highlight_color=0xf2cd2e4c  \
                      label.padding_left=0             \
                      label.padding_right=0            \
                      icon.padding_left=0              \
                      icon.padding_right=0             \
                      background.padding_left=15       \
                      click_script="yabai -m space --focus $label || yabai -m space --focus recent"
done < <(yabai -m query --spaces | jq -cr '.[] | (.label, .index)')

# register plugin
sketchybar -m --add event yabai_spaces_refresh \
              --add item plugin_spaces left    \
              --set plugin_spaces drawing=off updates=on script="~/.config/sketchybar/plugins/yabai-spaces.sh" \
              --subscribe plugin_spaces yabai_spaces_refresh
