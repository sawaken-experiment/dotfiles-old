#!/bin/bash

echo_and_do () {
    echo "$1"
    eval "$1"
}

curdir=`pwd`

# TODO: 以下の挙動にしたい。
# リンクを張ろうとするファイルが既に存在する場合、
# * それがシンボリックリンクである => 付け替える
# * それが実態である=> 何もしない

for f in .??*
do
    [[ "$f" == ".git" ]] && continue
    [[ "$f" == ".DS_Store" ]] && continue
    [[ "$f" == ?*~ ]] && continue
    [[ "$f" == ?*# ]] && continue

    echo_and_do "ln -s $curdir/$f $HOME/$f"
 done