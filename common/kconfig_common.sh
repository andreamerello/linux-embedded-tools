BCK_FILE=config_bck
LAST_CONFIG_FILE=last_config

source $EMB_LINUX_SCRIPTDIR_PATH/common/colorecho.sh
source $EMB_LINUX_SCRIPTDIR_PATH/common/git.sh

function configure() {
    colorecho $YELLOW "Changing kernel config!"
    cp $KCONFIG .config
    echo $KCONFIG > $LAST_CONFIG_FILE
}

function backup() {
    colorecho $YELLOW backupping old config on $BCK_FILE-$1
    cp .config $BCK_FILE-$1

}

#ask for updating the $1 file with current config, otherwise make a backup
function update_config() {
    read -p "Do you want to update \"$1\" with the current config? " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
	cp .config $1
    else
	backup $1
    fi
}

#if KCONFIG is not defined for this config, bail out: config management disabled
if [ x"$KCONFIG" == x ]; then
    colorecho $YELLOW always using current config
    exit 0
fi

parse_git_branch

#look for branch-specific config
if [ x"$GIT_BRANCH" != x ]; then
    GITKCONFIG=$KCONFIG-"$GIT_BRANCH"
    if [ -f "$GITKCONFIG" ]; then
	KCONFIG="$GITKCONFIG"
    else
	colorecho $YELLOW Config \"$GITKCONFIG\" for this branch not found!
    fi
fi

#bail out if there is no config file at all
if [ ! -f "$KCONFIG" ]; then
    colorecho $YELLOW Generic config \"$KCONFIG\" not found!
    exit -1
else
    colorecho $GREEN Kernel config file is  \"$KCONFIG\"
fi

if [ -f $LAST_CONFIG_FILE ]; then
   LAST_KCONFIG=`cat $LAST_CONFIG_FILE`
fi
