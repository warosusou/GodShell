#!/bin/bash

declare -a INPUT=()
index=0

if [ $# -eq 4 ]; then
    echo "Input Planning Number : \"ban\" will be ban."
    while :
    do
	read INPUT[${index}]
	if [ ${INPUT[${index}]} = "ban" ]; then
	    unset INPUT[${index}]
	    break;
	fi
	index=`expr $index + 1`
    done
elif [ $# -ne 3 ]; then
    echo "Error: Not Enough Parameter "
    exit 1
fi
cd $3
gcc -Wall $2.c -o $2.out

echo "-----Compile end-----"

RESULT=$(cat <<EOF
`./$2.out`
EOF
)
echo "$RESULT"

echo "-----Program end-----"

if [ $# -eq 4 ]; then
    echo "$2.txt was saved as new file."
    if [ ${#RESULT[@]} -eq 0 ]; then
	echo "${RESULT}" > $2.txt
    else
	printf "%s\n" "${INPUT[@]}" > $2.txt
	echo "${RESULT}" >> $2.txt
    fi
fi

exit 0