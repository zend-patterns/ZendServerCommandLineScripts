#!/bin/bash -e
# This is a default Zend Server node PHP 5.3 installation.Configurations will be done though configuration scripts. 
# Nick Maiorsky  
# Import global conf 
. $global_conf

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/opt/vmware/bin:/opt/vmware/bin
export HOME=/root

PROGNAME=`basename $0`

##Funtion to Check Error
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


## Creating Zend directory /opt/vmware/zend
mkdir -p /opt/vmware/zend
cd /opt/vmware/zend

## Cleanup
rm -rf *
check_error "Errors during cleanup."

## Download Zend Server yum configuration and installer tar ball
wget --output-document=zendserver-install.tar.gz $DOWNLOADRPMURL
check_error "Unable to download Zend Server configuration and installer. "

## Extracting tar ball
tar -xvf zendserver-install.tar.gz
check_error "Unable to untar Zend Server tar ball."; 

## Copy repostory configuration files
cp ZendServer-RepositoryInstaller-linux/zend.rpm.repo /etc/yum.repos.d/
check_error "Unable to copy zend repo file to yum repos."

## Update yum following repository change
#yum -y update
#check_error "Unable to update yum."

## Install Zend Server 
yum -y install zend-server-php-5.3
check_error "Unable to install Zend Server via yum."

## Start Zend Server with restart
/etc/init.d/zend-server restart
check_error "Unable to start Zend Server." 