#!/bin/bash
#
# This script del a user list in arg
#

if [ $# -eq 0 ]
then
    echo "No arguments supplied"
    echo "Usage: ./set_the_user_list.sh file"
    exit 1
fi

file=$1

while read line; do
    alias=`echo $line | cut -d ' ' -f 1`
    deluser $alias
    delgroup $alias 
done < /web/deployment/$file
