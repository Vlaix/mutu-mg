#!/bin/bash
#
# This script reinit logrotate config
#

while read line; do
    alias=`echo $line | cut -d ' ' -f 1`
    cp template.logrotate.conf /etc/logrotate.d/$alias.logrotate.conf
    sed -i "s/@@USER@@/$alias/g" /etc/logrotate.d/$alias.logrotate.conf
done < /web/deployment/alias.txt
