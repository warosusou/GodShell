#!/bin/bash

Question_NUM=$1

cpid=`ps -ef | grep $USERNAME | grep emacs | grep ${Question_NUM}.c | tr -s ' ' | cut -d ' ' -f 2`

while [ "$cpid" != "" ]
do
    cpid=`ps -ef | grep $USERNAME | grep emacs | grep ${Question_NUM}.c | tr -s ' ' | cut -d ' ' -f 2`
done

parents=`ps -ef | tr -s ' ' | cut -d ' ' -f 2 | grep $PPID`

if [ "parents" = "$PPID" ]; then
    kill -2 $PPID
fi
