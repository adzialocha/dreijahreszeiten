#!/bin/bash
# Wait for other devices to be ready before we start the loop

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

HTTP_PORT=80

if [[ -z "$SKIP_BRIGHT_SIGN" ]]; then
	echo "🢒 Wait for brightsign controller to be ready"
	while ! nc -z $BRIGHT_SIGN_HOST $HTTP_PORT; do
		sleep 0.5
	done
fi

# Clear terminal just because it is nice
clear

# Finally run the installation loop
$SCRIPT_DIR/loop.sh
