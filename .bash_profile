if [ -r ~/.bash_profile.local ]; then
  . ~/.bash_profile.local
fi

if [ -d ~/.aliases ]; then
  ~/.aliases/load.sh
fi

export PATH="$HOME/.bin:$PATH"


if [ -r ~/.bashrc ]; then
  . ~/.bashrc
fi
