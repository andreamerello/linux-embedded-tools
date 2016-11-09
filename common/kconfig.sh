#!/bin/bash

source $EMB_LINUX_SCRIPTDIR_PATH/common/kconfig_common.sh

#configure the kernel if needed
if [ ! -f .config ]; then
    colorecho $GREEN First-time Configuration....
    configure
elif [ "$KCONFIG" != $LAST_KCONFIG ]; then
    # different target
    diff .config "$LAST_KCONFIG" > /dev/null
    if [ $? != 0 ]; then
	colorecho $RED Kernel config is going to change..
	update_config $LAST_KCONFIG
    fi
    configure
else
    #same target, check if cfg changed
    diff .config "$KCONFIG" > /dev/null
    if [ $? != 0 ]; then
	colorecho $YELLOW Kernel configuration mismatch! Keeping yours..
    else
	colorecho $GREEN Kernel configuration OK!
    fi
fi
