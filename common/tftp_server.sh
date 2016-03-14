#!/bin/bash

sudo kill `sudo pgrep -af tftpserver.py |cut -f1 -d' '`
sudo nohup $EMB_LINUX_SCRIPTDIR_PATH/ptftpd/ptftplib/tftpserver.py -p 69 $ETH_LOCAL_IFACE . > /dev/null 2> /dev/null&
