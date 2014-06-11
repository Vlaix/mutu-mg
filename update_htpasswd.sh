#!/bin/bash
#
# This script reinit htpasswd configuration
#

while read line; do
    alias=`echo $line | cut -d ' ' -f 1`
    htpasswd=`echo $line | cut -d ' ' -f 4`
    htpasswd -b -c /web/platforms/$alias/system/credentials.txt $alias $htpasswd
done < /web/deployment/alias.txt

 cp credentials.txt /web/platforms/xili/system

/etc/init.d/nginx reload
