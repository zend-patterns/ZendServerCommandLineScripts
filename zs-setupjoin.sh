#!/bin/bash -ex

# Zend Web Administartion password for user Admin
zendadmin_ui_pass='zulutango99'
# Zend Web Administartion password for user Developer
zenddev_ui_pass='zalgreb00'
# Zend Server Purchise order number.
zend_order_number='Zulu-IL999'
# Zend Server License Key.
zend_license_key=''
# Zend Monitoring email.
zend_admin_email='nick@zend.com'
# Node hostname or nick name if specified.
zend_self_name=`hostname`
# Node IP address eth0
zend_self_addr=`ip a s dev eth0 | grep -oP 'inet\s+\K[^/]+'`
# Zend Cluster MySQL DB hostname or address.
zend_db_host=''
# Zend Cluster MySQL DB user name with admin priveleges. 
zend_db_user='root'
# Zend Cluster MySQL DB password.
zend_db_password='support'
# Zend Cluster Database name.
zend_db_name='testdb001'
# PHP version branch used by on the server. Same version of PHP on all the nodes is required. Use 5.3 or 5.4. 
zend_php_ver='5.4'


export PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
set -e

## Making sure wget and tar are present on the system

command -v wget >/dev/null 2>&1 || { echo >&2 "wget is not installed. Abort"; }
command -v tar >/dev/null 2>&1 || { echo >&2 "tar is not installed. Abort"; }

## Install Zend Server using Repoinstaller. 

cd /tmp
wget -q https://s3.amazonaws.com/nickscripts/ZendServer-6.1.0-RepositoryInstaller-linux.tar.gz
tar xvzf ZendServer-6.1.0-RepositoryInstaller-linux.tar.gz
ZendServer-RepositoryInstaller-linux/install_zs.sh "$zend_php_ver" --automatic

## Cleanup
rm -rf *

## Bootstrap and Creat or Join cluster. Command line tool used "zs-manage"

/usr/local/zend/bin/zs-manage bootstrap-single-server -p "$zendadmin_ui_pass" -o "$zend_order_number" -l "$zend_license_key" -r TRUE -a TRUE -e "$zend_admin_email" -d "$zenddev_ui_pass" || true
web_api_key=`sqlite3 /usr/local/zend/var/db/gui.db "select HASH from GUI_WEBAPI_KEYS where NAME='admin';"`
/usr/local/zend/bin/zs-manage server-add-to-cluster -n "$zend_self_name" -i "$zend_self_addr" -o "$zend_db_host" -u "$zend_db_user" -p "$zend_db_password" -d "$zend_db_name" -K $web_api_key -N "admin"


## Restart Zend Server to check components status. 

/usr/local/zend/bin/zendctl.sh restart
