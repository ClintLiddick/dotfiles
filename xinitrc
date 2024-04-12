#!/bin/bash

xrdb -merge ~/.Xresources
urxvtd -q -o -f
# dropbox start
if [ -d /home/clint/av ]; then
    emacs --chdir=/home/clint/av --daemon
else
    emacs --daemon
fi

if [ -r ~/Pictures/wallpaper/wallpaper ]; then
    feh --no-fehbg --bg-fill ~/Pictures/wallpaper/wallpaper
fi

i3
