#!/bin/bash
# Wait for other devices to be ready before we start the loop

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

# Wait for the network to be ready
if [[ -z "$SKIP_WAIT" ]]; then
	echo "🢒 Wait for network"
	while ! nc -z $ARDUINO_1_HOST $ARDUINO_1_PORT; do
		sleep 0.5
	done
fi

# Wait a little bit more just to be sure
sleep 10

# Clear terminal just because it is nice
clear

# Finally .. run the installation loop!
$SCRIPT_DIR/loop.sh
