#!/bin/bash

INPUT=()
index=0

cd $3
gcc -Wall $2.c -o $2.out

echo "-----Compile end-----"

if [ $# -eq 4 ]; then
    echo "Input Planning Number : \"ban\" will be ban."
    while :
    do
	INPUT_BUF=()
	read -p "> " -a INPUT_BUF
	if [ ${INPUT_BUF[0]} = "ban" -a ${#INPUT_BUF[@]} -eq 1 ]; then
	    break;
	fi
	INPUT[${index}]="${INPUT_BUF[*]}"
	index=`expr $index + 1`
    done
elif [ $# -ne 3 ]; then
    echo "Error: Not Enough Parameter "
    exit 1
fi

#RESULT=$(cat <<EOF
#`./$2.out`
#EOF
#)

if [ $# -eq 4 ]; then
    RESULT=`echo ${INPUT[@]} | ./$2.out`

    echo "$RESULT"
    
    echo "-----Program end-----"
    
    echo "$2.txt was saved as new file."
    if [ ${#INPUT[@]} -eq 0 ]; then
	echo "${RESULT}" > $2.txt
    else
	printf "%s\n" "${INPUT[@]}" > $2.txt
	echo "${RESULT}" >> $2.txt
    fi
else
    ./$2.out
    echo "-----Program end-----"
    read -p "Need Emacs ? [ y : n ] > " NeedEmacs
    if [ "${NeedEmacs}" = y ]; then
	ALIVE=`ps -ef | grep $USERNAME | grep emacs | grep $2.txt | wc -l`
	if [ $ALIVE -eq 0 ]; then
	    echo "Starting Emacs"
	    emacs $2.txt &
	else
	    echo "Emacs already started"
	fi
    fi
fi

exit 0