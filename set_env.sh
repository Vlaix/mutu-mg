#!/bin/bash
#
# This script install a perfect env on the server
#

if [ $# -eq 0 ]
then
    echo "No arguments supplied"
    echo "Usage: ./set_env.sh alias domain passwd htpasswd htpasson cacheon cli"
    exit 1
fi

alias=$1
domain=$2
passwd=$3
htpasswd=$4
htpasson=$5
cacheon=$6
dbaddr=$7
dbname=$8
cli=$9

#add alias
echo "$alias $domain $passwd $htpasswd $htpasson $cacheon $dbaddr $dbname" >> /web/deployment/alias.txt

bash update_skel.sh
bash update_users.sh
bash update_nginx.sh
bash update_php.sh
bash update_logrotate.sh
bash update_varnish.sh
bash update_htpasswd.sh
bash update_fstab.sh
bash create_lvs.sh $alias

if [ "$cli" = "1" ] ; then
    /etc/init.d/php5-fpm restart
    cp test.php /web/platforms/$alias/public
fi

echo 1
