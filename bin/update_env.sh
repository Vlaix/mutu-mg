if [ $# -eq 0 ]
then
    echo "No arguments supplied"
    echo "Usage: ./update_env.sh alias domain sftpPasswd htPasswd htpasson cacheon"
    exit 1
fi

alias=$1
domain=$2
passwd=$3
htpasswd=$4
htpasson=$5
cacheon=$6

sed "/^$alias /d" -i /web/deployment/alias.txt
echo "$alias $domain $passwd $htpasswd $htpasson $cacheon" >> /web/deployment/alias.txt

bash update_nginx.sh
bash update_varnish.sh
bash update_htpasswd.sh
