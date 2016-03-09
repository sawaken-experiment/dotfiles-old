# webstormでcoffeescriptを使う

TypeScriptの設定より少しだけ面倒な模様。

公式のドキュメントを読めばわかるようにはなっている。
1. [CoffeeScript Support](https://www.jetbrains.com/webstorm/help/coffeescript-support.html)
2. [Transpiling CoffeeScript to JavaScript](https://www.jetbrains.com/webstorm/help/transpiling-coffeescript-to-javascript.html)

## 自動でコンパイルするには(`*.coffee` -> `*.js`)

### 環境毎にやること
* coffeescriptとnodeのpluginを有効にする(元から有効になっていた)
* node.jsをマシンにインストールし、node.jsのパスをwebstormに設定する。

### project毎にやること
* CoffeeScriptコンパイラをnpmからインストールする。
(-gを付けるとglobal,付けないとprojectディレクトリ以下のnode_modulesにインストールされる。通常後者でよい。)
```
$ npm install coffee-script
```

* File->Settings->Tools->File Watchers
からFile Watcherを作成する。エディタの右上に出ていると思われるアラートをクリックしても作成できる。
* file watcherのprogram欄に、インストールしたCoffeeScriptコンパイラのパスを書く。
ローカルにインストールした場合は例えば以下の様に書く。
```
windowsなら $ProjectFileDir$\node_modules\.bin\coffee.cmd
unixなら $ProjectFileDir$/node_modules/.bin/coffee
```

* 必要に応じて、file watcherの設定画面からjsファイルの生成場所を設定する。
(デフォルトでは.coffeeファイルと同じ場所に生成されるみたい。)

## CoffeeScriptファイルを直接実行するには
terminalからCoffeeScriptコンパイラを叩くだけ。
たとえばwindowsの場合は以下の様。
```
> node_modules\.bin\coffee.cmd src\hello.coffee
```
