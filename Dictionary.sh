#!/bin/bash

declare -a history
declare -i history_index=0
declare BUFF

function ReadInput () { #第一引数にstatusを書く

    local -i cchar=0

    status=${1:-\?}
    history=("" ${history[@]})
    local -A KeyCode=(
	[$'\x1b\x5b\x41']="upArrow"
	[$'\x1b\x5b\x42']="downArrow"
	[$'\x1b\x5b\x43']="rightArrow"
	[$'\x1b\x5b\x44']="leftArrow"
	[$'\x1b\x5b\x33\x7e']="Deletekey"
	[$'\x7f']="BackSpacekey"
	[$'\x09']="Tabkey"
	[$'\xff']="Enterkey"
    )

    function search_key () {
	local -A newCode
	local -i depth=${1:-0}
	IFS= read -s -n 1 _key
	totalkey=${totalkey}${_key:-$'\xff'}
	#printf "${totalkey}" | xxd
	for mkey in "${!KeyCode[@]}";
	do
	    if [[ "${mkey}" == "${totalkey}"* ]]; then
		newCode+=([$mkey]=${KeyCode[$mkey]})
		if [[ "${mkey}" == "${totalkey}" ]]; then
		    echo "${newCode[@]}"
		    totalkey=
		    return 0
		fi
	    fi
	done
	#echo -e "${!newCode[@]}" | xxd
	#echo -e "${newCode[@]}" | xxd	    
	#echo -e "${newCode[@]:-ban}" | xxd
	if [ "${#newCode[@]}" -gt 0 ]; then
	    search_key class+1
	else
	    if [ "$depth" -eq 0 ]; then
		echo -e "$totalkey"
	    else
		echo "error"
		totalkey=
		return 1
	    fi
	fi
	totalkey=
	return 0
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
	BUFF=${1:-"build"}
	cchar=${#BUFF}
    }

    function Enterkey () {
	printf "\n"
	if [ "${BUFF}" = "${history[1]}" ]; then
	    history[0]=""
	else
	    history[0]=${BUFF}
	fi
	history_index=0
	cchar=0
	return 0
    }

    function Addchar () {
	if [ ${cchar:=0} -eq ${#BUFF} ]; then
	    BUFF=${BUFF}${k}
	elif [ $cchar -eq 0 ]; then
	    BUFF=${k}${BUFF}
	else
	    BUFF=${BUFF:0:$cchar}${k}${BUFF:$cchar}
	fi
	((++cchar))
	history[0]=${BUFF}
    }

    BUFF=
    while :
    do
	if [ $((${#BUFF}-$cchar)) -eq 0 ]; then
	    printf "$status > ${BUFF}"
	else
	    printf "$status > ${BUFF}\e[$((${#BUFF}-$cchar))D"
	fi
	#IFS= read -s -n 1 k
	#case $k in
	#    $'\x1b' )
	#	read -n 1 k
	#	case $k in
	#	    $'\x5b' )
	#		read -n 1 k
	#		case $k in
	#		    $'\x33' )
	#			read -n 1 k
	#			case $k in
	#			    $'\x7e' ) Deletekey ;;
	#			esac
	#			;;
	#		    $'\x41' ) upArrow ;;
        #                    $'\x42' ) downArrow ;;
	#		    $'\x43' ) rightArrow ;;
	#		    $'\x44' ) leftArrow ;;
        #                esac
        #               ;;
        #        esac
        #        ;;
        #    $'\x7f' ) BackSpacekey ;;
	#    $'\x09' ) Tabkey ;;
	#    "" ) Enterkey; break; ;;
	#    * ) Addchar ;;
	#esac
	k=`search_key`
	if [ ${#k} -eq 1 ]; then
	    Addchar
	else
	    $k
	    if [ "$k" = "Enterkey" ]; then break; fi
	fi
	
	printf "\e[100D\e[K"
    done
}
