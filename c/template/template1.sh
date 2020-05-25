#!/bin/bash

if [ $# -ne 5 ]; then
    echo "error: Not Enough Parameter"
    exit 1
fi

cd $5

$(cat <<EOF >> $2.c
//第${1}回 課題${2} 提出日 ${3} ${4}

#include <stdio.h>

int main(void){
  
  
  return 0;
}
EOF
)
exit 0
