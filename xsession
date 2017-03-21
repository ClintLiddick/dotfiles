#!/bin/bash

/usr/bin/ibus-daemon  -d -r -n awesome
urxvtd -q -o -f
#dropbox start
emacs --daemon

exec awesome
