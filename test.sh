#!/bin/bash

. Dictionary.sh

dumpdir="./.dmpfile"

function arrayFilter () {
    local filter="$1"
    local -a array=("${@:2}")
    for arr in ${array[@]}
    do
	if [[ $arr =~ $filter ]]; then
	    echo $arr
	fi
    done
}

function JsonReader {
    local formattedjson=$(printf "$1" | sed 's/^{\(.*\)}$/\1/' | tr -d ',')
    echo "$formatterjson"
    local formattedinput=$(printf -- "$2" | sed 's/\([^a-zA-Z0-9 ]\)/\\\1/g')
    echo "$formattedinput"
    local result=$(printf "$formattedjson" | grep -w "${formattedinput}" | tr -d '"' | sed 's/^.+: //' )
    result=$(printf "$result" | sed "s/^ //"| sed "s/^${formattedinput}: //" )
    echo "$result"
}

function JsonAllKey {
    local parsedjson=$(printf "$1" | sed 's/^{//' | sed 's/}$//')
    local formattedjson=$(printf "$parsedjson" | sed 's/^{\(.*\)}$/\1/' | tr -d ',')
    local result=$(printf "$formattedjson" | tr -d '"' | sed 's/^.+: //' )
    result=$(printf "$result" | sed "s/^ //"| sed "s/^${formattedinput}: //" | sed "s/://g" | cut -d ' ' -f 1)
    echo "$result"
}

function Disassembler () {
    local String="$1"
    local -i len=1
    local -i i=0
    if [ "${#String}" -eq 0 ]; then return 1; fi
    while [ $i -lt ${#String} ]
    do
	local word="${String:i:len}"
	local next_escape="$(printf "${String:$i+$len:1}" | sed 's#\([\\|\*|\+|\.|\?|\{|\}|\(|\)|\/|\^|$|\|]\)#\\\1#g' | sed 's#\[#\\\[#g' | sed 's#\]#\\\]#g')"
	
	if [ "$next_escape" != " " -a $(expr $i + $len) -lt ${#String} ]; then
	    ((++len))
	    continue
	fi
	
	printf "${word}@"
	((i+=1+$len))
	len=1
    done
    printf "\n"
}

function rand () {

    local dumpfile="${dumpdir}/.randdmp"
    
    if [ $# -eq 3 ]; then
	local -i row=1
	local -i num=$1
	local -i min=$2
	local -i max=$3
    elif [ $# -eq 4 ]; then
	local -i row=$1
	if [ $row -lt 1 ]; then return; fi
	local -i num=$2
	local -i min=$3
	local -i max=$4
    else
	echo "BAN"; return 1
    fi

    if [ $num -lt 1 ]; then return; fi
    if [ $min -gt $max ]; then return; fi

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

function Analysis () {
    local arr=$(eval echo "$@")
   # local str="$(printf "$1" | tr -s ' ')"
   # local IFSbuff="$IFS"
   # IFS="@"
   # arr=($(Disassembler "$str"))
   # #Disassembler "$str"
   # IFS="$IFSbuff"
    arr=$(printf "$arr" | sed -e 's/\n */\\n/')
    echo -e "${arr}"
}

Config_File='./JsonFile/config.json'

#json=$(cat $Config_File)

#echo "$json"

#JsonAllKey "$json"

#arrayFilter "ba" "bash ban bil /a -a ./* *"

declare -a command

ReadInput "BAN?"; str="$BUFF"

#str='`rand 2 5 0 9` 000 00 `rand 2 2 0 9` `rand 2 2 0 9`'

while [ -n "$str" ]; do
    if [ "${str:0:1}" = "\`" ]; then
	command+=("$(printf "$str" | sed -E "s/^(\`[^\`]*\`).*/\1/")")
	str=$(printf "$str" | sed -E "s/^(\`[^\`]*\`)//" )
    else
	command+=("$(printf "$str" | sed -E "s/^(^[^ ]*).*/\1/")")
	str=$(printf "$str" | sed -E "s/^[^ ]*//")
    fi
    str=${str## }
done

declare -a result=()

for cmd in "${command[@]}"
do
    declare -i count=$((${#result[@]}-1))
    if [ $count -lt 0 ]; then count=0; fi
    if [ "${cmd:0:1}" = "\`" ]; then
	while read line || [ -n "${line}" ]
	do
	    result[$count]+="$line"
	    ((count++))
	done < ${dumpdir}/.randdmp
	result[$(($count-1))]+=" "
    else
	result[$count]+="$cmd "
    fi	
done

for i in $(seq 0 $((${#result[@]}-1)))
do
    result[$i]=${result[$i]%% }
done

for i in "${result[@]}"
do
    echo "$i"
done


#rand 2 5 0 9
