#!/bin/bash

function JsonReader {
    local formattedjson=$(printf "$1" | sed 's/^{\(.*\)}$/\1/' | tr ',' '\n')
    local result=$(printf "$formattedjson" | grep -w -e $2 | tr -d '"' | sed 's/^.+: //' )
    result=$(printf "$result" | sed "s/$2: //" | sed "s/^ //")
    echo "$result"
}
