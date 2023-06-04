#!/bin/bash
# Stop tmux session which runs installation loop

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

echo "Stop installation loop"
tmux kill-session -t $TMUX_SESSION
