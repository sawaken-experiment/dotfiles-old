# Unix/Linux Commands

## ssh-keygen command
`-t rsa`でRSA暗号の鍵を生成する。
`-C hogehoge`でhogehogeをコメントとして付記する。
参考:[link](http://webkaru.net/linux/ssh-keygen-command/)

### github/bitbucketにSSH鍵を登録
```
$ cd ~/.ssh
$ ssh-keygen -t rsa # 適当な名前hogeを入力。パスは空欄でもよい。
$ chmod 600 hoge
$ emacs config # ホストgithubに対してhogeを使う旨を設定する。bitbucketの場合はHostとHostNameをbitbucket.orgにする。
Host github
  HostName github.com
  IdentityFile ~/.ssh/hoge
  User git
$ cat hoge.pub # hoge.pubの中身をコピペしてgithub/bitbucketに登録。
```
remote-repositoryのURIは
```
git@github.com:username/repositoryname.git
git@bitbucket.org:username/repositoryname.git
```

## cd - command
前回いたディレクトリに戻る。

## test command
以下の２つは同じ意味。条件式が真なら正常終了する。
条件式の一覧は`man test`から確認。ちなみに`[[]]`は別コマンド。
```
test <条件式>
[ <条件式> ]
```

## && command
`<コマンド1> && <コマンド2>`
<コマンド1>を実行し、正常終了した場合にのみ<コマンド2>を実行する。
終了ステータスは、<コマンド1>と<コマンド2>が共に正常終了した場合のみ正常終了。

## || command
`<コマンド1> || <コマンド2>`
<コマンド1>を実行し、異常終了した場合にのみ<コマンド2>を実行する。
終了ステータスは、<コマンド1>と<コマンド2>が共に異常終了した場合のみ異常終了。

## ! command
`! <コマンド>`
<コマンド>を実行し、異常終了なら正常終了、正常終了なら異常終了とする。

## ls command
```
-a .で始まるファイルも表示する
-l 詳細形式で表示する
-u 日時=最終参照日時(--time=atime)
-c 日時=作成・状態(名前/パーミッション)変更日時(--time=ctime)
-F ファイルの種類に応じて、ファイル名の後に文字を付ける
  * 実行可能ファイル
  / ディレクトリ
  = UNIXドメインソケット
  @ シンボリックリンク
  | 名前付きパイプ
```
`ls -l(i)`で表示される項目は、
```
([inode番号])
[ディレクトリ(d),ファイル(-),ソフトリンク(l)]
[アクセス権]
[ハードリンク数]
[所有者]
[所有グループ]
[ファイルサイズ]
[日時(デフォルトでは最終更新日)]
[ファイル名]
```

## id command
idコマンドを実行したユーザーの識別子を表示する。

## tar command
主な使用例：
```
tar cvf hoge.tar hoge
tar cvzf hoge.tar.gz hoge
tar xvf hoge.tar
```
主なオプションの意味：
```
-c create
-v view
-f file
-z gzip
-x extract
```
tarはアーカイバ(ディレクトリ->ファイル)、gzipはファイルを圧縮。
zipはそれとは無関係な圧縮&アーカイバ。

## wget
保存先の指定は
`-O dest`
