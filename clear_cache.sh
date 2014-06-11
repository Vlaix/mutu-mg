#!/bin/bash
#
# This script clear cache for a domain
#

if [ $# -eq 0 ]
then
    echo "No arguments supplied"
    echo "Usage: ./clear_cache.sh domain"
    exit 1
fi

domain=$1

varnishadm -S /etc/varnish/secret -T127.0.0.1:6082 "ban req.http.host == $domain"
