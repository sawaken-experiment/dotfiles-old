# --------------------
# 初期設定スクリプト
#   - ビルドツール(cc, git等)とRakeをインストールし,
#     dotfilesをhome以下にcloneするところまで行う.
# --------------------

if [ "$(uname)" == 'Darwin' ]; then
  if [ ! which cc ]; then
    xcode-select --install
  fi
elif [ which apt-get ]; then
  sudo apt-get install -y build-essential git ruby
elif [ which yum ]; then
  sudo yum groupinstall -y "Development Tools"
  sudo yum install -y kernel-devel kernel-headers ruby
else
  echo 'Unsupported system.'
  exit
fi

sudo gem install rake
git clone https://github.com/sawaken/dotfiles.git $HOME/dotfiles
