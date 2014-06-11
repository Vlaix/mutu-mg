apt-get update
apt-get -y upgrade
apt-get -y install ntp git php-fpm nginx varnish
ntpd -q

mkdir -p /web/{platforms
