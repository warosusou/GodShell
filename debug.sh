#!/bin/bash

. Dictionary.sh

declare -A KeyCode=(
    [$'\x1b\x5b\x41']="upArrow"
    [$'\x1b\x5b\x42']="downArrow"
    [$'\x1b\x5b\x43']="rightArrow"
    [$'\x1b\x5b\x44']="leftArrow"
    [$'\x1b\x5b\x33\x7e']="Deletekey"
    [$'\x7f']="BackSpacekey"
    [$'\x09']="Tabkey"
    [$'\xff']="Enterkey"
)

function search_key_debug () {
    local -A newCode
    local -i depth=${1:-0}
    IFS= read -s -n 1 _key
    totalkey=${totalkey}${_key:-$'\xff'}
    printf "${totalkey}" | xxd
    for mkey in "${!KeyCode[@]}";
    do
	if [[ ${mkey} == "${totalkey}"* ]]; then
	    newCode+=([$mkey]=${KeyCode[$mkey]})
	    if [[ ${mkey} == "${totalkey}" ]]; then
		echo "${newCode[@]}"
		totalkey=
		return 0
	    fi
	fi
	echo -e "$mkey" | xxd
    done
    echo -e "${!newCode[@]}" | xxd
    echo -e "${newCode[@]}" | xxd	    
    echo -e "${newCode[@]:-ban}" | xxd
    if [ "${#newCode[@]}" -gt 0 ]; then
	search_key_debug class+1
    else
	if [ "$depth" -eq 0 ]; then
	    echo -e "$totalkey"
	else
	    echo "error"
	    totalkey=
	    return 1
	fi
    fi
    totalkey=
    return 0
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
	search_key_debug
    else
	echo "$key" | xxd
    fi
done
echo "-----debug end-----"
