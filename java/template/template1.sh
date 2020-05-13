#!/bin/bash

if [ $# -ne 6 ]; then
    echo "Error: Not Enough Parameter"
    exit 1
fi

cd $6

$(cat <<EOF >> $3.java
//課題番号${1} 問題番号${2} 提出日 ${4} ${5}

import java.util.Scanner;

public class ${3}{

    public static void main(String args[]){


    }

}
EOF
)
exit 0
