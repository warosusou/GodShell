#!/bin/bash

. Dictionary.sh

INPUT=()

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
	#read -p "> " -a INPUT_BUF
	ReadInput "build"; INPUT_BUF="$BUFF"
	if [ "${INPUT_BUF}" = "ban" ]; then
	    break;
	fi

	while [ -n "$INPUT_BUF" ]; do
	    if [ "${INPUT_BUF:0:1}" = "\`" ]; then
		command+=("$(printf "$INPUT_BUF" | sed -E "s/^(\`[^\`]*\`).*/\1/")")
		INPUT_BUF=$(printf "$INPUT_BUF" | sed -E "s/^(\`[^\`]*\`)//" )
	    else
		command+=("$(printf "$INPUT_BUF" | sed -E "s/^(^[^ ]*).*/\1/")")
		INPUT_BUF=$(printf "$INPUT_BUF" | sed -E "s/^[^ ]*//")
	    fi
	    INPUT_BUF=${INPUT_BUF## }
	done

	for cmd in "${command[@]}"
	do
	    index=$((${#INPUT[@]}-1))
	    if [ $index -lt 0 ]; then index=0; fi
	    if [ "${cmd:0:1}" = "\`" ]; then
		while read line || [ -n "${line}" ]
		do
		    INPUT[$index]+="$line"
		    ((index++))
		done < ${dumpdir}/.randdmp
		INPUT[$(($index-1))]+=" "
	    else
		INPUT[$index]+="$cmd "
	    fi	
	done
	((index++))
    done
    for i in $(seq 0 $((${#INPUT[@]}-1)))
    do
	INPUT[$i]=${INPUT[$i]%% }
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
