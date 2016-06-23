if [[ "$OSTYPE" == "cygwin" ]];then
  export CYGWIN="winsymlinks:nativestrict" # ln -s をmklinkに置き換える
  export LANG=C # forkが失敗するエラーを回避
fi

# 雑用スクリプトのパスを通す
export PATH="$HOME/.script:$PATH"

# anyenvのパスを通す
if [ -d $HOME/.anyenv ]; then
  export PATH="$HOME/.anyenv/bin:$PATH"
  eval "$(anyenv init - zsh)"
fi

# cygwinでchocolatey
if [[ "$OSTYPE" == "cygwin" ]];then
  unset tmp temp
  alias choco='cmd /c choco'
  alias cinst='cmd /c cinst'
  alias cup='cmd /c cup'
  alias cuninst='cmd /c cuninst'
fi
