# Online Editor
<http://elm-lang.org/try>

コードの保存は出来ない？

# Install (elm-platform)
Mac, Windowsはバイナリから<http://elm-lang.org/install>

Linuxはhaskell-platformでビルド<https://github.com/elm-lang/elm-platform>

# REPL
```sh
$ elm-repl
```

# Build projects
ディレクトリ作ってMain.elm置いて
```sh
$ elm-make Main.elm --output index.html
```
elm-package.jsonが出来てelm-lang/coreがダウンロードされる。

# Install packages
```sh
$ elm-package install domain/libname [ver]
```
自動でelm-packageにも追記してくれる。
```sh
Error: Unable to find a set of packages that will work with your constraints.
```
とか出たらバージョン制約に引っかかってる。
インストールしたいライブラリのelm-package.jsonをgithubで見て、頑張って合わせる。
elm自体のバージョンが制約に引っかかっていないかにも注意。

# Reactor
```sh
$ elm-reactor
```
ブラウザから<http://localhost:8000/>にアクセスする。
プログラムをリアルタイムコンパイル＆表示してくれる。便利。

# 元記事
<https://pragmaticstudio.com/blog/2014/12/19/getting-started-with-elm>
