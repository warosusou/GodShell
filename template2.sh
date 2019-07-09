#!/bin/bash

if [ $# -ne 2 ]; then
    echo "error: Not Enough Parameter"
    exit 1
fi
cd $1

echo "//課題番号"${1}" 問題番号"${2}" 提出日 "" 学籍番号 名前" >> $2.c
echo "" >> $2.c
echo "#include <stdio.h>" >> $2.c
echo "" >> $2.c
echo "int main(void){" >> $2.c
echo "  " >> $2.c
echo "  " >> $2.c
echo "  return 0;" >> $2.c
echo "}" >> $2.c
exit 0