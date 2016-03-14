#!/bin/bash

# u-boot has a very limited buffer.
# we need send out buffer in several little chunks
# (I don't remember how long is it; we are very conservarive)
CHUNK_LEN=8

CMD=$1
#echo $CMD
let CHUNK_LEN1=$CHUNK_LEN
while [ -n "$CMD" ]; do
    tty_put "${CMD:0:$CHUNK_LEN}"
    CMD="${CMD:$CHUNK_LEN1}"

    sleep 0.05
done

tty_put "\r"
