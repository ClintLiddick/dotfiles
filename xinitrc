#!/bin/bash

xrdb -merge ~/.Xresources
urxvtd -q -o -f
# dropbox start
if [ -d /home/clint/av ]; then
    emacs --chdir=/home/clint/av --daemon
else
    emacs --daemon
fi

/usr/bin/dbus-launch --exit-with-session awesome
