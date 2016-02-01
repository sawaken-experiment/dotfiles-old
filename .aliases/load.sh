#!/bin/bash

DIR=$(cd $(dirname $0); pwd)

for f in $DIR/??*.alias
do
    [[ "$f" == ?*~ ]] && continue
    [[ "$f" == ?*# ]] && continue

    . $f
 done
