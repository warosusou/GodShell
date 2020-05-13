#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)
USERNAME=$(whoami)
dumpdir="${SCRIPT_DIR}/.dmpfile"

. useful_func.sh
. Json.sh
. history.sh
. ReadInput.sh
. loaderfunc.sh


