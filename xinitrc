#!/bin/bash

xrdb -merge ~/.Xresources
urxvtd -q -o -f
dropbox start
if [ "$(hostname)" = "clint-laptop" ]; then
    emacs --chdir=/home/clint/av --daemon
else
    emacs --daemon
fi

if which zeal; then
    # set to start minimized
    zeal
fi

/usr/bin/dbus-launch --exit-with-session awesome
