#!/bin/bash
#
# This script reinit skel config
#

while read line; do
    alias=`echo $line | cut -d ' ' -f 1`
    [ ! -d /web/platforms/$alias/public ] && mkdir -p /web/platforms/$alias/public
    [ ! -d /web/platforms/$alias/session ] && mkdir -p /web/platforms/$alias/session
    [ ! -d /web/platforms/$alias/tmp ] && mkdir -p /web/platforms/$alias/tmp
    [ ! -d /web/platforms/$alias/system ] && mkdir -p /web/platforms/$alias/system
    [ ! -d /web/platforms/$alias/log ] && mkdir -p /web/platforms/$alias/log
    [ ! -d /web/platforms/$alias/dpl ] && mkdir -p /web/platforms/$alias/dpl  
done < /web/deployment/alias.txt
