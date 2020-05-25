#!/bin/bash

function makeClass () {

    ClassName=$1
    
    function isUseReservedWords () {
        local classname=$1
        local -a ReservedWords=("abstract" "boolean" "break" "byte" "case" "catch" "char" "class" "const" "continue" "default" "do" "double" "else" "enum" "extends" "false" "final" "finally" "float" "for" "goto" "if" "import" "implements" "instanceof" "int" "interface" "long" "native" "new" "null" "package" "private" "protected" "public" "return" "short" "static" "strictfp" "super" "switch" "synchronize" "this" "throw" "throws" "transient" "true" "try" "void" "voltile" "while" "Applet" "Graphics" "Image" "String" "Integer" "MouseEvent" "MouseListener" "MouseMotionListener" "Button" "Choice" "ActionEvent" "ActionListener" "ItemEvent" "ItemListener" "Thread" "Runnable" "FlowLayout" "BorderLayout" "Panel" "Canvas")
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
                echo "そのClassNameは予約語もしくは開発環境として用意されている名前として登録されています。"
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
            startEmacs
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
    ls *.java >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo ".javaファイルが1つも存在しません。"
        return 1
    fi
    classname=(`ls *.java | sed 's/.java//g'`)
    cd $SCRIPT_DIR
    if [ "${#classname[@]}" -gt 2 ]; then
        for name in ${classname[@]}; do
            ((count++))
            echo "$count.  $name"
        done
        read -p "0~$countのクラスのいずれかを選択してください。 > " buf
        while [ $buf -lt 0 -o $count -lt $buf ];
        do
            read -p "範囲から外れています。もう一度入力してください。 > " buf
        done
        ClassName=${classname[$buf]}
    else
        if [ "${#classname[@]}" -eq 1 ]; then
            ClassName=${classname[0]}
        else
            if [ "$ClassName" = "${classname[0]}" ]; then
                ClassName="${classname[1]}";
            else
                ClassName="${classname[0]}"
            fi
        fi
    fi
    echo "編集クラスを$ClassName.javaに設定しました。"
    startEmacs
}

function changeDate () (
    cd $Working_DIR
    date=(`date | tr -s ' ' | cut -f 1 -d " "` `date | tr -s ' '  | cut -f 2 -d " "` `date | tr -s ' '  | cut -f 3 -d " "`)
    ls *.java >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        return 0
    fi
    for classname in `ls *.java`; do
        temp=`cat ${classname} | sed -e "1,4s/\(提出日\|[0-9]\{4\}年[0-9]\+月[0-9]\+日\)/${date[0]}${date[1]}${date[2]}/"`
        echo "$temp"  > $classname
    done
    echo "提出日を変更しました。 > ${date[0]}${date[1]}${date[2]}"
)

function loaderQuit () {
    changeDate
    cd $Working_DIR
    ls *.java >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        return 0
    fi
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
