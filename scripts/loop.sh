#!/bin/bash
# Installation loop for dreijahreszeiten

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

# Base folder where all media files live
FILES_DIR=$BASE_DIR/files

# Only take nth frame from video for epaper display to get to 5fps
EPAPER_TAKE=6

# Bright Sign display
BRIGHT_SIGN_HOST=192.168.1.100
BRIGHT_SIGN_PORT=3000

# Arduino Nanos
ARDUINO_1_HOST=192.168.1.100
ARDUINO_1_PORT=3000

ARDUINO_2_HOST=192.168.1.100
ARDUINO_2_PORT=3000

ARDUINO_3_HOST=192.168.1.100
ARDUINO_3_PORT=3000

print_title () {
	figlet -f slant $1
	echo ""
}

standby () {
	seconds=$((($1 * 60) + $2))
	echo "⏹ wait for $seconds seconds ($1:$2)"
	sleep $seconds
}

send_udp () {
	echo $1 > /dev/udp/$2/$3
}

send_udp_to_bright_sign () {
	send_udp $1 $BRIGHT_SIGN_HOST $BRIGHT_SIGN_PORT
}

send_udp_to_arduino () {
	echo "▶ [arduino] send command $2 to arduino $1"
	if [[ $1 -eq 1 ]]; then
		send_udp $2 $ARDUINO_1_HOST $ARDUINO_1_PORT
	elif [[ $1 -eq 2 ]]; then
		send_udp $2 $ARDUINO_2_HOST $ARDUINO_2_PORT
	elif [[ $1 -eq 3 ]]; then
		send_udp $2 $ARDUINO_3_HOST $ARDUINO_3_PORT
	else
		echo "! warning: unknown arduino identifier"
	fi
}

play_audio () {
	echo "▶ [audio] play $1"
	stop_process aplay
	aplay --quiet $FILES_DIR/audio/$1 2> /dev/null &
}

play_square_video () {
	echo "▶ [square] play video $1"
	send_udp_to_bright_sign $1
}

play_wide_video () {
	echo "▶ [wide] play video $1"
	stop_process mplayer
	mplayer -vo xv -nosound -really-quiet $FILES_DIR/video-wide/$1 &
}

play_epaper_video () {
	echo "▶ [epaper] play video $1"
	stop_process it8951-video
	it8951-video --take $EPAPER_TAKE $FILES_DIR/video-epaper/$1 &> /dev/null &
}

stop_process () {
	pkill -INT $1
}

reset_except_it8951 () {
	# play_square_video @TODO: Add standby screen here
	# send_udp_to_arduino 1 0 @TODO: Add standby mode here
	# send_udp_to_arduino 2 0 @TODO: Add standby mode here
	# send_udp_to_arduino 3 0 @TODO: Add standby mode here
	stop_process aplay
	stop_process mplayer
}

reset_all () {
	reset_except_it8951
	stop_process it8951-video
}

safe_reset_all () {
	reset_except_it8951
	is_running=$(ps aux | grep it8951-video | grep -v grep)
	if [[ -n "$is_running" ]]; then
		stop_process it8951-video
		# Wait a little for epaper to become ready again
		sleep 3
	fi
}

# 0. Prolog
# 00:01:38.00
0_prolog () {
	print_title "prolog"
	# play_square_video 0
	# play_epaper_video 0_Prolog.mp4
	# play_wide_video 0_Prolog.mp4
	play_audio 0_Prolog.wav
	standby 1 39
	safe_reset_all
}

# 1. Wasser
# 00:12:28.39
1_wasser () {
	print_title "wasser"
	# play_square_video 1
	play_epaper_video 1_Wasser.mp4
	play_wide_video 1_Wasser.mp4
	play_audio 1_Wasser.wav
	# standby 5 12 && send_udp_to_arduino 1 "test" &
	standby 12 29
	safe_reset_all
}

# 2. Sonne
# 00:05:53.13
2_sonne () {
	print_title "sonne"
	# play_square_video 2
	# play_epaper_video 2_Sonne.mp4
	# play_wide_video 2_Sonne.mp4
	play_audio 2_Sonne.wav
	standby 5 54
	safe_reset_all
}

# 3. Wind
# 00:07:19.58
3_wind () {
	print_title "wind"
	# play_square_video 3
	# play_epaper_video 3_Wind.mp4
	# play_wide_video 3_Wind.mp4
	play_audio 3_Wind.wav
	standby 7 20
	safe_reset_all
}

# 4. Anbahnung der Revolution
# 00:05:20.24
4_anbahnung_der_revolution () {
	print_title "anbahnung"
	# play_square_video 4
	# play_epaper_video 4_AnbahnungDerRevolution.mp4
	# play_wide_video 4_AnbahnungDerRevolution.mp4
	play_audio 4_AnbahnungDerRevolution.wav
	standby 5 21
	safe_reset_all
}

# 5. Feuer
# 00:03:16.86
5_feuer () {
	print_title "feuer"
	# play_square_video 5
	# play_epaper_video 5_Feuer.mp4
	# play_wide_video 5_Feuer.mp4
	play_audio 5_Feuer.wav
	standby 3 18
	safe_reset_all
}

# 6. Revolution
# 00:20:00.00
6_revolution () {
	print_title "revolution"
	# play_square_video 6
	# play_epaper_video 6_Revolution.mp4
	# play_wide_video 6_Revolution.mp4
	play_audio 6_Revolution.wav
	standby 20 1
	safe_reset_all
}

# This is our main installation loop, running forever!
loop () {
	while true
	do
		0_prolog
		1_wasser
		2_sonne
		3_wind
		4_anbahnung_der_revolution
		5_feuer
		6_revolution
	done
}

shutdown () {
	echo "Graceful shutdown"
	reset_all
}

# Set up a trap to always run shutdown function before we exit script
trap shutdown EXIT

clear

# Make sure to reset all processes before, just to be safe
safe_reset_all

if [[ -z $1 ]]; then
	loop
elif [[ $1 -eq 0 ]]; then
	0_prolog
elif [[ $1 -eq 1 ]]; then
	1_wasser
elif [[ $1 -eq 2 ]]; then
	2_sonne
elif [[ $1 -eq 3 ]]; then
	3_wind
elif [[ $1 -eq 4 ]]; then
	4_anbahnung_der_revolution
elif [[ $1 -eq 5 ]]; then
	5_feuer
elif [[ $1 -eq 6 ]]; then
	6_revolution
else
	echo "! unknown chapter selected"
fi
