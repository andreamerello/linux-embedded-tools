
sudo ifconfig $ETH_LOCAL_IFACE up

if [ ! -z "$ETH_LOCAL_ADDR" ]; then
    sudo ifconfig $ETH_LOCAL_IFACE $ETH_LOCAL_ADDR
    sudo ifconfig $ETH_LOCAL_IFACE netmask $ETH_MASK
else
    ETH_IFCONFIG=`ifconfig $ETH_LOCAL_IFACE |grep "inet addr:"`
    export ETH_LOCAL_ADDR=`echo $ETH_IFCONFIG | cut -d':' -f 2 |cut -d" " -f1`
    export ETH_MASK=`echo $ETH_IFCONFIG | cut -d':' -f 4 |cut -d" " -f1`
fi
