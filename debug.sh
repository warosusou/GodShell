#!/bin/bash

declare -a history
declare -i history_index
declare BUFF

function ReadInput () {

    history=("" ${history[@]})
    echo "${#history[@]}"

    function upArrow () {
	if [ ${history_index} -lt $((${#history[@]} - 1)) ]; then
	    ((++history_index))
	    BUFF=${history[${history_index}]}
	fi
    }

    function downArrow () {
	if [ ${history_index} -gt 0 ]; then
	    ((--history_index))
	    BUFF=${history[${history_index}]}
	fi
    }
    
    BUFF=
    while :
    do
	IFS= read -p "? > ${BUFF}" -s -n 1 k
	if [ "$k" = $'\x1b' ]; then
	    read -n 1 k
	    if [ "$k" = $'\x5b' ]; then
		read -n 1 k
		case $k in
		    $'\x41' ) upArrow ;;
		    $'\x42' ) downArrow ;;
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
	    history[0]=${BUFF}
	    history_index=0
	    break;
	else
	    BUFF=${BUFF}${k}
	fi
	printf "\e[100D\e[K"
    done
}

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
	ReadInput; want=$BUFF
	echo "$want"
    else
	echo "$key" | xxd
    fi
    #history=("$key" ${history[@]})
    echo "history = \"${history[@]}\""
done
echo "-----debug end-----"
