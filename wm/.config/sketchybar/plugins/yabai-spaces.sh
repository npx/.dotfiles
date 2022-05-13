#!/usr/bin/env bash


# icon mapping
icon_default=display
icon_company=building
icon_comm=video
icon_term=terminal
icon_build=boxes-packing
icon_vm=network-wired
icon_private=user-secret

sketchybar -m --default icon.padding_right=15

while read -r label
do
  read -r index
  item=space_$label
  icon=icon_$label
  sketchybar -m --add space $item left                            \
                --set $item associated_display=1                  \
                      associated_space=$index                     \
                      icon.font="Font Awesome 6 Free:Solid:14.0"  \
                      icon=${!icon:=•}                            \
                      icon.highlight_color=0xffffab91             \
                      click_script="yabai -m space --focus $label || yabai -m space --focus recent"
done < <(yabai -m query --spaces | jq -cr '.[] | (.label, .index)')

# register plugin
sketchybar -m --add event yabai_spaces_refresh \
              --add item plugin_spaces left    \
              --set plugin_spaces drawing=off updates=on script="~/.config/sketchybar/plugins/yabai-spaces.sh" \
              --subscribe plugin_spaces yabai_spaces_refresh
