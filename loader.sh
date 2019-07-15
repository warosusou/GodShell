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
    ../template.sh $1 $2
else
    echo "File already exsists..."
fi

  ALIVE=`ps -ef | grep $USERNAME | grep emacs | grep ${2}.c | wc -l`

if [ $ALIVE -eq 0 ]; then
    echo "Starting Emacs"
    emacs $Question_NUM.c &
else
    echo "Emacs already started"
fi

while :
do
    read -p "loader > " DATA
    if [ "$DATA" = "quit"  ];then
	echo "提出日??"
	ALIVE=`ps -ef | grep $USERNAME | grep emacs | grep ${Question_NUM}.c | wc -l`
	PROCESS_ID=`ps -ef | grep $USERNAME | grep emacs | grep ${Question_NUM}.c | cut -f 3 -d " "`
	if [ $ALIVE -eq 1 ]; then
            kill ${PROCESS_ID}
	elif [ $ALIVE -ge 2 ]; then
	    echo "emacsが多重起動されています。--未定義動作"
	    kill ${PROCESS_ID}
	fi
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