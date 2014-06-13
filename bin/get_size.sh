#!/bin/bash
#
# This script give the size in octets of a public alias
#

if [ $# -eq 0 ]
then
    echo "No arguments supplied"
    echo "Usage: ./get_size.sh alias"
    exit 1
fi

alias=$1

result=`du -shb /web/platforms/$alias/public | cut -f 1`

echo $result
