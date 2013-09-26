#!/bin/bash
# Linux/UNIX box with ssh key based login
SERVERS="192.168.15.1 192.168.15.2 192.168.15.3"
# SSH User name
USR="zendadmin"
 

# Connect each host and run join or creat cluster script
for host in $SERVERS
do
ssh $USR@$host ./zs-setupjoin.sh
done
 
