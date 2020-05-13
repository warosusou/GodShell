#!/bin/bash

. Dictionary.sh

Config_File='./JsonFile/config.json'
loaderFunction_File='./JsonFile/loaderFunc.json'

if [ $# -ne 2 -a $# -ne 3 ]; then
    printf "\e[31mエラー：予期していないパラメータ\e[m\n"
    printf "\e[3;4m使用法：\e[m./loader.sh [directory] 授業回 課題番号\n"
    printf "directoryは省略可能です。\n"
    printf "  \e[1mdirectory\e[mは以下の形式で書いてください。\n"
    printf "  >> ~/\"dir1\"/\"dir2\" ...\n"
    exit 1
fi

if [ ! -f $Config_File ]; then
    echo "名前を入力してください"
    read  StudentName
    echo "学籍番号を入力してください"
    read  StudentNumber
    echo "デフォルトのフォルダを選択してください"
    ReadInput -a "~/[directory1]/[directory2]...  :Input should be in this format" Folder; DefaultPath=$BUFF
    echo "テンプレートの種類を選択してください(1or2)"
    read Template
    DefaultPath=$(bash -c "echo $DefaultPath")
    if [ ! ${DefaultPath: -1} = / ]; then
	DefaultPath=${DefaultPath}/
    fi
    if [ $Template = "1" ]; then
	Template="./template/template1.sh"
    else
	Template="./template/template2.sh"
    fi
    json=""
    json=$(JsonWriter "$json" Name "$StudentName")
    json=$(JsonWriter "$json" StudentNumber "$StudentNumber")
    json=$(JsonWriter "$json" DefaultPath "$DefaultPath")
    json=$(JsonWriter "$json" Template "$Template")
    printf "$json" > $Config_File
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

(
    cd $Working_DIR
    if [ ! -f ${Question_NUM}.c ]; then
	(
	    cd ${SCRIPT_DIR}
	    $Template $Assign_NUM $Question_NUM "$StudentName" "$StudentNumber" $Working_DIR
	    changeDate
	)
    else
	echo "File already exsists..."
    fi
    startEmacs
)

while :
do
    ReadInput loader; DATA=($BUFF)
#    case $DATA in
#	"quit" )
#	    loaderQuit
#	    break;;
#	"build" )
#	    startBuild;;
#	"emacs" )
#	    startEmacs;;
#	"debug" )
#	    bash debug.sh;;
#	* )
#	    otherCommand
#   esac
    json=$(cat $loaderFunction_File)
    if [ "$DATA" != "" ]; then
	    Command=$(JsonReader "$json" "${DATA[0]}")
	    ${Command:-"otherCommand"} ${DATA[@]:1}
	    if [ "$Command" = "loaderQuit" ]; then break; fi
    fi
done
