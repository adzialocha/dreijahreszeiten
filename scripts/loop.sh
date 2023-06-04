#!/bin/bash
# Installation loop for dreijahreszeiten

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

FILES_DIR=$BASE_DIR/files

standby () {
	seconds=$((($1 * 60) + $2))
	echo "⏹ wait for $seconds seconds ($1:$2)"
	sleep $seconds
}

play_audio () {
	echo "▶ play audio $1"
	stop_process aplay
	aplay --quiet $FILES_DIR/audio/$1 &
}

play_wide_video () {
	echo "▶ [wide] play video $1"
	stop_process mplayer
	mplayer -vo xv -nosound -really-quiet $FILES_DIR/video-wide/$1 &
}

safe_reset_all () {
	stop_process aplay
	stop_process mplayer
	is_running=$(ps aux | grep it8951-video | grep -v grep)
	if [[ -n "$is_running" ]]; then
		stop_process it8951-video
		# Wait a little for epaper to become ready again
		sleep 3
	fi
}

play_epaper_video () {
	echo "▶ [epaper] play video $1"
	stop_process it8951-video
	it8951-video --take 2 $FILES_DIR/video-epaper/$1 &> /dev/null &
}

# Make sure to reset all processes before, just to be safe
safe_reset_all

# This is our main installation loop, running forever!
while true
do
	safe_reset_all
	play_epaper_video 1_Wasser.mp4
	play_wide_video 1_Wasser.mp4
	play_audio 1_Wasser.wav
	standby 0 10
done
