#!/bin/bash

if [ $# -ne 2 -a $# -ne 3 ]; then
    printf "\e[31mエラー：予期していないパラメータ\e[m\n"
    printf "\e[3;4m使用法：\e[m./loader.sh [directory] 授業回 課題番号\n"
    printf "directoryは省略可能です。\n"
    printf "  \e[1mdirectory\e[mは以下の形式で書いてください。\n"
    printf "  >> ~/\"dir1\"/\"dir2\" ...\n"
    exit 1
fi

read -p "java? or c? [ ja : c ] > " conf
while [ "$conf" != "ja" -a "$conf" != "c" ]; do
    read -p "please input [ ja : c ] > " conf
done

case $conf in
    ja )
        cd java
        ;;
    c )
        cd c
        ;;
esac

./loader.sh $@
