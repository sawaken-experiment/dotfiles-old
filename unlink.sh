#!/bin/bash

echo_and_do () {
    echo "$1"
    eval "$1"
}

curdir=`pwd`

for f in .??*
do
    [[ "$f" == ".git" ]] && continue
    [[ "$f" == ".DS_Store" ]] && continue
    [[ "$f" == ?*~ ]] && continue
    [[ "$f" == ?*# ]] && continue

    src="$curdir/$f"
    dest="$HOME/$f"
    curlink=`readlink $dest`
    if [ $curlink == $src ]; then
      echo_and_do "rm $dest"
    fi
 done
