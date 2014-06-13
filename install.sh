apt-get update
apt-get -y upgrade
apt-get -y install ntp git php5-fpm nginx varnish
ntpd -q
mkdir -p /web/{platforms,deployment}
cd /web/deployment && git clone https://github.com/dw33z1lP/mutu-mg.git .
mkdir /web/deployment/db
touch /web/deployment/db/alias.txt
touch /web/deployment/db/alias_to_remove.txt
mkdir -p /web/deployment/hookonfs/{varnish,php,nginx,htpasswd}
