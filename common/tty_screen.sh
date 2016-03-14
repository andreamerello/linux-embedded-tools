
find_screen() {
    screen -ls $1 | grep $1 > /dev/null
}

tty_put() {
    #echo -n "$1"
    screen -S $TARGET_NAME -X stuff "$1"
}

if ! find_screen $TARGET_NAME; then
    sudo chmod 777 $TTY_DEV
    screen -h 10000 -d -m -S zynq $TTY_DEV $TTY_BAUD
fi

if ! find_screen $TARGET_NAME; then
    echo "FATAL: cannot attach to serial console"
    exit -1
fi

export -f tty_put
