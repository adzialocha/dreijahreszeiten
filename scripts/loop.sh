#!/bin/bash
# Installation loop for dreijahreszeiten

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

FILES_DIR=$BASE_DIR/files

stop_process () {
	pkill -INT $1
}

standby () {
	seconds=$((($1 * 60) + $2))
	echo "⏹ wait for $seconds seconds ($1:$2)"
	sleep $seconds
}

play_wide_video () {
	echo "▶ [wide] play video $1"
	stop_process mplayer
	mplayer -vo xv -nosound -really-quiet $FILES_DIR/video-wide/$1 &
}

play_epaper_video () {
	echo "▶ [epaper] play video $1"
	stop_process it8951
	it8951 --take 2 $FILES_DIR/video-epaper/$1 &
}

while true
do
	play_wide_video 1-Wasser-Wide-v01-20230524.mp4
	standby 0 10
done
