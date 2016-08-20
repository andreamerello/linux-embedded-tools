#!/bin/bash

BCK_FILE=config_bck
LAST_TARGET_FILE=last_target

source $EMB_LINUX_SCRIPTDIR_PATH/common/colorecho.sh

function configure() {
    if [ -f .config ]; then
	colorecho $YELLOW backupping old config on $BCK_FILE
	cp .config $BCK_FILE
    fi

    cp $KCONFIG .config
    echo $TARGET_NAME > $LAST_TARGET_FILE
}

if [ x$KCONFIG == x ]; then
    colorecho $YELLOW always using current config
    exit 0
fi

if [ ! -f $KCONFIG ]; then
    colorecho $RED Config $KCONFIG not found!
    exit -1
fi

if [ ! -f .config ]; then
    colorecho $GREEN First-time Configuration with $KCONFIG
    configure
    exit 0
fi

# check if the target is the same
if [ ! -f $LAST_TARGET_FILE ] || [ $TARGET_NAME != `cat $LAST_TARGET_FILE` ]; then
    # different target
    colorecho $YELLOW "Changing kernel config ($KCONFIG)!"
    configure
    exit 0
fi

#same target, check if cfg changed
diff .config $KCONFIG > /dev/null
if [ $? != 0 ]; then
    colorecho $YELLOW Kernel configuration mismatch! Keeping yours
    colorecho $YELLOW You may want to update $KCONFIG
    exit 0
fi


colorecho $GREEN Kernel configuration OK!
