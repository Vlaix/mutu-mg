#!/bin/bash
#
# This script reinit user db
#

while read line; do
    alias=`echo $line | cut -d ' ' -f 1`
    passwd=`echo $line | cut -d ' ' -f 3`
    id -u $alias >/dev/null 2>&1
    if [ $? -ne 0 ] ; then
        useradd -d /web/platforms/$alias -s /bin/bash -p $(echo $passwd | openssl passwd -1 -stdin) $alias
    fi
    usermod -aG $alias www-data
    chmod -R 755 /web/platforms/$alias
    chown -R $alias:$alias /web/platforms/$alias
    chown root:root /web/platforms/$alias
    chmod 755 /web/platforms/$alias    
done < /web/deployment/alias.txt

cp template.sshd_config /etc/ssh/sshd_config

while read line; do
    alias=`echo $line | cut -d ' ' -f 1`
cat << EOF >> /etc/ssh/sshd_config
    Match User $alias
    ChrootDirectory /web/platforms/$alias
    ForceCommand internal-sftp
    AllowTCPForwarding no
    X11Forwarding no
EOF
done < /web/deployment/alias.txt
/etc/init.d/ssh reload
