#!/bin/bash
#
# This script reinit user db
#

while read line; do
    alias=`echo $line | cut -d ' ' -f 1`
    bash unset_env.sh $alias
done < /web/deployment/alias.txt

/etc/init.d/nginx reload
