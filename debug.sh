#!/bin/bash

echo "-----debug start-----"
# ここに試したいコマンドを書く
while :
do
    read -p "debug > " key
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
    elif [ "$key" = "typing" ]; then
	while :
	do
	    read -p "? > ${BUFF}" -n 1 k
	    BUFF=${BUFF}${k}
	    printf "\e[100D"
	    if [ "${#BUFF}" -ge 10 ]; then
		printf "\n"
		break;
	    fi
	done
    else
	echo "$key" | hexdump 
    fi
done
echo "-----debug end-----"