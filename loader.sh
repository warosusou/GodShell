#!/bin/bash

if [ $# -ne 2 ]; then
    echo "error: Not Enough Parameter"
    exit 1
fi

USERNAME=$(whoami)
SCRIPT_DIR=$(cd $(dirname $0); pwd)

if [ ! -d $1 ]; then
    mkdir $1
fi
cd $1
if [ ! -f ${2}.c ]; then
    echo "/*" >> $2.c
    echo "課題"$1 >> $2.c
    echo "問"$2 >> $2.c
    echo "提出日" >> $2.c
    echo "BP19076" >> $2.c
    echo "石川太朗" >> $2.c
    echo "*/" >> $2.c
    echo >> $2.c
    echo "#include<stdio.h>" >> $2.c
    echo >> $2.c
    echo "int main(){" >> $2.c
    echo "  " >> $2.c
    echo "  " >> $2.c
    echo "  " >> $2.c
    echo "  return 0;" >> $2.c
    echo "  " >> $2.c
    echo "}" >> $2.c
else
    echo "File already exsists..."
fi

  ALIVE=`ps -ef | grep $USERNAME | grep emacs | grep ${2}.c | wc -l`

if [ $ALIVE -eq 0 ]; then
    echo "Starting Emacs"
    emacs $2.c &
    PROCESS_ID=$!
else
    PROCESS_ID=`ps -ef | grep $USERNAME | grep emacs | grep ${2}.c | cut -f 3 -d " "`
    echo "Emacs already started"
fi

while :
do
    read -p "loader > " DATA
    if [ "$DATA" = "quit"  ];then
	echo "提出日??"
        kill ${PROCESS_ID}
	break;
    elif [ "$DATA" = "build" ]; then
	cd ${SCRIPT_DIR}
	bash build.sh "${1}" "${2}"
	cd $1
    elif [ "$DATA" = "emacs" ]; then
	ALIVE=`ps -ef | grep $USERNAME | grep emacs | grep ${2}.c | wc -l`
	if [ $ALIVE -eq 0 ]; then
	    echo "Starting Emacs"
	    emacs $2.c &
	    PROCESS_ID=$!
	else
	    echo "Emacs already started"
	fi
    else
	echo "Unknown Command"
    fi
done