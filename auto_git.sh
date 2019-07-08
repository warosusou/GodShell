#!/bin/bash
MESSAGE=${2:-"fire"}

if [ $# -lt 1 ]; then
    echo "error: Not Enough Parameter"
    exit 1
fi

cp ~/eip1/loader.sh loader.sh
cp ~/eip1/build.sh build.sh

git fetch
git rebase origin/$1
git add -A
git commit -m "${MESSAGE}"
git push origin $1
