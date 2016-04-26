# Linux + PX-W3PEで録画鯖を立てるメモ

## CentOS 6.7 final をインストールする。
以下のページの CentOS-6.7-x86_64-minimal.iso をCDに焼いてboot。
http://ftp.jaist.ac.jp/pub/Linux/CentOS/6.7/isos/x86_64/

チューナーやらカードリーダーやらは最初から挿しっぱなしでよい。

## rootでログインし、録画用のユーザを作成
```
# useradd recorder
# passwd recorder
# usermod -G wheel recorder
# visudo
```
recoderがsudoできるように、以下のように編集する。
```
Allows people in group wheel to run all commands
- #%wheel ALL=(ALL) ALL
+ %wheel ALL=(ALL) ALL
```

## ネットワークを設定

固定IPにしたほうがよいので、設定ファイル内の以下の項目を設定する。
IPADDR以外のxxx.xxx.xxx.xxxは適当にLAN内の他のPCの設定値を書き写せばよいと思う。
参考: http://www.kakiro-web.com/memo/centos6-install.html
```
$ sudo vi /etc/sysconfig/network-scripts/ifcfg-eth0
```
以下を記述。既に存在する項目は書き換える。
```
BOOTPROTO=none
ONBOOT=yes
IPADDR=xxx.xxx.xxx.xxx
NETMASK=xxx.xxx.xxx.xxx
GATEWAY=xxx.xxx.xxx.xxx
PEERDNS=yes
DNS1=xxx.xxx.xxx.xxx
```
ネットワークを再起動する。
```
$ sudo service network restart
```

## 公開鍵ログインできるようにしておく
しなくてもいいけど。
```
$ mkdir ~/.ssh
$ chmod 700 ~/.ssh # セキュリティの観点から、700じゃないとエラーが出る仕様らしい
$ cat > ~/.ssh/authorized_keys # クライアントの公開鍵情報を貼り付けるなり打ち込むなりする
$ chmod 600 ~/.ssh/authorized_keys
```

## PX-W3PEドライバをインストール
ドライバは公式配布のもの(centos6用のバイナリ)しかないので、それを使う。
参考: http://quail.mydns.jp/2016/02/01/post-182/
```
$ wget http://plex-net.co.jp/plex/px-w3pe/PX-W3PE_LinuxDriver_ver.1.0.0.zip
$ unzip PX-W3PE_LinuxDriver_ver.1.0.0.zip
$ cd Driver
$ tar xzvf 64bit.tar.gz
$ cd 64bit
$ sudo cp asv5220_dtv.ko /usr/lib64/asv5220_dtv.ko
$ sudo vi /etc/sysconfig/modules/asv5220_dtv.modules
```
以下を記述する(新規作成)。
```
#!/bin/sh
/sbin/insmod /usr/lib64/asv5220_dtv.ko
```

```
$ sudo chmod 755 /etc/sysconfig/modules/asv5220_dtv.modules
$ sudo reboot
$ ls -l /dev/asv*
crw-rw----. 1 root root 248, 0  4月 13 09:56 2016 /dev/asv52200
crw-rw----. 1 root root 248, 1  4月 13 09:56 2016 /dev/asv52201
crw-rw----. 1 root root 248, 2  4月 13 09:56 2016 /dev/asv52202
crw-rw----. 1 root root 248, 3  4月 13 09:56 2016 /dev/asv52203
```

/dev/asv5220{0,1,2,3}のパーミッションを755にする。
ただし単にchmodしただけでは再起動時に660に戻ってしまうので、udevファイルに記述する。
```
$ sudo vi /etc/udev/rules.d/50-udev.rules
```
以下を記述する(新規作成)。
```
KERNEL=="asv5220*", NAME="%k", MODE="755"
```
再起動し、パーミッションが755になっていることを確認。
```
$ sudo reboot
$ ls -l /dev/asv*
crwxr-xr-x. 1 root root 248, 0  4月 13 10:16 2016 /dev/asv52200
crwxr-xr-x. 1 root root 248, 1  4月 13 10:16 2016 /dev/asv52201
crwxr-xr-x. 1 root root 248, 2  4月 13 10:16 2016 /dev/asv52202
crwxr-xr-x. 1 root root 248, 3  4月 13 10:16 2016 /dev/asv52203
```

