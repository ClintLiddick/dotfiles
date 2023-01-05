#!/bin/bash

xrdb -merge ~/.Xresources
urxvtd -q -o -f
dropbox start
if [ -d /home/clint.liddick/src ]; then
    emacs --chdir=/home/clint.liddick/src --daemon
else
    emacs --daemon
fi

/usr/bin/dbus-launch --exit-with-session awesome
