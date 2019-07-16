#!/bin/bash
MESSAGE=${2:-"fire"}

if [ $# -lt 1 ]; then
    echo "error: Not Enough Parameter"
    exit 1
fi

git commit -a -m "${MESSAGE}"
git push origin $1
