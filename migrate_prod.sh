#!/bin/bash
#
# This script deploy a prod env for the first time
#

if [ $# -eq 0 ]
then
    echo "No arguments supplied"
    echo "Usage: ./set_first_env.sh alias"
    exit 1
fi

alias=$1
srvmut=$2

cd /web/platforms/$alias && zip -r $alias.zip -r public
mv /web/platforms/$alias/$alias.zip /web/temp
scp -i /web/platform/.ssh/id_rsa /web/temp/$alias.zip root@$srvmut.noadmin.io:/web/temp
#rm /web/temp/$alias.zip
#rm -rf /web/platforms/$alias
