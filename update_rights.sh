#!/bin/bash
#
# This script reinit rights
#

chown -R enska:enska /web/platform
#chmod 750 /web/platform/packages/pkg.sh 
#find /web/platform -type f -exec chmod 644 {} \;
#find /web/platform -type d -exec chmod 755 {} \;

while read line; do
    alias=`echo $line | cut -d ' ' -f 1`
    chown -R $alias:$alias /web/platforms/$alias/*
    chown root:root /web/platforms/$alias
    find /web/platforms/$alias/public/* -type f -exec chmod 644 {} \;
    find /web/platforms/$alias/public/* -type d -exec chmod 755 {} \;
done < /web/deployment/alias.txt
