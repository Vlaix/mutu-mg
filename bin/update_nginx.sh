#!/bin/bash
#
# This script reinit nginx vhosts config
#

rm /etc/nginx/sites-available/*
rm /etc/nginx/sites-enabled/*
cp template.default.vhost.conf /etc/nginx/sites-available/default.vhost.conf
cp template.enska.vhost.conf /etc/nginx/sites-available/enska.vhost.conf
ln -s /etc/nginx/sites-available/default.vhost.conf /etc/nginx/sites-enabled/default.vhost.conf
ln -s /etc/nginx/sites-available/enska.vhost.conf /etc/nginx/sites-enabled/enska.vhost.conf

while read line; do
    alias=`echo $line | cut -d ' ' -f 1`
    domain=`echo $line | cut -d ' ' -f 2`
    htpasson=`echo $line | cut -d ' ' -f 5`
    cp template.alias.vhost.conf /etc/nginx/sites-available/$alias.vhost.conf
    ln -s /etc/nginx/sites-available/$alias.vhost.conf /etc/nginx/sites-enabled/$alias.vhost.conf
    sed -i "s/@@alias@@/$alias/g" /etc/nginx/sites-available/$alias.vhost.conf
    sed -i "s/@@url@@/$domain www.$domain/g" /etc/nginx/sites-available/$alias.vhost.conf
    if [ "$htpasson" = "0" ] ; then
        sed -i "/auth_basic_user_file/d" /etc/nginx/sites-available/$alias.vhost.conf
        sed -i "/auth_basic/d" /etc/nginx/sites-available/$alias.vhost.conf
    fi
done < /web/deployment/alias.txt

/etc/init.d/nginx reload
