# Unix/Linux Commands

## ssh-keygen
`-t rsa`でRSA暗号の鍵を生成する。
`-C hogehoge`でhogehogeをコメントとして付記する。
参考: [http://webkaru.net/linux/ssh-keygen-command/](http://webkaru.net/linux/ssh-keygen-command/)

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

## cd -
前回いたディレクトリに戻る。
