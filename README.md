神SHell
# --GodShell--

## Description
Linux縛りプログラミング言語演習最適化プログラム  
<s>頑なにLinuxで言語演習をやらせてくる教授に反抗するための効率化Shell</s>  
「Linuxってなんだよ！」「Windowsしか使ったことねぇよ！」「ls? mkdir? cd? gcc?」な人はこれを導入してください。作業効率が１万倍になります。プログラミング演習のほうにしっかりと意識を向けることができるようになります。  
「え？、提出するの.cファイルと出力結果の.txt！？めんどくさすぎだろ！…  
ええとemacs xx.txt &して…コピーして、貼り付け！よし、できた。」の君。まだGodShell知らないの？これ使えばその面倒は一切味わいませんよ？  

C言語、Java対応  

なんとloader内のコマンドは全てTab自動補完対応（まぁbuildしか打たないのでb [Tab]が早いくらいですね）  
さらにhistory機能内蔵。これにより4x4の行列入力サンプルをプログラムミスを直すたびに打つ必要がなくなります。

さらに上級者向けの機能ですが、4x4の行列などの簡単な入力を自動化するためのrandコマンドを実装しています。  
詳細は後述

## Demo

No Demo  

## Usage
`./loader.sh [ ディレクトリ直接指定 ] 課題番号(第n回講義) 問番号`  
上記コマンドにより、指定ディレクトリ（デフォルトディレクトリを後に選択可能）内に以下の構造のフォルダを生成  
ex)C言語loader  
Default_DIR  
└課題番号  
　└問番号.c  
初コマンド実行の場合はConfig_Fileの情報の入力。うまくいかなかった場合/c(or java)/ConfigFile/config.jsonを直接いじることにより修正可能  

### Usage of C loader

#### コマンド一覧  
- build  
言うことはない。コンパイル＆実行のビルドコマンドです。  
automation-modeに y を入力すると提出ファイルへの書き込みを自動的に行ってくれます。サンプルの入力を保存でき、矢印キーで呼び出せるようになります。デバッグに有効です。  
しかし入力ごとに出力が繰り返されるプログラムには適さない場合が多いです。提出ファイルへの出力の体裁が崩れます。  
automation-mode y のときのみ rand コマンドが使用できます。  
\`(バッククオート)で括ったうえでrandの書式を入力してください。  
***rand 書式***  
`rand [ 行個数 ] [ 列個数 ] 最小値 最大値`  

- quit  
loader終了コマンドです。  
<s>loaderは優秀なので</s>emacsも自動で閉じてくれます。  
- emacs  
emacsを閉じてしまった場合に再度開くことができます。  
- txt  
提出ファイルを開いて確認することができます。
- config  
誠意製作中  

### Usage of Java loader

#### コマンド一覧
- build, quit, emacs, txt, config  
C loaderと機能は全く一緒です。
- make [ クラス名 ]  
Classの作成に使います。クラス名はオプションです。何も入力しなかった場合後で入力を求められます。  
- select [ クラス名 ]  
編集するClassを変更するときに使います。makeコマンド時に自動でこれが実行され、メインclassが移るので注意が必要です。emacsやbuildがなされるのはここで選択したClassです。  

## Install
`git pull http://github.com/warosusou/GodShell`  
SSH接続でないとできない場合が存在するので注意。どちらにせよpullリクエストの時点でinstallできます。  
