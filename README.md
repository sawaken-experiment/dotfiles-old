# dotfiles

OSX, Debian系, CentOS, Windows(コマンドプロンプト)に対応.

Windowsは管理者権限でコマンドプロンプトを起動すること.

## 環境構築(OSX, Debian, CentOS, Windows共通)

* 本リポジトリをクローンし, rakeタスクの一覧を表示する. Rubyは2.0以上必須.
```
$ git clone https://github.com/sawaken/dotfiles.git ~/dotfiles
$ cd ~/dotfiles
$ rake -T
```

* 必要なものをインストール
```
$ rake dotfiles
```

## システム種別を指定する
システムの種別は基本的には自動で判別されるが,
環境変数`system`を介して強制的に指定することも可能.

* rakeの環境変数渡し機能を用いて:
```
$ rake system=debian -T
$ rake system=debian dotfiles
```

* あるいは単純に:
```
$ export system=debian
$ rake -T
$ rake dotfiles
$ unset system
```

## Status
* build(OSX)

    [![Build Status](https://travis-ci.com/sawaken/dotfiles.svg?token=46Mp6xrHukCWQqyh951J&branch=master)](https://travis-ci.com/sawaken/dotfiles)

* code(Ruby)
