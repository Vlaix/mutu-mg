#!/bin/bash
# this script manage DNS dynamically

opt=$1
alias=$2
dst=$3

nsupdate_command="nsupdate -k /etc/bind/Knoadmin.io.+157+65095.private -v"

deldns(){
$nsupdate_command << EOF
    server 127.0.0.1
    zone noadmin.io.
    update delete $alias.noadmin.io. IN CNAME $dst.noadmin.io.
    send
    quit
EOF
}
 
adddns(){
$nsupdate_command << EOF
    server 127.0.0.1
    zone noadmin.io.
    update add $alias.noadmin.io. 3600 IN CNAME $dst.noadmin.io.
    send
    quit
EOF
}

if [ $# -eq 3 ]; then
    case $opt in
        add) adddns;;
        del) deldns;;
        *) echo "Usage..." exit 1;;
    esac
elif [ $# -ne 3 ]; then
    echo "Usage ..."
    exit 1
fi

rndc freeze noadmin.io
rndc thaw noadmin.io
