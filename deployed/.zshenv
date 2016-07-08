#!/usr/bin/

# 雑用スクリプトのパスを通す
export PATH="$HOME/dotfiles/bin:$PATH"

# anyenvのパスを通す
if [ -d $HOME/.anyenv ]; then
  export PATH="$HOME/.anyenv/bin:$PATH"
  eval "$(anyenv init - zsh)"
fi

# brewからインストールしたctagsを使う
if [[ "$(uname)" == 'Darwin' ]]; then
  alias ctags='`brew --prefix`/bin/ctags'
fi
