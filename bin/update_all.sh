#!/bin/bash
#
# This script reinit everything
#

alias=$1
domain=$2
passwd=$3
htpasswd=$4
htpasson=$5
cacheon=$6

bash update_nginx.sh
bash update_varnish.sh
bash update_users.sh
bash update_varnish.sh
bash update_htpasswd.sh
bash update_rights.sh
