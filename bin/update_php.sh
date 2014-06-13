#!/bin/bash
#
# This script reinit php  pools config
#

rm /etc/php5/fpm/pool.d/*
cp template.www.pool.conf /etc/php5/fpm/pool.d/www.pool.conf
cp template.enska.pool.conf /etc/php5/fpm/pool.d/enska.pool.conf

while read line; do
    alias=`echo $line | cut -d ' ' -f 1`
    cp template.alias.pool.conf /etc/php5/fpm/pool.d/$alias.pool.conf 
    sed -i "s/@@alias@@/$alias/g" /etc/php5/fpm/pool.d/$alias.pool.conf
done < /web/deployment/alias.txt

#/etc/init.d/php5-fpm reload
