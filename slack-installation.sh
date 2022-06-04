#!/bin/bash

#sudo privileges.
sudo su

#First, let’s start by ensuring your system is up-to-date.
yum clean all

yum install epel-release

yum -y update

yum install libappindicator

#Installing Slack on CentOS.
#Go to the Slack for Linux download page and download the latest Slack .rpm package:
wget https://downloads.slack-edge.com/linux_releases/slack-3.3.8-0.1.fc21.x86_64.rpm

#After downloads successful, now install Slack using following command:
sudo yum -y install slack-3.3.8-0.1.fc21.x86_64.rpm

<<Longcommet

Now that you have Slack installed on your CentOS desktop, you can start it either from the command 
line by typing slack or by clicking on the Slack icon (Activities -> Slack).
Congratulation’s! You have successfully installed Slack. 
Thanks for using this tutorial for installing Slack on CentOS 7 system. 
For additional help or useful information, we recommend you to check the official Slack website.

Longcommet
