#!/bin/bash
# Initialize dreijahreszeiten installation loop inside a tmux session

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

HTTP_PORT=80
SCREEN_ROTATION=left
SCREEN_OUTPUT=HDMI2

if [[ -z "${DISPLAY}" ]]; then
	echo "🛆  no xorg display exists. exit start script"
	exit 0
fi

if [[ "$(tmux ls 2> /dev/null | grep $TMUX_SESSION)" != "" ]]; then
	echo "🛆  tmux session already exists. exit start script"
	exit 0
fi

echo "🢒 Setup screen"
xrandr --output $SCREEN_OUTPUT --rotate $SCREEN_ROTATION

echo "🢒 Wait for brightsign controller to be ready"
while ! nc -z $BRIGHT_SIGN_HOST $HTTP_PORT; do
	sleep 0.5
done

echo "🢒 Start installation loop inside session"
tmux new-session -d -t $TMUX_SESSION
tmux send-keys -t $TMUX_SESSION:0.0 "$BASE_DIR/scripts/loop.sh" Enter
