#!/bin/bash
# Initialize dreijahreszeiten installation loop inside a tmux session

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

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

# xrandr --newmode "wide" 39.65  320 344 376 432  1480 1481 1484 1531  -HSync +Vsync
# xrandr --addmode $SCREEN_OUTPUT "wide"
xrandr --output $SCREEN_OUTPUT --pos 0x0 --auto --rotate $SCREEN_ROTATION # --output $SCREEN_2_OUTPUT --pos 0x0 --auto --rotate $SCREEN_ROTATION --same-as $SCREEN_2_OUTPUT

echo "🢒 Start installation loop inside session"
tmux new-session -d -t $TMUX_SESSION
tmux send-keys -t $TMUX_SESSION:0.0 "$BASE_DIR/scripts/wait.sh" Enter
