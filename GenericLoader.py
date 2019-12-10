# -*- coding: utf-8 -*-
import sys
import os
import os.path
import datetime

def main():
    if len(sys.argv) != 3:
        print("NotEnoughArgs")
        return
    assign_num = sys.argv[1]
    question_num = sys.argv[2]
    target_dir = os.environ['HOME'] + "/Test/"
    working_dir = target_dir + assign_num + "/"

    if os.path.exists(working_dir) == False:
        os.makedirs(working_dir)
    now = datetime.datetime.now().strftime("%Y年%m月%d日")
    _template = ('''\
//課題番号%s 問題番号%s 提出日%s %s %s

#include <stdio.h>

int main(void){
  
  
  return 0;
}
    ''' %(assign_num ,question_num ,now ,"warosusou" ,"123456")).strip()
    _f = open(working_dir + question_num + ".c",'w')
    _f.write(_template)
    _f.close()

if __name__ == "__main__":
    main()
