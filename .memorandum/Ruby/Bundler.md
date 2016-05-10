# Bundler
Sandbox的なもの.
ちなみに, gemパッケージの複数バージョンを共存させて使い分けること自体は,
以下の様にBundlerを使わなくともできる.
```
$ gem install pry:0.10.1 pry:0.10.2
```

```ruby
if ARGV[0] == '1'
  gem 'pry', '0.10.1'
else
  gem 'pry', '0.10.2'
end
require 'pry'
p Pry::VERSION # => 0.10.1 or 0.10.2
```

## Bundleを用いてRubyアプリケーションをインストール
```
mkdir install-dest
cd install-dest
bundle init
vi Gemfile
bundle install --path ./vendor/bundle # 依存gemは./vendor/bundleに格納される
bundle exec pry
```
`bundle install`に`--path`を指定しなかった場合,
依存gemはグローバルな領域にインストールされる.
グローバルな領域といっても, 依存Gemのversion管理はされるので特に問題はない.
何処に保存されるかは`bundle show pry`などで確認できる.

### Bundleによってインストールされているgemパッケージの一覧を表示する
```
cd install-dest
bundle list
```

### Bundleによってインストールされているgemパッケージをアップデートする
```
cd install-dest
bundle update
```

## Bundleによってインストールされているgemパッケージの保存先を確認する
```
cd install-desc
bundle show pry
```

## Gemfileの書き方
```ruby
source "https://rubygems.org" # gemを取得するリポジトリの設定
gem "pry", '0.10.3' # バージョン0.10.3決め打ち
gem 'pry', '>=0.10.3' # 0.10.3以降の可能な限り新しいバージョン
gem 'pry', '~>0.10.3' # 0.10.3以降の, 0.x.x系で可能な限り新しいバージョン
```

## bundle exec ${command} を打ちたくない
rbenvのプラグインbinstubsをインストールしておく.
```
$ cd install-dest
$ bundle install --binstubs=./script
$ rbenv rehash
$ pry
$ cd ./ch-dir
$ pry
$ cd ../../
$ pry
rbenv: pry: command not found
```
script以下にexecutable(のスタブ)がインストールされる.
これにて, `install-dest`以下ならば直接コマンドが叩ける様になる.
`install-dest`以下でない場所でコマンドを叩いた際にはrbenv(binstubs)がエラーを吐く.

### binstubsにトラックされているbundleの一覧を表示する
```
$ rbenv bundles
/Users/hoge/install-dest: bin
```

### bitstubsからbundleを削除する
bundleのディレクトリを削除するしかない?
```
rm -rf install-dest
rbenv rehash
```
