#!/bin/bash

/usr/bin/ibus-daemon  -d -r -n awesome
urxvtd -q -o -f
emacs --daemon
dropbox.py start

exec awesome
