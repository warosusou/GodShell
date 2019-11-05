#!/bin/bash

function JsonReader {
    function ReadByKey {
	local result=$(printf "$1" | grep $2 | tr -d '"' | sed 's/^.+: //' )
	result=$(printf "$result" | sed "s/$2: //")
	echo $result
    }
    local json=$(cat $1)
    local formattedjson=$(cat $1 | sed 's/^{\(.*\)}$/\1/' | tr ',' '\n')
    local results=()
    local index=0
    while [ "$2" != "" ]
    do
	results[$index]+=`ReadByKey "$formattedjson" $2`
	index=`expr $index + 1`
	shift
    done
    echo ${results[@]}
}
Config_File='./config.json'

if [ $# -ne 2 -a $# -ne 3 ]; then
    echo "error: Unexpected Parameter"
    echo $#
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
    ConfigStudentName=$(echo "$StudentName" | sed 's/ /__/g')
    if [ $Template = "1" ]; then
	Template="./template1.sh"
    else
	Template="./template2.sh"
    fi
    cat <<EOS > $Config_File
{
 "Name": "${ConfigStudentName}"
 "StudentNumber": "${StudentNumber}"
 "DefaultPath": "${DefaultPath}"
 "Template": "${Template}"
}
EOS
else
    declare -a jsons=($(JsonReader $Config_File Name StudentNumber DefaultPath Template))
    StudentName=$(echo "${jsons[0]}" | sed 's/__/ /g')
    StudentNumber="${jsons[1]}"
    DefaultPath=$(bash -c "echo ${jsons[2]}")
    Template="${jsons[3]}"
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
    read -p "loader > " DATA
    if [ "$DATA" = "quit"  ];then
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
	read -p "submit mode? y / n( else ) > " MODE
	if [ $MODE = "y" ]; then
	    bash build.sh "${Assign_NUM}" "${Question_NUM}" "${Working_DIR}" submit
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