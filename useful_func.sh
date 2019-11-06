#!/bin/bash

function isPartlyMatch () {
    if [ $# -lt 2 ]; then
	echo "Error to function isPartlyMatch()"
	echo "Unexpected number of argument."
	exit 1
    fi
    local former="$1"
    local -a latter=("${@:2}")
    for l in ${latter[@]}
    do
	if [ "$1" = "$l" ]; then
	    return 0
	fi
	if [[ ${former} == *${l}* ]]; then
	    return 0
	elif [[ ${l} == *${former}* ]]; then
	    return 0
	fi
    done
    return 1
}
