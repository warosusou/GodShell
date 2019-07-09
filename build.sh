#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Error: Not Enough Parameter "
    exit 1
fi
cd ./$1
gcc -Wall $2.c -o $2.out

echo "-----Compile end-----"

./$2.out

echo "-----Program end-----"

exit 0