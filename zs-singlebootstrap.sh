#!/bin/bash -ex

.global.sh

export PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
set -e

## Making sure wget and tar are present on the system

command -v wget >/dev/null 2>&1 || { echo >&2 "wget is not installed. Abort"; }
command -v tar >/dev/null 2>&1 || { echo >&2 "tar is not installed. Abort"; }

## Install Zend Server using Repoinstaller
cd /tmp
wget -q https://s3.amazonaws.com/nickscripts/ZendServer-6.1.0-RepositoryInstaller-linux.tar.gz
tar xvzf ZendServer-6.1.0-RepositoryInstaller-linux.tar.gz
ZendServer-RepositoryInstaller-linux/install_zs.sh "$zend_php_ver" --automatic

## Cleanup
rm -rf *

## Bootstrap and Creat or Join cluster.

/usr/local/zend/bin/zs-manage bootstrap-single-server -p "$zendadmin_ui_pass" -o "$zend_order_number" -l "$zend_license_key" -r TRUE -a TRUE -e "$zend_admin_email" -d "$zenddev_ui_pass" 

## Restart Zend Server modules
/usr/local/zend/bin/zendctl.sh restart

$ command -v foo >/dev/null 2>&1 || { echo >&2 "I require foo but it's not installed.  Aborting."; exit 1; }
$ type foo >/dev/null 2>&1 || { echo >&2 "I require foo but it's not installed.  Aborting."; exit 1; }
$ hash foo 2>/dev/null || { echo >&2 "I require foo but it's not installed.  Aborting."; exit 1; }