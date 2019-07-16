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

    date=(`date | cut -f 1 -d " "` `date | cut -f 3 -d " "` `date | cut -f 4 -d " "`)
    temp=`cat $Question_NUM.c | sed -e "4,4s/.*/${date[0]}${date[1]}${date[2]}/"`
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
	date=(`date | cut -f 1 -d " "` `date | cut -f 3 -d " "` `date | cut -f 4 -d " "`)
	temp=`cat $Question_NUM.c | sed -e "4,4s/.*/${date[0]}${date[1]}${date[2]}/"`
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
    elif [ "$DATA" = "debug" ]; then
	echo "-----debug start-----"
	# ここに試したいコマンドを書く
	while :
	do
	read -p "debug > " key
	if [ "$key" = "quit" ]; then
	    break;
	elif [ "$key" = "color" ]; then
	    for i in `seq 30 37`
	    do
		for u in `seq 40 47`
		do
		    printf "\e[${i};${u}m${i}${u}だあああ\n\e[m"
		done
	    done
	else
	  echo "$key" | hexdump 
	fi
	done
	echo "-----debug end-----"
    else
	echo "Unknown Command"
    fi
done