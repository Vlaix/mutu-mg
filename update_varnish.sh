#!/bin/bash
#
# This script reinit varnish config
#

rm /etc/varnish/default.vcl
rm /etc/varnish/inc_recv.vcl
cp template.default.vcl /etc/varnish/default.vcl
cp template.inc_recv.vcl  /etc/varnish/inc_recv.vcl

while read line; do
    domain=`echo $line | cut -d ' ' -f 2`
    cacheon=`echo $line | cut -d ' ' -f 6`
    if [ "$cacheon" = "0" ] ; then
        echo "if ((req.http.host ~ \"$domain\")) { return (pass); }" >> /etc/varnish/inc_recv.vcl
    elif [ "$cacheon" = "1" ] ; then
        echo "if ((req.http.host ~ \"$domain\")) { set req.backend = default; }" >> /etc/varnish/inc_recv.vcl
    fi
done < /web/deployment/alias.txt

service varnish reload
