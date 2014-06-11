#!/bin/bash

rm /etc/nginx/sites-available/*
rm /etc/nginx/sites-enabled/*

for i in {1..10000}
do
    cp template.alias.vhostmin.conf /etc/nginx/sites-available/$i.vhost.conf
    ln -s /etc/nginx/sites-available/$i.vhost.conf /etc/nginx/sites-enabled/$i.vhost.conf
    sed -i "s/@@alias@@/$i/g" /etc/nginx/sites-available/$i.vhost.conf
    sed -i "s/@@url@@/$i.com www.$i.com/g" /etc/nginx/sites-available/$i.vhost.conf
    sed -i "/auth_basic_user_file/d" /etc/nginx/sites-available/$i.vhost.conf
    sed -i "/auth_basic/d" /etc/nginx/sites-available/$i.vhost.conf
done
