#!/bin/bash

function JsonReader {
    local formattedjson=$(printf "$1" | sed 's/^{\(.*\)}$/\1/' | tr ',' '\n')
    local formattedinput=$(printf -- "$2" | sed 's/\([^a-zA-Z0-9 ]\)/\\\1/g')
    local result=$(printf "$formattedjson" | grep -w "${formattedinput}" | tr -d '"' | sed 's/^.+: //' )
    result=$(printf "$result" | sed "s/^ //"| sed "s/^${formattedinput}: //" )
    echo "$result"
}

function JsonLineFinder {
    local formattedjson=$(printf "$1" | sed 's/^{\(.*\)}$/\1/' | tr ',' '\n')
    local targetline=$(printf "$formattedjson" | grep $2 | sed 's/^\s//')
    echo "$targetline"
}

function JsonWriter {
    local json="$1"
    local key=$(printf "$2" | sed 's#\([\\|\*|\+|\.|\?|\{|\}|\(|\)|\/|\^|$|\|]\)#\\\1#g' | sed 's#\[#\\\[#g' | sed 's#\]#\\\]#g')
    local value=$(printf "$3" | sed 's#\([\\|\*|\+|\.|\?|\{|\}|\(|\)|\/|\^|$|\|]\)#\\\1#g' | sed 's#\[#\\\[#g' | sed 's#\]#\\\]#g')

    local result=""

    #json形式ではないものをBAN
    local parsedjson=$(printf "$json" | sed 's/^{//' | sed 's/}$//')
    if [ "$parsedjson" = "$json" ]; then
	json=""
    fi

    if [ $(printf "$json" | wc -l) -gt 0 ];then
	local exsistline=$(JsonLineFinder "$json" $key)
	if [ "$exsistline" = "" ]; then
	    local lastlinenumber=$((--$(printf "$json" | wc -l)))
	    result=$(printf "$json" | sed "${lastlinenumber}N;s/\n\}/,\n \"$key\": \"$value\"\n}/")
	else
	    result=$(printf "$json" | sed "s/\"$key\":\s\".*\"/\"$key\": \"$value\"/")
	fi
	echo "$result"
    else
	result=$(cat <<EOF
{
 "${key}": "${value}"
}
EOF
	)
	echo "$result"
    fi
}

function JsonAllKey {
    local parsedjson=$(printf "$1" | sed 's/^{//' | sed 's/}$//')
    local formattedjson=$(printf "$parsedjson" | sed 's/^{\(.*\)}$/\1/' | tr -d ',')
    local result=$(printf "$formattedjson" | tr -d '"' | sed 's/^.+: //' )
    result=$(printf "$result" | sed "s/^ //"| sed "s/^${formattedinput}: //" | sed "s/://g" | cut -d ' ' -f 1)
    echo "$result"
}
