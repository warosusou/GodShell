#!/bin/bash

declare -a history

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
	    IFS= read -p "? > ${BUFF}" -s -n 1 k
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
	    elif [ "$k" = $'\x7f' ]; then
		if [ ${#BUFF} -gt 0 ]; then
		    BUFF=`echo "${BUFF:0:${#BUFF}-1}"`
		fi
	    elif [ "$k" = ""  ]; then
		printf "\n"
		echo "${BUFF}" | xxd
		BUFF=""
		break;
	    else
		BUFF=${BUFF}${k}
	    fi
	    printf "\e[100D\e[K"
	done
    else
	echo "$key" | xxd
    fi
    history+=("$key")
    echo "history = \"${history[@]}\""
done
echo "-----debug end-----"
