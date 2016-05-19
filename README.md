# dotfiles

基本的にOSX用. Linux(Debian系とCentOS)も部分的に対応.

## 環境構築(OSX, Debian, CentOS共通)

* 本リポジトリをクローンし, rakeタスクの一覧を表示
```
$ git clone https://github.com/sawaken/dotfiles.git ~/dotfiles
$ cd ~/dotfiles
$ rake -T
```

* 必要なものをインストール
```
$ rake dotfiles
```

## Status
* build(OSX)

    [![Build Status](https://travis-ci.com/sawaken/dotfiles.svg?token=46Mp6xrHukCWQqyh951J&branch=master)](https://travis-ci.com/sawaken/dotfiles)

* code(Ruby)
