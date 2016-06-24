# WebStorm 10.0.4 / Windows
とりあえずシングルファイルをコンソールで実行してみるだけ。

# enable TypeScript Compiler
```
File->Settings->Lnaguages & Frameworks->TypeScript
```
二行目のEnable TypeScript Compilerにチェック。

# node
<https://nodejs.org/en/>からインストール。

上記の
```
File->Settings->Lnaguages & Frameworks->TypeScriptと
```
と
```
Run->Edit Configuartions->+->Node.js
```
に設定欄あり。前者はTSコンパイラとしての指定。後者はランタイムとしての指定。たぶん。

# run/debug
```
Run->Edit Configuartions->+->Node.js
```
でrun設定を作成後、普通に実行できた。

# .jsファイルの生成
CoffeeScriptの設定とは異なり、File Watcherを設定しなくとも.jsファイルが生成される模様？
