#!/bin/bash

function JsonReader {
    local formattedjson=$(printf "$1" | sed 's/^{\(.*\)}$/\1/' | tr ',' '\n')
    local formattedinput=$(printf -- "$2" | sed 's/\(\W\)/\\\1/g')
    local result=$(printf "$formattedjson" | grep -w "${formattedinput}" | tr -d '"' | sed 's/^.+: //' )
    result=$(printf "$result" | sed "s/^ //"| sed "s/^${formattedinput}: //" )
    echo "$result"
}
