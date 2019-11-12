#!/bin/bash

function JsonReader {
    local formattedjson=$(printf "$1" | sed 's/^{\(.*\)}$/\1/' | tr ',' '\n')
    local formattedinput=$(printf -- "$2" | sed 's/\([^a-zA-Z0-9 ]\)/\\\1/g')
    local result=$(printf "$formattedjson" | grep -w "${formattedinput}" | tr -d '"' | sed 's/^.+: //' )
    result=$(printf "$result" | sed "s/^ //"| sed "s/^${formattedinput}: //" )
    echo "$result"
}

function JsonKeyFinder {
    local formattedjson=$(printf "$1" | sed 's/^{\(.*\)}$/\1/' | tr ',' '\n')
    local targetline=$(printf "$formattedjson" | grep $2 | sed 's/^\s//')
    echo "$targetline"
}

function JsonWriter {
    local json="$1"
    local key=$2
    local value=$3
    local result=""
    local exsistvalue=$(jsonKeyFinder "$json" $key)
    if [ "$exsistvalue" = "" ]; then
	result=$(printf "$json" | sed "/.*/N;s/\n}$/,\n \"$key\": \"$value\"\n}/")
    else
	result=$(printf "$json" | sed "s/\"$key\":\s\".*\"/\"$key\": \"$value\"/")
    fi
    echo "$result"
}