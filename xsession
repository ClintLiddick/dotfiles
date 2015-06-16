#!/bin/bash

urxvtd -q -o -f
dropbox start

exec awesome
