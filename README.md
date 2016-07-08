# dotfiles
|                      | dotfile            | setup              | test |
|----------------------|--------------------|--------------------|------|
| Mac                  | :white_check_mark: | :white_check_mark: | [![Build Status](https://travis-ci.com/sawaken/dotfiles.svg?token=46Mp6xrHukCWQqyh951J&branch=master)](https://travis-ci.com/sawaken/dotfiles) by Travis CI |
| Debian/Ubuntu        | :white_check_mark: | :white_check_mark: | - |
| CentOS               | :white_check_mark: | :white_check_mark: | - |
| Command-Prompt (Win) | :white_check_mark: | -                  | - |

## Install
Rubyは2.0以上必須.
管理者権限では実行しないこと.
```
$ cd [home-dir]
$ git clone git@github.com:sawaken/dotfiles.git dotfiles
$ cd dotfiles
$ rake -T
```

(注) WindowsのgitでLF<->CRの自動変換がONになっている場合
```
$ git clone --config core.autoCRLF=false git@github.com:sawaken/dotfiles.git dotfiles
```

(注) OSは自動で判別されるが, 環境変数`system`を介して強制的に指定することも可能.
```
$ rake system=debian -T
$ rake system=debian dotfiles    
```

## 絵文字
* :heavy_check_mark: fix something
* :cyclone: rearrange something
* :arrow_right: move something
* :fire: remove something
* :seedling: start something
* :pencil: wirte document
* :moneybag: valuable update
