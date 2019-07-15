#!/bin/bash
MESSAGE=${2:-"fire"}

if [ $# -lt 1 ]; then
    echo "error: Not Enough Parameter"
    exit 1
fi

cp ~/eip1/loader.sh ~/gitrepo/GodShell
cp ~/eip1/build.sh ~/gitrepo/GodShell

cd ~/gitrepo/GodShell

git fetch
git rebase origin/$1
git pull
git commit -a -m "${MESSAGE}"
git push origin $1
