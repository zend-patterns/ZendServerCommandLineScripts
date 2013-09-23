## Zend Server Bash intergration examples using Web Api and Cli tools.
***

==================
## Introduction
============

**Zend Server** comes with set of APIs and tools that enable fully automation of deployment and configuration. Entire clusters of **Zend Server PHP Application Servers** can be created by running only few simple commands. Scripts and examples listed should serve as easy to read orientation or base for complex cloud or other automation. 

## Installation
------------

Clone the code from Github :

	git clone git://github.com/zendtech/ZendServerCommandLineScripts.git --recursive

## Usage
-----

Edit globals.sh to match your licensing information and passwords.
	
	nano -w globals.sh

Join already existing cluster or setup one.

	./zs-setupjoin.sh

Bootstrap a single server for production or development use.

	./zs-singlebootstrap.sh
 
	

