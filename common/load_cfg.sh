#source me
CFG_DIR=$EMB_LINUX_SCRIPTDIR_PATH/conf
CFG_FILE=$CFG_DIR/$1.conf

if [ $# -lt 1 ] || [ ! -f $CFG_FILE ]; then
    echo "Please specify target name"
    echo "valid targets are:"
    for f in $CFG_DIR/*.conf; do
	basename $f | rev  | cut -f 2- -d . | rev
    done
    exit -1
fi

export TARGET_NAME=`basename $CFG_FILE | rev | cut -f 2- -d . | rev`
#set default for backward compatibility
export SSH_REMOTE_PORT=22
#set default to zImage for backward compat
export KERNEL_IMAGE=zImage
#set default to bootz for backward compat
export BOOT_CMD=bootz
# trick: read command will continue to make the loop
# iterate as long as there are lines terminating with \n.
# to get last line, if there is no a \n we must check
# if the read has produced something and eventually still
# loop one extra time
while read i || [ -n "$i" ]; do
    #check first char. xargs removes leading spaces
    FIRST=`echo $i | xargs | head -c 1`
    if [ -n "$FIRST" ] && [ $FIRST != '#' ]; then
	export "$i"
    fi
done < $CFG_FILE
