#!/bin/bash

# ~/.hoge (シンボル) -> ./.hoge (実体)なる
# 全てのシンボリックリンクを外す。

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
        eval "rm $dest"
      else
        echo "warning: $dest is not my link"
      fi
    fi
 done
