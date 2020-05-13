#!/bin/bash

declare -a history
declare -i history_index=0
declare BUFF

function ReadInput () { #第一引数にstatusを第二引数にhistory機能有効化[y,n](未実装)を書く
    
    function getOption () {
	while [ $# -gt 0 ]
	do
	    case "$1" in
		-* )
		    option+=("${1:1}")
		    if isPartlyMatch "$1" a; then
			shift
			if [ "${1:0:1}" = "-" ]; then
			    echo "Error to function getOption()"
			    echo "Syntax Error"
			    exit 1
			else
			    inp_assist="$1"
			fi
		    fi
		;;
		* )
		    non_option+=("$1")
		;;
	    esac
	    shift
	done
    }

    function upArrow () {
	if [ ${history_index} -lt $((${#history[@]} - 1)) ]; then
	    ((++history_index))
	    BUFF=${history[${history_index}]}
	    cchar=${#BUFF}
	fi
    }

    function downArrow () {
	if [ ${history_index} -gt 0 ]; then
	    ((--history_index))
	    BUFF=${history[${history_index}]}
	    cchar=${#BUFF}
	fi
    }

    function leftArrow () {
	if [ $cchar -gt 0 ]; then
	    ((--cchar))
	fi
    }

    function rightArrow () {
	if [ ${cchar} -lt ${#BUFF} ]; then
	    ((++cchar))
	fi
    }

    function Deletekey () {
	if [ $cchar -lt ${#BUFF} ]; then
	    BUFF=`echo "${BUFF:0:$cchar}${BUFF:${cchar}+1}"`
	fi
    }

    function BackSpacekey () {
	if [ ${cchar} -gt 0 ]; then
	    BUFF=`echo "${BUFF:0:${cchar}-1}${BUFF:$cchar}"`
	    ((--cchar))
	fi
    }

    function Tabkey () { #第一引数にTabを押したときに表示されるCommand(default=build)
	local json=$(cat $loaderFunction_File)
	local -a CommandList=$(JsonAllKey "$json")
	local -a exception=($(arrayFilter "$BUFF" "${CommandList[@]}"))
	if [ "${#exception[@]}" -ne 0 ]; then
	    if [ "${#exception[@]}" -eq 1 ]; then
		BUFF=${exception[0]}
		cchar=${#BUFF}
	    else
		printf "\n"	
		echo "${exception[@]}"
	    fi
	fi
	
    }

    function Enterkey () {
	printf "\n"
	BUFF=`printf -- "$BUFF" | sed "s/\s*$//"`
	if [ "${BUFF}" != "${history[1]}" ]; then
	    save_history "$BUFF"
	fi
	history_index=0
	cchar=0
    }

    function Addchar () {
	if [ $cchar -eq ${#BUFF} ]; then
	    BUFF=${BUFF}${k}
	elif [ $cchar -eq 0 ]; then
	    BUFF=${k}${BUFF}
	else
	    BUFF=${BUFF:0:$cchar}${k}${BUFF:$cchar}
	fi
	((++cchar))
	history[0]=${BUFF}
    }

    local -i cchar=0

    local -a option
    local -a non_option
    getOption "$@"
    local -a history=("")
    if [ -s .history ]; then
	while read LINE
	do
	    history+=("$LINE")
	done <.history
    fi
    local status="${non_option[0]:-\?}"
    
    if [ ${#option[@]} -eq 0 ]; then option+=("@"); fi
    BUFF=
    
    while :
    do
	if [ $((${#BUFF}-$cchar)) -eq 0 ]; then
	    if isPartlyMatch a ${option[@]} && [ ${#BUFF} -eq 0 ]; then
		printf "$status > \e[3;38;5;245m${inp_assist}\e[m\e[${#inp_assist}D"
	    else
		printf "$status > ${BUFF}"
	    fi
	else
	    printf "$status > ${BUFF}\e[$((${#BUFF}-$cchar))D"
	fi
	IFS= read -s -n 1 k
	case $k in
	    $'\x1b' )
		read -n 1 k
		case $k in
		    $'\x5b' )
			read -n 1 k
			case $k in
			    $'\x33' )
				read -n 1 k
				case $k in
				    $'\x7e' ) Deletekey ;;
				esac
				;;
			    $'\x41' ) upArrow ;;
                            $'\x42' ) downArrow ;;
			    $'\x43' ) rightArrow ;;
			    $'\x44' ) leftArrow ;;
                        esac
                        ;;
                esac
                ;;
            $'\x7f' ) BackSpacekey ;;
	    $'\x09' ) Tabkey ;;
	    "" ) Enterkey; break; ;;
	    * ) Addchar ;;
	esac
	printf "\e[100D\e[K"
    done
}
