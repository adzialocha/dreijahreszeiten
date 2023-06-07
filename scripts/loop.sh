#!/bin/bash
# Installation loop for dreijahreszeiten

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

# Base folder where all media files live
FILES_DIR=$BASE_DIR/files

print_title () {
	figlet -f slant $1
	echo ""
}

wait_until () {
	seconds=$((($1 * 60) + $2))
	echo "⏹ wait for $seconds seconds ($1:$2)"
	sleep $seconds
}

send_udp () {
	rkpzavav --endpoint $2:$3 --message $1
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
		echo "🛆  unknown arduino identifier"
	fi
}

send_udp_to_steppers () {
	send_udp_to_arduino 1 $1
}

send_udp_to_servo_and_rotation () {
	send_udp_to_arduino 2 $1
}

send_udp_to_led () {
	send_udp_to_arduino 3 $1
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
	it8951-video --take $EPAPER_TAKE --ghost $EPAPER_GHOST $FILES_DIR/video-epaper/$1 &> /dev/null &
	# Make the others wait a little bit since the display takes some time to start
	sleep 0.5
}

move_single_camera_randomly () {
	seconds=$((($1 * 60) + $2))
	start_at=$(date +%s)
	end_at=$(($start_at + $seconds))
	while [ $(date +%s) -lt $end_at ]
	do
		value=$(shuf -i $4-$5 -n 1)
		sleep_value=$(seq 0.25 .01 1 | shuf | head -n1)
		send_udp_to_servo_and_rotation $3,$value
		sleep $sleep_value
	done
}

move_all_cameras_randomly () {
	move_single_camera_randomly $1 $2 $KAMERA_L_ID $KAMERA_L_MIN $KAMERA_L_MAX &
	move_single_camera_randomly $1 $2 $KAMERA_R_ID $KAMERA_R_MIN $KAMERA_R_MAX &
}

move_berlin_up () {
	send_udp_to_steppers $BERLIN_ID,$BERLIN_MAX,$BERLIN_SPEED
}

move_berlin_down () {
	send_udp_to_steppers $BERLIN_ID,$BERLIN_MIN,$BERLIN_SPEED
}

move_eisberg_back () {
	send_udp_to_steppers $EISBERG_ID,$EISBERG_MAX,$EISBERG_SPEED
}

move_eisberg_front () {
	send_udp_to_steppers $EISBERG_ID,$EISBERG_MIN,$EISBERG_SPEED
}

move_fenster_up () {
	send_udp_to_steppers $FENSTER_ID,$FENSTER_MAX,$FENSTER_SPEED
}

move_fenster_down () {
	send_udp_to_steppers $FENSTER_ID,$FENSTER_MIN,$FENSTER_SPEED
}

move_hong_kong_up () {
	send_udp_to_steppers $HONGKONG_ID,$HONGKONG_MAX,$HONGKONG_SPEED
}

move_hong_kong_down () {
	send_udp_to_steppers $HONGKONG_ID,$HONGKONG_MIN,$HONGKONG_SPEED
}

enable_schiff () {
	send_udp_to_servo_and_rotation $SCHIFF_ENABLE
}

disable_schiff () {
	send_udp_to_servo_and_rotation $SCHIFF_DISABLE
}

enable_wind () {
	send_udp_to_servo_and_rotation $WIND_ENABLE
}

disable_wind () {
	send_udp_to_servo_and_rotation $WIND_DISABLE
}

reset_motors () {
	send_udp_to_steppers $BERLIN_ID,$BERLIN_MIN,$MAX_STEP_SPEED
	send_udp_to_steppers $EISBERG_ID,$EISBERG_MIN,$MAX_STEP_SPEED
	send_udp_to_steppers $FENSTER_ID,$FENSTER_MIN,$MAX_STEP_SPEED
	send_udp_to_steppers $HONGKONG_ID,$HONGKONG_MIN,$MAX_STEP_SPEED
	send_udp_to_servo_and_rotation $KAMERA_L_ID,$KAMERA_STANDBY
	send_udp_to_servo_and_rotation $KAMERA_R_ID,$KAMERA_STANDBY
	disable_schiff
	disable_wind
}

