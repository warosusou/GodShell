#!/bin/bash

. Dictionary.sh

echo "-----debug start-----"
# ここに試したいコマンドを書く
while :
do
    ReadInput debug; key=$BUFF
    if [ "$key" = "quit" ]; then
	break;
    elif [ "$key" = "color" ]; then
	for i in `seq 30 37`
	do
	    for u in `seq 40 47`
	    do
		printf "\e[${i};${u}m${i}${u}だあああ\n\e[m"
	    done
	done
    else
	echo "$key" | xxd
    fi
done
echo "-----debug end-----"
