#!/bin/bash

INPUT=()
index=0

if [ $# -ne 3 ]; then
    echo "Error: Not Enough Parameter "
    exit 1
fi

cd $3
gcc -Wall $2.c -o $2.out
cstatus=$?

echo "-----Compile end-----"

if [ $cstatus -eq 0 ]; then
    printf "\e[32;1mCompling success.\e[m\n"
else
    printf "\e[31;1mCompling Error.\e[m\n"
    exit 1
fi

read -p "automation-mode ? [ y : n ] > " auto
if [ "${auto}" = "y" ]; then
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
fi

#RESULT=$(cat <<EOF
#`./$2.out`
#EOF
#)

if [ "${auto}" = "y" ]; then
    RESULT=`echo ${INPUT[@]} | ./$2.out`

    echo "$RESULT"
    
    echo "-----Program end-----"
    
    echo "$2.txt was saved as new file."
    if [ ${#INPUT[@]} -eq 0 ]; then
	echo "${RESULT}" > $2.txt
    else
	printf "%s\n" "${INPUT[@]}" > $2.txt
	printf "\n" >> $2.txt
	echo "${RESULT}" >> $2.txt
    fi
else
    ./$2.out
    echo "-----Program end-----"
    read -p "Need Emacs ? [ y : n ] > " NeedEmacs
    if [ "${NeedEmacs}" = "y" ]; then
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
