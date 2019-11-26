#!/bin/bash

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
	((++len))
	if [ "$next_escape" = "\(" ]; then
	    while [ "${next_escape}" != "\)" ];
	    do
		word=${word}${next_escape}
		if [ $(expr $i + $len) -gt ${#String} ]; then return 1; fi
		local next_escape="$(printf "${String:$i+$len:1}" | sed 's#\([\\|\*|\+|\.|\?|\{|\}|\(|\)|\/|\^|$|\|]\)#\\\1#g' | sed 's#\[#\\\[#g' | sed 's#\]#\\\]#g')"
		((++len))
	    done
	else
	    if [ "$next_escape" != " " -a $(expr $i + $len) -lt ${#String} ]; then
		((++len))
		continue
	    fi
	fi
	
	printf "${word}@"
	((i+=1+$len))
	len=1
    done
    printf "\n"
}

function Analysis () {
    local -a arr
    local str="$(printf "$1" | tr -s ' ')"
    local IFSbuff="$IFS"
    IFS="@"
    #arr=($(Disassembler "$str"))
    Disassembler "$str"
    IFS="$IFSbuff"
    echo "${arr[@]}"
}

Config_File='./JsonFile/config.json'

json=$(cat $Config_File)

#echo "$json"

#JsonAllKey "$json"

#arrayFilter "ba" "bash ban bil /a -a ./* *"

str="rand(3,3,3) 3 3"

arr=($(Analysis "$str"))

echo "${#arr[@]}"
echo "${arr[@]}"
