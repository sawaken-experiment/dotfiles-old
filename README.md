[![Build Status](https://travis-ci.com/sawaken/dotfiles.svg?token=46Mp6xrHukCWQqyh951J&branch=master)](https://travis-ci.com/sawaken/dotfiles)
# dotfiles

## 事前準備(OSX)
1. App Storeからxcodeをインストール
2. Command Line Toolsをインストール. gitも含まれているはず
```
$ xcode-select --install
```
3. rubyは最初からインストールされているので, rakeをインストール
```
$ sudo gem install rake
```

## 事前準備(Debian)
1. ユーザを作成
```
# adduser username
```

2. `sudo`をインストールし, `username`をsudoユーザに登録
```
# apt-get install sudo
# visudo
```

3. 以下のように編集
```
#Allow members of group sudo to execute any command
%sudo   ALL=(ALL:ALL)ALL
username ALL=(ALL:ALL)ALL
```

4. `username`で再ログインし, rakeに必要なものをインストール
```
$ sudo apt-get update
$ sudo apt-get install -y build-essential git ruby
$ sudo gem install rake
```

### 環境構築(OSX, Debian共通)

1. 本リポジトリをクローンし, rakeタスクの一覧を表示
```
$ git clone https://github.com/sawaken/dotfiles.git ~/dotfiles
$ cd ~/dotfiles
$ rake -T
```

2. 適宜必要なものをインストール
```
$ rake dotfiles
```
