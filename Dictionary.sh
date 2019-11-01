declare -a history
declare -i history_index=0
declare BUFF

function ReadInput () { #第一引数にstatusを第二引数にhistory機能有効化[y,n](未実装)を書く

    local -i cchar=0

    status=${1:-\?}
    history=("" ${history[@]})

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
    
    BUFF=
    while :
    do
	if [ $((${#BUFF}-$cchar)) -eq 0 ]; then
	    printf "$status > ${BUFF}"
	else
	    printf "$status > ${BUFF}\e[$((${#BUFF}-$cchar))D"
	fi
	IFS= read -s -n 1 k
	if [ "$k" = $'\x1b' ]; then
	    read -n 1 k
	    if [ "$k" = $'\x5b' ]; then
		read -n 1 k
		case $k in
		    $'\x41' ) upArrow ;;
		    $'\x42' ) downArrow ;;
		    $'\x43' ) rightArrow ;;
		    $'\x44' ) leftArrow ;;
		esac
	    fi
	elif [ "$k" = $'\x7f' ]; then
	    if [ ${#BUFF} -gt 0 ]; then
		BUFF=`echo "${BUFF:0:${#BUFF}-1}"`
		((--cchar))
	    fi
	elif [ "$k" = ""  ]; then
	    printf "\n"
	    if [ "${BUFF}" = "${history[1]}" ]; then
		history[0]=""
	    else
		history[0]=${BUFF}
	    fi
	    history_index=0
	    cchar=0
	    break;
	else
	    if [ $cchar -eq ${#BUFF} ]; then
		BUFF=${BUFF}${k}
	    elif [ $cchar -eq 0 ]; then
		BUFF=${k}${BUFF}
	    else
		BUFF=${BUFF:0:$cchar}${k}${BUFF:$cchar}
	    fi
	    ((++cchar))
	    history[0]=${BUFF}
	fi
	printf "\e[100D\e[K"
    done
}