stop_process () {
	pkill -INT -x $1
}

reset_except_it8951 () {
	play_square_video ST
	stop_process aplay
	stop_process mplayer
	stop_process "sleep"
}

reset_all () {
	reset_motors
	reset_except_it8951
	stop_process it8951-video
}

safe_reset_all () {
	reset_except_it8951
	is_running=$(ps aux | grep it8951-video | grep -v grep)
	if [[ -n "$is_running" ]]; then
		stop_process it8951-video
		# Wait a little for epaper to become ready again
		sleep 0.5
	fi
}

# 0. Prolog
# 00:01:38.00
0_prolog () {
	print_title "prolog"

	play_epaper_video 0E.mp4
	play_square_video 0S
	play_wide_video 0W.mp4
	play_audio 0.wav

	wait_until 1 39
	safe_reset_all
}

# 1. Wasser
# 00:12:28.39
1_wasser () {
	print_title "wasser"

	play_epaper_video 1E.mp4
	play_square_video 1S
	play_wide_video 1W.mp4
	play_audio 1.wav

	move_fenster_up
	wait_until 5 57 && move_fenster_down &
	wait_until 7 30 && move_all_cameras_randomly 0 5 &

	wait_until 12 29
	safe_reset_all
}

# 2. Sonne
# 00:05:53.13
2_sonne () {
	print_title "sonne"

	play_epaper_video 2E.mp4
	play_square_video 2S
	play_wide_video 2W.mp4
	play_audio 2.wav

	wait_until 3 30 && move_all_cameras_randomly 0 5 &

	wait_until 5 54
	safe_reset_all
}

# 3. Wind
# 00:07:19.58
3_wind () {
	print_title "wind"

	play_epaper_video 3E.mp4
	play_square_video 3S
	play_wide_video 3W.mp4
	play_audio 3.wav

	wait_until 3 51 && enable_schiff &
	wait_until 4 50 && enable_wind && move_hong_kong_up &
	wait_until 7 20 && disable_schiff &

	wait_until 7 20
	safe_reset_all
}

# 4. Anbahnung der Revolution
# 00:05:20.24
4_anbahnung_der_revolution () {
	print_title "anbahnung"

	play_epaper_video 4E.mp4
	play_square_video 4S
	play_wide_video 4W.mp4
	play_audio 4.wav

	wait_until 0 59 && move_all_cameras_randomly 0 23 &
	wait_until 1 55 && move_hong_kong_down &
	wait_until 2 25 && disable_wind &
	wait_until 2 30 && move_all_cameras_randomly 0 28 &
	wait_until 4 8 && move_all_cameras_randomly 0 46 &

	wait_until 5 21
	safe_reset_all
}

# 5. Feuer
# 00:03:16.86
5_feuer () {
	print_title "feuer"

	play_epaper_video 5E.mp4
	play_square_video 5S
	play_wide_video 5W.mp4
	play_audio 5.wav

	move_eisberg_front
	wait_until 1 40 && move_eisberg_back &

	wait_until 3 18
	safe_reset_all
}

# 6. Revolution
# 00:20:00.00
6_revolution () {
	print_title "revolution"

	play_epaper_video 6E.mp4
	play_square_video 6S
	play_wide_video 6W.mp4
	play_audio 6.wav

	move_berlin_up
	wait_until 2 30 && move_all_cameras_randomly 0 2 &
	wait_until 7 30 && move_all_cameras_randomly 0 5 &
	wait_until 10 51 && enable_schiff &
	wait_until 11 00 && disable_schiff &
	wait_until 18 30 && move_berlin_down &

	wait_until 20 1
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
	echo ""
	reset_all
}

# Set up a trap to always run shutdown function before we exit script
trap shutdown EXIT

# Move all motors to initial positions
reset_motors

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
	echo "🛆  unknown chapter selected"
fi
