#!/bin/bash

. Dictionary.sh

declare -A KeyCode=(
    [$'\x1b\x5b\x41']="up arrow"
    [$'\x1b\x5b\x43']="right arrow"
    [aaa]="AAA"
    [aab]="AAB"
)

function search_key () {
    local -A newCode
    local -i class=$1
    read -s -n 1 _key
    totalkey=${totalkey}${_key}
    printf "${totalkey}" | xxd
    for mkey in ${!KeyCode[@]};
    do
	if [ "`echo ${mkey} | grep -F ${totalkey}`" ]; then
	    newCode+=([$mkey]=${KeyCode[$mkey]})
	fi
    done
    echo -e "${!newCode[@]}" | xxd
    echo -e "${newCode[@]}" | xxd	    
    echo -e "${newCode[@]:-ban}" | xxd
    if [ "${#newCode[@]}" -gt 1 ]; then
	search_key class+1
    elif [ "${#newCode[@]}" -eq 1 ]; then
	echo -e "${newCode[@]}"
	totalkey=
    fi
    
}

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
    elif [ "$key" = "IFSxxd" ]; then
        printf "$IFS" | xxd
    elif [ "$key" = "typing" ]; then
	#read -n 1 k[0]
	#read -n 1 k[1]
	#read -n 1 k[2]
	#for _k in ${!KeyCode[@]};
	#do
	#    if [ "$k" = "$_k" ]; then
	#	echo "${KeyCode[$k]}"
	#    fi
	#done
	search_key 0
    else
	echo "$key" | xxd
    fi
done
echo "-----debug end-----"
