#!/bin/bash

if [ $# -ne 5 ]; then
    echo "Error: Not Enough Parameter"
    exit 1
fi

cd $5

echo "/*" >> $2.c
echo "課題"$1 >> $2.c
echo "問"$2 >> $2.c
echo "提出日" >> $2.c
echo "$4" >> $2.c
echo "$3" >> $2.c
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