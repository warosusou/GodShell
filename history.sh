#!/bin/bash

#function load_history () {
#    local historyPath="$(cd $(dirname $0); pwd)/.history"
#    if [ -s "$historyPath" ]; then cat "$historyPath"; fi
#}

function save_history () { #第一引数にInputtedCommand、第二引数にdirectory（デフォルト：./.history）
    local command="$1"
    local historyPath="${2:-$(cd $(dirname $0); pwd)/.history}"
    if [ ! -s "$historyPath" ]; then
	touch .history
	echo "$command"  > .history
    elif [ "$command" != "" ]; then
	sed -i "1i$1" "$historyPath"
	if [ `wc -l < $historyPath` -gt 30 ]; then
	    sed -i -e '$d' "$historyPath"
	fi
    fi
}
