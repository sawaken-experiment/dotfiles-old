# 【開発/普段使い用】ubuntu導入手順

* 【共通】いろいろインストール
```
sudo apt-get install -y git ruby
git clone https://github.com/sawaken/dotfiles ~/dotfiles
cd ~/dotfiles
rake all
```
* 【自宅】NASをマウントする
```
sudo apt-get install -y nfs-common
mkdir /home/owner/Data
mkdir /home/owner/Video
echo '192.168.1.2:/main-storage/data /home/owner/Data nfs rw' | sudo cat >> /etc/fstab
echo '192.168.1.2:/main-storage/video /home/owner/Videos nfs rw' | sudo cat >> /etc/fstab
sudo mount -a
```
* 【自宅】google-chromeにログインする
* 【共通】github/bitbucketに公開鍵を登録する
* 【共通】デスクトップ環境設定
    * カーソル加速
    * launcherサイズ縮小/autohide
    * 自動画面切り無効化
