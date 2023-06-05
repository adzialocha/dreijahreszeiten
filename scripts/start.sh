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
# xrandr
# HDMI2 connected 1480x320+0+0 left (normal left inverted right x axis y axis)
# 1480mm x 480mm 320x1480      60.08*+  60.04
xrandr --output $SCREEN_OUTPUT --rotate $SCREEN_ROTATION --mode 1480x320 --rate 60.08

echo "🢒 Start installation loop inside session"
tmux new-session -d -t $TMUX_SESSION
tmux send-keys -t $TMUX_SESSION:0.0 "$BASE_DIR/scripts/wait.sh" Enter