## カードリーダのドライバをインストール
定番のNTTのあれ。LEDが点滅したら多分OK。
debianで構築したときはアイドル時点灯でアクセス時に点滅したので、
バージョンか何かによって異なる？
ドライバさえCCIDに用意されていれば他の製品でも問題なし。
```
$ sudo yum -y install pcsc-lite pcsc-lite-devel pcsc-lite-libs ccid
$ wget http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
$ sudo rpm -ivh rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
$ sudo vi /etc/yum.repos.d/rpmforge.repo # enable=0に書き換える
$ sudo yum -y install --enablerepo=rpmforge perl-Gtk2
```

## b25のインストール
```
wget http://hg.honeyplanet.jp/pt1/archive/c44e16dbb0e2.zip
unzip c44e16dbb0e2.zip
cd pt1-c44e16dbb0e2/arib25/
make
sudo make install
```
recpt1実行時にlibarib25.so.0が無いと言われて怒られるので、ライブラリのロードパスを通す。
```
sudo echo /usr/local/lib | cat >> /etc/ld.so.conf
sudo ldconfig
```

# 別のマシンでrecpt1バイナリの生成
foltia同梱版のrecpt1しかPX-W3PEに対応していないらしいので、それを拝借してくる。
foltia評価版を別のマシン(VMでOK)にインストールし、
そこから{recpt1,recpt1ctl,checksignal}を取り出す。
参考: https://www2.filewo.net/wordpress/2014/02/05/centos6-4%E3%81%A8px-w3pe%E3%81%A7%E4%BD%9C%E3%82%8B%E9%8C%B2%E7%

* ドライバが有るんだから簡単にrecpt1対応できるのではと思ったが、ドライバはバイナリのみの公開で
ドキュメントも無い模様なので容易ではなさそう。
PlexはまともにLinuxをサポートするつもりは端からないらしく、
現在はドライバの公開すら止めている模様。
(ただしリンクは消えていても、06/04/13現在ファイルはまだサーバに置いてある状態。)

* インストール中、ドライバをアップロードする操作で何故かwebサーバが落ちた。
再起動してhttp://foltia.local/ではなくhttp://xxx.xxx.x.x/の方にアクセスして
リトライしたら問題なくできた。

* http://www22.atwiki.jp/px-w3pe/pages/14.htmlを見るとfoltiaを別のマシンに
インストールせずともrecpt1をビルドできるらしいが、うまくいかなかった。

以下、ドライバのダウンロード&アップロード&インストールをWebUIから行ったのち、
root:foltiarootでコンソールにログインして実行する。

USキーボードを使っている場合、/etc/sysconfig/keyboardに以下を記述して再起動する。
```
KEYTABLE="us"
MODEL="pc105+inet"
LAYOUT="us"
KEYBOARDTYPE="pc"
```

データ受け渡しの仲介役としてgithubなどのリモートリポジトリを使う。
WinSCPとかでも問題ない。
```
# mkdir /home/foltia/binary
# cp $(which recpt1) $(which recpt1ctl) $(which checksignal) /home/foltia/binary/
# cd /home/foltia/binary
# yum -y install git
# git init
# git add .
# git commit -m "first commit"
# git remote add origin https://username:password@github.com/XXX/binary.git
# git push -u origin master
```

以下、再び録画鯖にて。
```
$ sudo yum -y install git
$ git clone https://github.com/XXX/binary.git
$ cd binary
$ sudo cp recpt1 recpt1ctl checksignal /usr/local/bin/
```

最終チェック。これでうまく録画できれば万事OK。
```
$ recpt1 --b25 --strip --device /dev/asv52200 211 10 211ch10sec.ts
$ recpt1 --b25 --strip --device /dev/asv52202 16 10 16ch10sec.ts
```

ついでにchecksignalも動作確認

(C/Nがちゃんと表示されるときと-nandBになるときがあってよくわからない...)
```
$ checksignal 16
device = /dev/asv52202
C/N = 25.419532dB ^C
SIGINT received. cleaning up...
$ checksignal 211
device = /dev/asv52201
C/N = 24.070000dB ^C
SIGINT received. cleaning up...
```
