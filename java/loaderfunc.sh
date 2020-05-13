#!/bin/bash

function makeClass () {

    ClassName=$1
    
    function isUseReservedWords () {
        local classname=$1
        local -a ReservedWords=("abstract" "boolean" "break" "byte" "case" "catch" "char" "class" "const" "continue" "default" "do" "double" "else" "enum" "extends" "false" "final" "finally" "float" "for" "goto" "if" "import" "implements" "instanceof" "int" "interface" "long" "native" "new" "null" "package" "private" "protected" "public" "return" "short" "static" "strictfp" "super" "switch" "synchronize" "this" "throw" "throws" "transient" "true" "try" "void" "voltile" "while")
        for word in ${ReservedWords[@]}; do
            if [ "$classname" = "$word" ]; then
                return 0
            fi
        done
        return 1
    }
    
    if [ $# -lt 1 ]; then
        read -p "Class名を入力してください > " ClassName
    fi
    
    while :
    do
        if [[ "${ClassName:0:1}" =~ ^[0-9] ]]; then
            echo "Classの先頭は文字列である必要があります。"
            read -p "Class名を入力してください > " ClassName
            continue
        elif [[ "${ClassName:0:1}" =~ ^[a-z] ]]; then
            if isUseReservedWords $ClassName; then
                echo "そのClassNameは予約語として登録されています。"
                read -p "Class名を入力してください > " ClassName
                continue
            fi
            echo "Classの先頭は大文字にすることが望まれています。"
            read -p "Class名を再入力しますか？ [ y : n ] > " -n 1 conf
            printf "\n"
            if [ "$conf" = "y" ]; then
                read -p "Class名を入力してください > " ClassName
                continue
            fi
        fi
        break
    done
        
    
    cd $Working_DIR
    if [ ! -f ${ClassName}.java ]; then
	    (
	        cd ${SCRIPT_DIR}
	        $Template $Assign_NUM $Question_NUM $ClassName "$StudentName" "$StudentNumber" $Working_DIR
	        changeDate
	    )
    else
	    echo "File already exsists..."
    fi
    startEmacs
    selectClass $ClassName
    cd $SCRIPT_DIR
}

function selectClass () {
    if [ $# -gt 1 ]; then
        echo "引数が多すぎます。 Too much argument"
    elif [ $# -eq 1 ]; then
        cd $Working_DIR
        if [ -f $1.java ]; then
            ClassName=$1
            echo "編集クラスを$ClassName.javaに設定しました。"
            return 0
        else
            echo "そのようなClassは存在しません。"
            read -p "$1.javaを作成しますか？ [ y : n ] > " -n 1 buf
            printf "\n"
            if [ "$buf" = "y" ]; then
                makeClass $1
            fi
        fi
    fi
    local count=-1
    cd $Working_DIR
    classname=(`ls *.java | tr -d .java`)
    cd $SCRIPT_DIR
    if [ $count -gt 0 ]; then
        for name in ${classname[@]}; do
            ((count++))
            echo "$count.  $classname"
        done
        read -p "0~$countのクラスのいずれかを選択してください。 > " buf
        if [ 0 -ge $buf -a $buf -ge $count ]; then
            ClassName=${classname[$buf]}
        fi
    else
        ClassName=${classname[0]}
    fi
    echo "編集クラスを$ClassName.javaに設定しました。"
}

function changeDate () (
    cd $Working_DIR
    date=(`date | tr -s ' ' | cut -f 1 -d " "` `date | tr -s ' '  | cut -f 2 -d " "` `date | tr -s ' '  | cut -f 3 -d " "`)
    for classname in `ls *.java`; do
        temp=`cat ${classname} | sed -e "1,4s/\(提出日\|[0-9]\{4\}年[0-9]\+月[0-9]\+日\)/${date[0]}${date[1]}${date[2]}/"`
        echo "$temp"  > $classname
    done
    echo "提出日を変更しました。 > ${date[0]}${date[1]}${date[2]}"
)

function loaderQuit () {
    changeDate
    cd $Working_DIR
    for classname in `ls *.java`; do
        ALIVE=`ps -ef | grep $USERNAME | grep emacs | grep ${classname} | wc -l`
        PROCESS_ID=`ps -ef | grep $USERNAME | grep emacs | grep ${classname} | tr -s ' ' | cut -d ' ' -f 2`
        if [ $ALIVE -eq 1 ]; then
            kill ${PROCESS_ID}
        elif [ $ALIVE -ge 2 ]; then
	        echo "emacsが多重起動されています。--未定義動作"
	        kill ${PROCESS_ID}  
        fi
    done
}

function startBuild () (
    cd ${SCRIPT_DIR}
    bash build.sh "${Assign_NUM}" "${Question_NUM}" "${Working_DIR}" "${ClassName}"
)


function startEmacs () (
    cd $Working_DIR
    ALIVE=`ps -ef | grep $USERNAME | grep emacs | grep ${ClassName}.java | wc -l`
    if [ $ALIVE -eq 0 ]; then
	    echo "Starting Emacs"
	    emacs ${ClassName}.java &
	    PROCESS_ID=$!
    else
	    echo "Emacs already started"
    fi
)

function otherCommand () (
    echo "Unknown Command."
)

function changeConfig () (
    cd $SCRIPT_DIR
    ls JsonFile
    
)

function Opentxt () (
    cd ${Working_DIR}
    emacs $ClassName.txt &
    echo "${ClassName}.txtを開きました。"
)
