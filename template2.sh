#!/bin/bash

if [ $# -ne 3 ]; then
    echo "Error: Not Enough Parameter"
    exit 1
fi

cd $3

echo "/*" >> $2.c
echo "課題"$1 >> $2.c
echo "問"$2 >> $2.c
echo "提出日" >> $2.c
echo "学籍番号" >> $2.c
echo "氏名" >> $2.c
echo "*/" >> $2.c
echo >> $2.c
echo "#include<stdio.h>" >> $2.c
echo >> $2.c
echo "int main(){" >> $2.c
echo "  " >> $2.c
echo "  " >> $2.c
echo "  " >> $2.c
echo "  return 0;" >> $2.c
echo "  " >> $2.c
echo "}" >> $2.c

exit 0