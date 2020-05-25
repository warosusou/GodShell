#!/bin/bash

if [ $# -ne 5 ]; then
    echo "Error: Not Enough Parameter"
    exit 1
fi

cd $5

$(cat <<EOF >> $2.c
/*
第${1}回
課題${2}
提出日
${4}
${3}
*/

#include<stdio.h>

int main(){
  
  
  
  return 0;
  
}
EOF
)

exit 0
