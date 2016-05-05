# 雑用スクリプトのパスを通す
export PATH="$HOME/.script:$PATH"

# anyenvのパスを通す
if [ -d $HOME/.anyenv ]; then
  export PATH="$HOME/.anyenv/bin:$PATH"
  eval "$(anyenv init -)"
fi
