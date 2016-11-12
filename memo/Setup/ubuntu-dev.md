# 【開発/普段使い用】ubuntu導入手順

# 【共通】いろいろインストール
```
$ sudo apt-get install -y git ruby
$ git clone https://github.com/sawaken/dotfiles ~/dotfiles
$ cd ~/dotfiles
$ rake all
```

# 【自宅】NASをマウントする
```
$ sudo apt-get install -y nfs-common
$ mkdir /home/owner/Data
$ mkdir /home/owner/Video
$ echo '192.168.1.2:/main-storage/data /home/owner/Data nfs rw' | sudo cat >> /etc/fstab
$ echo '192.168.1.2:/main-storage/video /home/owner/Videos nfs rw' | sudo cat >> /etc/fstab
$ sudo mount -a
```

# 【自宅】google-chromeにログインする
# 【共通】github/bitbucketに公開鍵を登録する
# 【共通】デスクトップ環境設定
    * カーソル加速
    * launcherサイズ縮小/autohide
    * 自動画面切り無効化
    * IMEの設定
    (タスクバーのキーボードマーク -> configure -> Global Config -> Show Advance Optionにチェックを入れる)
      * ctrl-spaceでIMEがtoggleするのを止める
      * ctrl-spaceでIMEがONになるようにする
      * ctrl-jでIMEがOFFになるようにする

# 【自宅】DNS設定
DHCPなら自動で設定されるはずだが、手動で設定しないと何故かすぐ無効になる(`ping google.com`が通らなくなる。)
```
$ sudo apt-get install resolvconf
$ sudo vi /etc/network/interfaces
```
以下のように編集したら安定した。
```
# interfaces(5) file used by ifup(8) and ifdown(8)
auto lo
iface lo inet loopback
dns-nameservers 192.168.1.1
```
