#!/bin/bash

# --------------------
# Rakeの実行環境は用意できないけど, dotfileのリンクの解除だけは行いたい時に使うスクリプト.
#   - カレントディレクトリ以下の全てのdotfileのリンクを解除する.
#   - リンクされていないものについては何もしない.
#   - Rakefileに定義されたdotfiles処理とほぼ同機能. 併用も可能.
# --------------------

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
      fi
    fi
 done
