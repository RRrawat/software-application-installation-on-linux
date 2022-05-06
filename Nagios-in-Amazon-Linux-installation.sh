#!/bin/bash

<<LongCommit
Install Prerequisite Software
Nagios requires the following packages are installed on your server prior to installing Nagios:

* Apache
* PHP
* GCC compiler
* GD development libraries
You can use yum to install these packages by running the following commands (as ec2-user)
LongCommit

sudo yum install httpd php
sudo yum install gcc glibc glibc-common
sudo yum install gd gd-devel

#Create Account Information, You need to set up a Nagios user. Run the following commands
sudo adduser -m nagios
sudo passwd nagios

#Type the new password twice.
sudo groupadd nagcmd
sudo usermod -a -G nagcmd nagios
sudo usermod -a -G nagcmd apache

#Download Nagios Core and the Plugins, Create a directory for storing the downloads.
mkdir ~/downloads
cd ~/downloads

#Download the source code tarball of both Nagios and the Nagios plugins.
wget http://prdownloads.sourceforge.net/sourceforge/nagios/nagios-4.0.8.tar.gz
wget http://nagios-plugins.org/download/nagios-plugins-2.0.3.tar.gz
#OR
#wget https://nagios-plugins.org/download/nagios-plugins-2.3.3.tar.gz

#Compile and Install Nagios, Extract the Nagios source code tarball.
tar zxvf nagios-4.0.8.tar.gz
cd nagios-4.0.8

#Run the configuration script with the name of the group which you have created in the above step
./configure --with-command-group=nagcmd
#Compile the Nagios source code.
make all
#Install binaries, init script, sample config files and set permissions on the external command directory.
sudo make install
sudo make install-init
sudo make install-config
sudo make install-commandmode

#Change E-Mail address with nagiosadmin contact definition you’d like to use for receiving Nagios alerts.
sudo make install-webconf
#Create a nagiosadmin account for logging into the Nagios web interface. Note the password you need it while login to Nagios web console.
sudo htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin       //Type the new password twice.
sudo service httpd restart                                             //Restart Service

#Compile and Install the Nagios Plugins, Extract the Nagios plugins source code tarball.
cd ~/downloads
tar zxvf nagios-plugins-2.0.3.tar.gz
cd nagios-plugins-2.0.3

#Compile and install the plugins.
./configure --with-nagios-user=nagios --with-nagios-group=nagios
make
sudo make install

#Start Nagios, Add Nagios to the list of system services and have it automatically start when the system boots.
sudo chkconfig --add nagios
sudo chkconfig nagios on

#Verify the sample Nagios configuration files.
sudo /usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg
#If there are no errors, start Nagios.
sudo service nagios start

<<Longcommet
Update AWS Security Group
you need to open port 80 on the new AWS EC2 server to incoming traffic so you can connect to the new Nagios webpage.

* From the EC2 console select Security Groups from the left navigation pane.
* Select the Security Group applicable for the instance that Nagios was installed on and open the Inbound tab
* If there is no rule to allow HTTP traffic on port 80 then click edit in the Inbound tab to add a new rule
* Click on New Rule button
* Scroll down to select HTTP from the list of Type
* If you want to be able to access Nagios from anywhere then select Save, otherwise enter the IP address or range of IP address you want to be able to access it from then select Save.

Log in to the Web Interface
access the Nagios web interface to do this you will need to know the Public DNS or IP for your instance, you can get this from the Instance section of the EC2 Console if you do not already know it. You’ll be prompted for the username (nagiosadmin) and password you specified earlier.

e.g. http://ec2-xx-xxx-xxx-xx.ap-west-1.compute.amazonaws.com/nagios/

This is the end of the Tutorial, we detailed Step By Step method for installing Nagios in Amazon Linux.
Longcommet
