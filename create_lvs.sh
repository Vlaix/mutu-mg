#!/bin/bash
#
# This script create a lvs part
#

if [ $# -eq 0 ]
then
    echo "No arguments supplied"
    echo "Usage: ./create_lvs.sh alias"
    exit 1
fi

alias=$1

rm -rf /tmp/$alias
mkdir -p /tmp/$alias
cp -r /web/platforms/$alias/public/* /tmp/$alias/
lvcreate --name $alias --size 1G vg
mkfs -t ext4 /dev/vg/$alias
mount /dev/vg/$alias /web/platforms/$alias/public
cp -r /tmp/$alias/* /web/platforms/$alias/public
chown -R $alias:$alias /web/platforms/$alias/public
rm -rf /tmp/$alias
