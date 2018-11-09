#!/bin/bash

xrdb -merge ~/.Xresources
urxvtd -q -o -f
dropbox start
emacs --daemon

/usr/bin/dbus-launch --exit-with-session awesome
