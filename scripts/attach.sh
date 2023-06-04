#!/bin/bash
# Attach to running installation tmux session

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

tmux attach -t $TMUX_SESSION
