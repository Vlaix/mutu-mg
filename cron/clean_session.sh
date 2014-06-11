#!/bin/bash
#
# This script del all sessions
#

while read line; do
    alias=`echo $line | cut -d ' ' -f 1`
    rm /web/platforms/$alias/session/*
done < /web/deployment/alias.txt
