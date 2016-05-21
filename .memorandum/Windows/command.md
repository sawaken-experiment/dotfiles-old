## mklink windows
シンボリックリンク。管理者権限必須。管理者権限でbatを実行するとカレントディレクトリが変わってしまう…。
```
mklink [ディレクトリなら\d] <dest> <src>
mklink /d "%userprofile%\.hoge" "%cd%\.hoge"
```

ドットファイルをリンクする例
```
> cd /d c:\Users\Owner
> git clone https://github.com/sawaken/dotfiles.git
> mklink /D ".atom" "dotfiles\.atom"
```
