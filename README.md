[![Build Status](https://travis-ci.com/sawaken/dotfiles.svg?token=46Mp6xrHukCWQqyh951J&branch=master)](https://travis-ci.com/sawaken/dotfiles)
# dotfiles
クライアント環境のレシピ.

## Target
OSX, Linux(apt-getかyumが利用出来る環境).

## Setup
まず, `init.sh`を実行して{ビルドツール,git,rake}をインストールする.
その後, dotfileのリンクおよび環境構築を`Rakefile`に従って行う.

実行例:
```sh
$ curl -sf https://raw.githubusercontent.com/sawaken/dotfiles/master/.script/initialize | sh -s
$ cd ~/dotfiles
$ rake osx:setting # rake -Tで項目の一覧を表示
```

## Memo
`.memorandum/`以下にMarkdown形式のメモファイルを置く.
`.script`以下の`m`, `mo`, `mc`コマンドを用いて全文検索ができる.

実行例:
```sh
$ m com tar # ['com', 'tar']でメモを検索
$ mo com tar # ['com', 'tar']でメモを検索し、該当ファイルを編集
$ mc Hoge Fuga # .memorandum/Hoge/Fuga.mdを編集
```

## Test
以下については正常に動作することを確認する自動テストを用意する.
* `.script/`以下のユーティリティ・スクリプト
* 環境構築スクリプト`init.sh`, `Rakefile`
