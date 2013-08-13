#!/bin/bash -e
# Author: Nick Maiorsky nick@zend.com
# Import global conf 
. global_conf

export PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
set -e

#PROGNAME=`basename $0`
#ADD_SERVER_OPTIONS="--retry 150 --wait 5 "

## Function to display errors and exit ##
function check_error()
{
   if [ ! "$?" = "0" ]; then
      error_exit "$1"; 
   fi
}

## Function To Display Error and Exit
function error_exit()
{
   echo "${PROGNAME}: ${1:-"Unknown Error"}" 1>&2
   exit 1
}

## Configure Zend Server tools ##
zsroot=/usr/local/zend
zsmanage=$zsroot/bin/zs-manage

## Join Zend Cluster configured as cluster node ##

if [ "$zendnode_is_node" = "1" ] ; then 
        $zsmanage bootstrap-single-server -p "$zendnode_ui_pass" -o "$zend_order_number" -l "$zend_license_key" -r TRUE -a TRUE -e "$zend_admin_email" -d "dpassword" || true
        $zsroot/bin/zendctl.sh restart
        web_api_key=`sqlite3 /usr/local/zend/var/db/gui.db "select HASH from GUI_WEBAPI_KEYS where NAME='admin';"`
        $zsmanage server-add-to-cluster -n "$zend_self_name" -i "$zend_self_addr" -o "$zend_db_host" -u "$zend_db_user" -p "$zend_db_password" -d "ZendServer" -K $web_api_key -N "admin"
else
         $zsmanage bootstrap-single-server -p "$zendnode_ui_pass" -o "$zend_order_number" -l "$zend_license_key" -r "TRUE" -a "TRUE" -e "$zend_admin_email" -d dpassword || true
         $zsroot/bin/zendctl.sh restart
fi

## Enable logrotate for Zend Server logs ##

touch /etc/logrotate.d/zend-server
chmod 655 /etc/logrotate.d/zend-server

cat > /etc/logrotate.d/zend-server <<EOF
/usr/local/zend/var/log/*.log {
        size 5M
        missingok
        rotate 10
        compress
        delaycompress
        copytruncate
}
EOF

## Install and enable cron service ##

yum -y install vixie-cron
service crond start
chkconfig crond on

## Check if logrotate is in daily cron jobs.

if [ -f /etc/cron.daily/logrotate ]
   then 
       echo "Logrotate daily configuration exists." 
   else   
        check_error "Logrotate cron daily is missing."
fi

## Output GUI_WEBAPI_KEY ##
#web_api_key=$sqlite3 /usr/local/zend/var/db/gui.db "select HASH from GUI_WEBAPI_KEYS where NAME='admin';"
