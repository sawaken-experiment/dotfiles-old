#!/bin/bash

# ./.hogeなる
# 全てのファイルについて、シンボリックリンク　~/.hoge -> ./.hogeを張る。

curdir=`pwd`

for f in .??*
do
    [[ "$f" == ".git" ]] && continue
    [[ "$f" == ".DS_Store" ]] && continue
    [[ "$f" == ?*~ ]] && continue
    [[ "$f" == ?*# ]] && continue

    src="$curdir/$f"
    dest="$HOME/$f"
    if [ -e "$dest" ]; then
      curlink=`readlink $dest`
      if [ "$curlink" == "$src" ]; then
        :
      else
        echo "There is already something at: $dest"
      fi
    else
      eval "ln -s $src $dest"
    fi
 done
