#!/bin/bash
MESSAGE=${1:-"fire"}

git fetch
git rebase origin/master
git add -A
git commit -m "${MESSAGE}"
git push origin master