#!/bin/bash
# Stop all currently running processes

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

echo "Stop all running processes"
reset_all
