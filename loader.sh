#!/bin/bash

. Dictionary.sh
. Json.sh

Config_File='./config.json'

if [ $# -ne 2 -a $# -ne 3 ]; then
    printf "\e[31mError: Unexpected Parameter\e[m\n"
    printf "\e[3;4mUsage:\e[m  ./loader.sh [directory] 授業回 課題番号\n"
    exit 1
fi

if [ ! -f $Config_File ]; then
    echo "名前を入力してください"
    read  StudentName
    echo "学籍番号を入力してください"
    read  StudentNumber
    echo "デフォルトのフォルダを選択してください"
    read  DefaultPath
    echo "テンプレートの種類を選択してください(1or2)"
    read Template
    DefaultPath=$(bash -c "echo $DefaultPath")
    if [ ! ${DefaultPath: -1} = / ]; then
	DefaultPath=${DefaultPath}/
    fi
    if [ $Template = "1" ]; then
	Template="./template1.sh"
    else
	Template="./template2.sh"
    fi
    cat <<EOS > $Config_File
{
 "Name": "${StudentName}"
 "StudentNumber": "${StudentNumber}"
 "DefaultPath": "${DefaultPath}"
 "Template": "${Template}"
}
EOS
else
    json=$(cat $Config_File)
    StudentName=$(JsonReader "$json" Name)
    StudentNumber=$(JsonReader "$json" StudentNumber)
    DefaultPath=$(bash -c "echo $(JsonReader "$json" DefaultPath)")
    Template=$(JsonReader "$json" Template)
fi
if [ $# -eq 2 ]; then
    Assign_NUM=$1
    Question_NUM=$2
    Target_DIR=$DefaultPath
fi

if [ $# -eq 3 ]; then
    Assign_NUM=$2
    Question_NUM=$3
    Target_DIR=$1
    if [ ! ${Target_DIR: -1} = / ]; then
	Target_DIR=${Target_DIR}/
    fi
fi
if [ ! -d $Target_DIR ]; then
    mkdir $Target_DIR
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
    $Template $Assign_NUM $Question_NUM "$StudentName" "$StudentNumber" $Working_DIR
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
    ReadInput loader; DATA=$BUFF
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
	cd ${SCRIPT_DIR}
	bash debug.sh
    else
	echo "Unknown Command"
    fi
done