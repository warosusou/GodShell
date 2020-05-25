#!/bin/bash

if [ $# -ne 6 ]; then
    echo "Error: Not Enough Parameter"
    exit 1
fi

cd $6

$(cat <<EOF >> $3.java
//第${1}回 課題${2} 提出日 ${4} ${5}

import java.util.Scanner;

public class ${3}{

    public static void main(String args[]){


    }

}
EOF
)
exit 0
