#!/bin/bash

function JsonReader {
    function ReadByKey {
	local result=$(printf "$1" | grep "$2" | sed 's/^.+://' | tr -d '"')
	echo $result
    }
    local json=$(cat $1)
    local formattedjson="$(printf $json | sed 's/^{\(.*\)}$/\1/' | tr ',' '\n')"
    local results=()
    while [ "$#" -gt 1 ]; do
	results+=`ReadByKey $formattedjson $2`
    done
    echo ${results[@]}
}

if [ $# -ne 2 -a $# -ne 3 ]; then
    echo "error: Unexpected Parameter"
    echo $#
    exit 1
fi

if [ -f config.json ]; then
    json=$(cat config.json)
fi

if [ $# -eq 2 ]; then
    Assign_NUM=$1
    Question_NUM=$2
    Target_DIR=~/eip2/
fi

if [ $# -eq 3 ]; then
    Assign_NUM=$2
    Question_NUM=$3
    Target_DIR=$1
    if [ ! ${Target_DIR: -1} = / ]; then
	Target_DIR=${Target_DIR}/
    fi
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

    date=(`date | tr -s ' ' | cut -f 1 -d " "` `date | tr -s ' '  | cut -f 2 -d " "` `date | tr -s ' '  | cut -f 3 -d " "`)
    temp=`cat $Question_NUM.c | sed -e "1,4s/\(提出日\|[0-9]\{4\}年[0-9]\+月[0-9]\+日\)/${date[0]}${date[1]}${date[2]}/"`
    echo "$temp"  > $Question_NUM.c
    echo "提出日を変更しました。 > ${date[0]}${date[1]}${date[2]}"
else
    echo "File already exsists..."
fi

ALIVE=`ps -ef | grep $USERNAME | grep emacs | grep ${Question_NUM}.c | wc -l`

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
	cd ${Working_DIR}
	date=(`date | tr -s ' ' | cut -f 1 -d " "` `date | tr -s ' '  | cut -f 2 -d " "` `date | tr -s ' '  | cut -f 3 -d " "`)
	temp=`cat $Question_NUM.c | sed -e "1,4s/\(提出日\|[0-9]\{4\}年[0-9]\+月[0-9]\+日\)/${date[0]}${date[1]}${date[2]}/"`
	echo "$temp"  > $Question_NUM.c
	echo "提出日が変更されました。 > ${date[0]}${date[1]}${date[2]}"

	ALIVE=`ps -ef | grep $USERNAME | grep emacs | grep ${Question_NUM}.c | wc -l`
	PROCESS_ID=`ps -ef | grep $USERNAME | grep emacs | grep ${Question_NUM}.c | tr -s ' ' | cut -d ' ' -f 2`
	if [ $ALIVE -eq 1 ]; then
            kill ${PROCESS_ID}
	elif [ $ALIVE -ge 2 ]; then
	    echo "emacsが多重起動されています。--未定義動作"
	    kill ${PROCESS_ID}
	fi
	break;
    elif [ "$DATA" = "build" ]; then
	read -p "automation-mode ? [ y : n ] > " auto
	cd ${SCRIPT_DIR}
	if [ "${auto}" = "y" ]; then 
	    bash build.sh "${Assign_NUM}" "${Question_NUM}" "${Working_DIR}" "auto"
	else
	    bash build.sh "${Assign_NUM}" "${Question_NUM}" "${Working_DIR}"
	fi
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
    elif [ "$DATA" = "debug" ]; then
	cd ${SCRIPT_DIR}
	bash debug.sh
    else
	echo "Unknown Command"
    fi
done
