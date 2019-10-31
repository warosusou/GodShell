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
	    read -p "? > ${BUFF}" -s -n 1 k
	    if [ "$k" = $'\x1b' ]; then
		read -n 1 k
		if [ "$k" = $'\x5b' ]; then
		    read -n 1 k
		    case $k in
		        $'\x41' ) echo "up arrow" ;;
			$'\x42' ) echo "down arrow" ;;
			$'\x43' ) echo "left arrow" ;;
			$'\x44' ) echo "right arrow" ;;
		    esac
		fi
	    else
		BUFF=${BUFF}${k}
	    fi
	    printf "\e[100D"
	    if [ "${#BUFF}" -ge 10 ]; then
		printf "\n"
		BUFF=""
		break;
	    fi
	done
    else
	echo "$key" | xxd
    fi
done
echo "-----debug end-----"
