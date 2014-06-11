#!/bin/bash
#
# This script delete an env on the server
#

if [ $# -eq 0 ]
then
    echo "No arguments supplied"
    echo "Usage: ./unset_env.sh username"
    exit 1
fi

alias=$1

umount /dev/vg/$alias
sed "/^$alias /d" -i /web/deployment/alias.txt
rm -rf /web/platforms/$alias
rm /etc/nginx/sites-available/$alias.vhost.conf
rm /etc/nginx/sites-enabled/$alias.vhost.conf
rm /etc/php5/fpm/pool.d/$alias.pool.conf
rm /etc/logrotate.d/$alias.logrotate.conf

lvremove -f /dev/vg/$alias

service nginx reload
deluser $alias >> /tmp/debug.txt 2>&1
gpasswd -d www-data $alias >> /tmp/debug.txt 2>&1
delgroup $alias >> /tmp/debug.txt 2>&1

bash update_users.sh
