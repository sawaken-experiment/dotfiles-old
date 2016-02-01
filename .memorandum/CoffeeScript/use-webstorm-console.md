# webstormでcoffeescriptを使う

TypeScriptの設定より少しだけ面倒な模様。

公式のドキュメントを読めばわかるようにはなっている。
1. [CoffeeScript Support](https://www.jetbrains.com/webstorm/help/coffeescript-support.html)
2. [Transpiling CoffeeScript to JavaScript](https://www.jetbrains.com/webstorm/help/transpiling-coffeescript-to-javascript.html)

# 概要

「CoffeeScriptのファイル(.coffee)を実行する」のと、「CoffeeScriptのファイル(.coffee)をJavaScriptファイル(.js)に変換する」のは別。

プログラムをwebstormのコンソール上で実行する分には変わらないが、ブラウザ上で実行するには当然後者を行う必要がある。


## 「CoffeeScriptのファイル(.coffee)を実行する」には、
* coffeescriptとnodeのpluginを有効にする(元から有効になっていた)
* node.jsをマシンにインストールし、node.jsのパスをwebstormに設定する。
* npm install coffee-scriptでcoffeescriptのコンパイラをインストールする。(-gを付けるとglobal, 付けないとprojectディレクトリ以下のnode_modulesにインストールされる。通常後者でよい。)
* 例えばnode.jsでMain.coffeeを実行するような実行設定を作成する。その際、インストールしたnode_modules/coffee-script/bin/coffeeを噛ませるように設定する。
* 作成した設定で実行する。

## 「CoffeeScriptのファイル(.coffee)をJavaScriptファイル(.js)に変換する」には

上の3つめまでを行った後、
* File->Settings->Tools->File WatchersからFile Watcherを作成する。エディタの右上に出ていると思われるアラートをクリックしてもOK。（File Watcherは例えば.coffeeファイルを監視して、自動的に.jsファイルを生成するような監視プロセス。）
* File Watcherの作成画面でprogramにnode_modules/.bin/coffee.cmdを設定する。
* 正常に設定できていれば、hoge.coffeeが変更保存される度にhoge.jsが生成されるはず。(デフォルトでは.jsの生成場所は.coffeeが置かれている場所と同じ所。File Watchersの設定画面から変更できる。)

これらは全て<https://www.jetbrains.com/webstorm/help/transpiling-coffeescript-to-javascript.html>に書いてある。
