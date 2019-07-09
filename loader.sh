#!/bin/bash

if [ $# -ne 2 -a $# -ne 3 ]; then
    echo "error: Unexpected Parameter"
    echo $#
    exit 1
fi

if [ $# -eq 2 ]; then
    Assign_NUM=$1
    Question_NUM=$2
    Target_DIR=~/eip1/
fi

if [ $# -eq 3 ]; then
    Assign_NUM=$2
    Question_NUM=$3
    Target_DIR=$1
fi

Working_DIR=$Target_DIR$Assign_NUM
USERNAME=$(whoami)
SCRIPT_DIR=$(cd $(dirname $0); pwd)

if [ ! -d $Working_DIR ]; then
    mkdir $Working_DIR
fi
cd $Working_DIR
if [ ! -f ${Question_NUM}.c ]; then
    cd ${SCRIPT_DIR}
    ./template.sh $Assign_NUM $Question_NUM $Working_DIR
    cd $Working_DIR
else
    echo "File already exsists..."
fi

  ALIVE=`ps -ef | grep $USERNAME | grep emacs | grep ${Question_NUM}.c | wc -l`

if [ $ALIVE -eq 0 ]; then
    echo "Starting Emacs"
    emacs $Question_NUM.c &
    PROCESS_ID=$!
else
    PROCESS_ID=`ps -ef | grep $USERNAME | grep emacs | grep ${Question_NUM}.c | cut -f 3 -d " "`
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
	bash build.sh "${Assign_NUM}" "${Question_NUM}" "${Working_DIR}"
	cd $Working_DIR
    elif [ "$DATA" = "emacs" ]; then
	ALIVE=`ps -ef | grep $USERNAME | grep emacs | grep ${Question_NUM}.c | wc -l`
	if [ $ALIVE -eq 0 ]; then
	    echo "Starting Emacs"
	    emacs $Question_NUM.c &
	    PROCESS_ID=$!
	else
	    echo "Emacs already started"
	fi
    else
	echo "Unknown Command"
    fi
done