#!/bin/bash

/usr/bin/ibus-daemon  -d -r -n awesome
urxvtd -q -o -f
dropbox start
# TODO: delaying this until after startup so I get other xinit/console settings
# emacs --daemon

exec awesome
