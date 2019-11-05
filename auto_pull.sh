#!/bin/bash

declare -a branch=()
lsbranch=(`git branch`)
allfile=(`ls`)

git_status=(`git status`)
now_branch=${git_status[2]}

for lsb in ${lsbranch[@]}
do
    for file in ${allfile[@]}
    do
	if [ "$lsb" = "$file" ]; then
	    continue 2;
	fi
    done
    branch+=("$lsb")
done

for b in ${branch[@]}
do
    git checkout $b
    git pull
done

git checkout $now_branch
