## Deploying Zend Server Cluster using command line scripts. Four node example. 
================

### Introduction.
---------------
This tutorilal explains how to setup Zend Server Cluster using bash scripts. 

Scripts examples have been written to provide base to custom integration of Zend Server into current deployment framework or as an easy to read example which can be implemented in other programming languages. 

Zend Server user interface is driven by MySQL database and separate instance of MySQL is required.


### Installation.
---------------

1. Installing and configuring MySQL. 
	
		./mysql-install.sh 
	
	The goal of this step is to install and configure MySQL database backend to be used by **Zend Server Cluster Nodes**. Best practices would be to creat separate user with permissions on an empty database. "Registration" of the Zend Server node to the database will populate it with required structure. For small non-production environment location of the MySQL is no critical and can reside on one of the cluster nodes.  
	
2. Adding user with **Admin** priveleges on the database which will be used by **Zend Cluster**.
	 

    	mysql> CREATE zend_db_name;
		
    	mysql> CREATE USER 'zend_db_user'@'localhost' IDENTIFIED BY 'zend_db_pass';
    
		mysql> GRANT ALL PRIVILEGES ON zend_db_name.* TO 'zend_db_user'@'localhost' WITH GRANT OPTION;
	
		mysql> CREATE USER 'zend_db_user'@'%' IDENTIFIED BY 'zend_db_pass';
	
		mysql> GRANT ALL PRIVILEGES ON zend_db_name.* TO 'zend_db_user'@'%'
    WITH GRANT OPTION;
	
	
	Above provided example of SQL sintax to create database and use and grant required permissions.
	
3. Install Zend Command Line scripts on all the nodes.
	
		yum -y install git
	
		git clone git://github.com/zendtech/ZendServerCommandLineScripts.git ----recursive
4. Changing Zend Server variables according to current licenses and passwords
   
   		nano -w globals.sh
	
	
5. Runing Zend Command Line script and join cluster.
   
   		./zs-setupjoin.sh

6. Extras

	- Enable session clustering from command line.
  	- Deploy an application from command line.
  	- Remove node. 
 
 