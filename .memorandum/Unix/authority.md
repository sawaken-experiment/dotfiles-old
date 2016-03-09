# Authority

## directory permission
```
r (ディレクトリ情報の読込 = 子ファイル一覧の取得) を行う権利
w (ディレクトリ情報の編集 = 子ファイルの[削除|名前変更|追加]) を行う権利
x ディレクトリにアクセスする権利
```
xを与えない限り(rw-,r--,-w-,---では)基本的に何もできないと考えてよい。
```
0 --- ディレクトリに対して何もできない。
1 --x ディレクトリにアクセスできる。子ファイルの[編集|実行]ができる。
3 -wx --xに加え、子ファイルの[削除|名前変更|追加]ができる。
5 r-x --xに加え、子ファイルを一覧表示できる。
7 rwx 全部できる。
```
0か5(or 1)か7しか使わない気がする。

## file permission
```
r (ファイルの読込 = inodeが持つ情報の読込) を行う権利
w (ファイルの書込 = inodeが持つ情報の書込) を行う権利
r ファイルを実行する権利
```

## default permission
```
default-file-permission = 666 - umask値
default-dir-permission = 777 - umask値
```
umask値は`umask xxx`で変更できる。デフォルトは`xxx = 022`。
ただし、変更はそのシェルでのみ影響する。

## file owner
* 各ファイルはユーザーIDを一つ持つ
* 各ファイルはオーナーパーミッションを持つ
* オーナーに設定されたユーザは、設定されたオーナーパーミッションの権限でファイルにアクセスできる

### オーナーの変更
```
chown user target+
```
実行者はスーパーユーザである必要がある。
userではなくgroupを指定すればchgrpと同じ役割も果たす。

## file group
* 各ファイルはグループIDを一つ持つ
* 各ファイルはグループパーミッションを持つ
* 設定されたグループのメンバーは、設定されたグループパーミッションの権限でファイルにアクセスできる

### グループの変更
```
chgrp group target+
```
実行者はgroupのメンバーである必要がある。