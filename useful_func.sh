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

function arrayFilter () { #第一変数にinputを、第二変数に配列を置く。
    local filter="$1"
    local -a array=("${@:2}")
    for arr in ${array[@]}
    do
	if [[ $arr =~ ^$filter ]]; then
	    echo $arr
	fi
    done
}

function rand () {

    local dumpfile="${dumpdir}/.randdmp"

    if [ $# -eq 2 ]; then
	local -i row=1
	local -i num=$1
	local -i min=1
	local -i max=$2
    elif [ $# -eq 3 ]; then
	local -i row=1
	local -i num=$1
	local -i min=$2
	local -i max=$3
    elif [ $# -eq 4 ]; then
	local -i row=$1
	if [ $row -lt 1 ]; then echo "BAN"; return 1; fi
	local -i num=$2
	local -i min=$3
	local -i max=$4
    else
	echo "BAN"; return 1
    fi

    if [ $num -lt 1 ]; then echo "BAN"; return; fi
    if [ $min -gt $max ]; then echo "BAN"; return; fi

    local -i i

    if [ ! -d "$dumpdir" ]; then
	mkdir "$dumpdir"
    fi
    
    if [ -f "$dumpfile" ]; then
	rm "$dumpfile"
    fi

    for i in `seq $row`; do
	for u in `seq $num`; do
	    printf "%d" $(($min + $RANDOM % ($max - $min + 1))) >> $dumpfile
	    if [ $u -ne $num ]; then printf " "  >> $dumpfile; fi
	done
	if [ $i -ne $row ]; then printf "\n" >> $dumpfile; fi
    done
    cat $dumpfile
}
