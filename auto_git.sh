#!/bin/bash
MESSAGE=${1:-"fire"}

if [ $# -ne 1 ]; then
    echo "error: Not Enough Parameter"
    exit 1
fi

git pull
git add -A
git commit -m "${MESSAGE}"
git push origin fire