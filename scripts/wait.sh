#!/bin/bash
# Wait for other devices to be ready before we start the loop

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

wait_until_online () {
	while ! nc -z $1 $2; do
		sleep 0.5
	done
}

# Wait for everything to be ready
if [[ -z "$SKIP_WAIT" ]]; then
	echo "🢒 Wait for network"
	wait_until_online $ARDUINO_1_HOST $ARDUINO_1_PORT
	wait_until_online $ARDUINO_2_HOST $ARDUINO_2_PORT
	wait_until_online $ARDUINO_3_HOST $ARDUINO_3_PORT
	wait_until_online $BRIGHT_SIGN_HOST $BRIGHT_SIGN_PORT
	echo "🢒 Wait for the right time to start installation (from $START_HOUR)"
	while [[ $(date +"%H") -lt $START_HOUR ]]; do
		sleep 0.5
	done
fi

# Wait a little bit more just to be sure
echo "🢒 Wait for 10 seconds"
sleep 10

# Clear terminal just because it is nice
clear

# Finally .. run the installation loop!
$SCRIPT_DIR/loop.sh
