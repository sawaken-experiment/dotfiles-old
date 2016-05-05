#!/bin/bash

# --------------------
# Rakeの実行環境は用意できないけど, dotfileのリンクだけは張りたい時に使うスクリプト.
#   - カレントディレクトリ以下の全てのdotfileのリンクを張る.
#   - 既に設置されているものについては何もしない.
#   - 既に同名の別ファイルが存在する場合は警告を表示する.
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
        :
      else
        echo "warning: There is already something at: $dest"
      fi
    else
      eval "ln -s $src $dest"
    fi
 done
