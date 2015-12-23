#!/bin/bash

urxvtd -q -o -f
dropbox start
emacs --daemon

exec awesome
