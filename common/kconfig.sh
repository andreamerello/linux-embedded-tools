#!/bin/bash

BCK_FILE=config_bck
LAST_CONFIG_FILE=last_config

source $EMB_LINUX_SCRIPTDIR_PATH/common/colorecho.sh
source $EMB_LINUX_SCRIPTDIR_PATH/common/git.sh

function configure() {
    if [ -f .config ]; then
	colorecho $YELLOW backupping old config on $BCK_FILE
	cp .config $BCK_FILE
    fi

    cp $KCONFIG .config
    echo $KCONFIG > $LAST_CONFIG_FILE
}

parse_git_branch
#look for branch-specific config
if [ x"$GIT_BRANCH" != x ]; then
    GITKCONFIG=$KCONFIG-"$GIT_BRANCH"
    if [ -f "$GITKCONFIG" ]; then
	KCONFIG="$GITKCONFIG"
    fi
fi

if [ x"$KCONFIG" == x ]; then
    colorecho $YELLOW always using current config
    exit 0
fi

if [ ! -f "$KCONFIG" ]; then
    colorecho $RED Config $KCONFIG not found!
    exit -1
fi

if [ ! -f .config ]; then
    colorecho $GREEN First-time Configuration with $KCONFIG
    configure
    exit 0
fi

# check if the target is the same
if [ ! -f $LAST_CONFIG_FILE ] || [ "$KCONFIG" != `cat $LAST_CONFIG_FILE` ]; then
    # different target
    colorecho $YELLOW "Changing kernel config ($KCONFIG)!"
    configure
    exit 0
fi

#same target, check if cfg changed
diff .config "$KCONFIG" > /dev/null
if [ $? != 0 ]; then
    colorecho $YELLOW Kernel configuration mismatch! Keeping yours..
    colorecho $YELLOW You may want to update $KCONFIG
    exit 0
fi


colorecho $GREEN Kernel configuration OK!
