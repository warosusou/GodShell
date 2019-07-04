#!/bin/bash
MESSAGE=${2:-"fire"}

if [ $# -lt 1 ]; then
    echo "error: Not Enough Parameter"
    exit 1
fi

git fetch
git rebase origin/$1
git add -A
git commit -m "${MESSAGE}"
git push origin $1
