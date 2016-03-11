#!/bin/bash

# u-boot has a very limited buffer.
# we need send out buffer in several little chunks
# (I don't remember how long is it; we are very conservarive)
CHUNK_LEN=8

put_chunk() {
    #echo -n "$1"

    screen -S $TARGET_NAME -X stuff "$1"
}

CMD=$1
#echo $CMD
let CHUNK_LEN1=$CHUNK_LEN
while [ -n "$CMD" ]; do
    put_chunk "${CMD:1:$CHUNK_LEN}"
    CMD="${CMD:$CHUNK_LEN1}"

    sleep 0.05
done

put_chunk "\r"
