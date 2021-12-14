#!/bin/bash

picom &
connectairpods &
nitrogen --restore &

# enable tapping on trackpad
xinput set-prop "DLL0945:00 06CB:CDE6 Touchpad" "libinput Tapping Enabled" 1
