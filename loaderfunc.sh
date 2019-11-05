#!/bin/bash

function changeDate () (
    cd $Working_DIR
    date=(`date | tr -s ' ' | cut -f 1 -d " "` `date | tr -s ' '  | cut -f 2 -d " "` `date | tr -s ' '  | cut -f 3 -d " "`)
    temp=`cat $Question_NUM.c | sed -e "1,4s/\(提出日\|[0-9]\{4\}年[0-9]\+月[0-9]\+日\)/${date[0]}${date[1]}${date[2]}/"`
    echo "$temp"  > $Question_NUM.c
    echo "提出日を変更しました。 > ${date[0]}${date[1]}${date[2]}"
)

function loaderQuit () {
    changeDate
    ALIVE=`ps -ef | grep $USERNAME | grep emacs | grep ${Question_NUM}.c | wc -l`
    PROCESS_ID=`ps -ef | grep $USERNAME | grep emacs | grep ${Question_NUM}.c | tr -s ' ' | cut -d ' ' -f 2`
    if [ $ALIVE -eq 1 ]; then
        kill ${PROCESS_ID}
    elif [ $ALIVE -ge 2 ]; then
	echo "emacsが多重起動されています。--未定義動作"
	kill ${PROCESS_ID}
    fi
}

function startBuild () {
    cd ${SCRIPT_DIR}
    bash build.sh "${Assign_NUM}" "${Question_NUM}" "${Working_DIR}"
    cd $Working_DIR
}

function startEmacs () {
    cd $Working_DIR
    ALIVE=`ps -ef | grep $USERNAME | grep emacs | grep ${Question_NUM}.c | wc -l`
    if [ $ALIVE -eq 0 ]; then
	echo "Starting Emacs"
	emacs $Question_NUM.c &
	PROCESS_ID=$!
    else
	echo "Emacs already started"
    fi
}
