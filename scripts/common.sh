#!/bin/bash

TMUX_SESSION=dreijahreszeiten
BASE_DIR=$HOME/dreijahreszeiten

stop_process () {
	pkill -INT $1
}

reset_all () {
	stop_process aplay
	stop_process it8951-video
	stop_process mplayer
}
