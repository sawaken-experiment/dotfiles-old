# dotfiles

OSX, Debian系, CentOS, Windows(コマンドプロンプト)に対応.

## インストール(OSX, Debian, CentOS, Windows共通)
本リポジトリをクローンし, ドットファイルのリンクを張る.
Rubyは2.0以上必須.
管理者権限では実行しないこと.
```
$ cd [home-dir]
$ git clone --config core.autoCRLF=false https://github.com/sawaken/dotfiles.git dotfiles
  or $ git clone --config core.autoCRLF=false git@github.com:sawaken/dotfiles.git dotfiles
$ cd dotfiles
$ rake dotfiles
```

## 環境構築
適宜必要なものをインストール.
```
$ rake -T
$ rake atom-packages
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

## 現在の状態
* OSXの環境構築

    [![Build Status](https://travis-ci.com/sawaken/dotfiles.svg?token=46Mp6xrHukCWQqyh951J&branch=master)](https://travis-ci.com/sawaken/dotfiles)

* Windowsの環境構築

* Ubuntuの環境構築

* src以下のRubyコード


##　コミットメッセージの絵文字

### アクション
* :heavy_check_mark: modify mistake
* :arrow_right: move something
* :bug: fix bug
* :seedling: start something
* :fire: remove something

### モチベーション
* :anger: commit with anger
* :shit: fucking commit
