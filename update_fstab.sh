#!/bin/bash
#
# This script reinit varnish config
#

rm /etc/fstab
cp template.fstab /etc/fstab

while read line; do
    alias=`echo $line | cut -d ' ' -f 1`
    #mount /dev/vg/$alias /web/platforms/$alias/public 
    echo "/dev/vg/$alias /web/platforms/$alias ext4 rw,nouser,auto 0 2" >> /etc/fstab
done < /web/deployment/alias.txt
