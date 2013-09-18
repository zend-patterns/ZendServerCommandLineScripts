#!/bin/bash -ex


export PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
set -e

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

zendadmin_ui_pass='zulutango99'
zenddev_ui_pass='zalgreb00'
zend_order_number='Zulu-IL999'
zend_admin_email='nick@zend.com'
zend_license_key=''
zend_self_name=`hostname`
zend_self_addr=`ip a s dev eth0 | grep -oP 'inet\s+\K[^/]+'`
zend_db_host=''
zend_db_user='root'
zend_db_password='support'
zend_db_name='testdb001'
zend_php_ver='5.4'

## Install Zend Server using Repoinstaller

cd /tmp
wget -q https://s3.amazonaws.com/nickscripts/ZendServer-6.1.0-RepositoryInstaller-linux.tar.gz
tar xvzf ZendServer-6.1.0-RepositoryInstaller-linux.tar.gz
ZendServer-RepositoryInstaller-linux/install_zs.sh "$zend_php_ver" --automatic

## Bootstrap and Creat or Join cluster.

/usr/local/zend/bin/zs-manage bootstrap-single-server -p "$zendadmin_ui_pass" -o "$zend_order_number" -l "$zend_license_key" -r TRUE -a TRUE -e "$zend_admin_email" -d "$zenddev_ui_pass" || true
web_api_key=`sqlite3 /usr/local/zend/var/db/gui.db "select HASH from GUI_WEBAPI_KEYS where NAME='admin';"`
/usr/local/zend/bin/zs-manage server-add-to-cluster -n "$zend_self_name" -i "$zend_self_addr" -o "$zend_db_host" -u "$zend_db_user" -p "$zend_db_password" -d "$zend_db_name" -K $web_api_key -N "admin"