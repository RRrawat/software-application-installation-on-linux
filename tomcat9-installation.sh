#!/bin/bash -v


sudo su -
#Update the server 
yum -y update
cd /opt

#Install Java on linux
amazon-linux-extras install java-openjdk11 -y

#Run the following commands to download the version(v9.0.60) of Apache Tomcat 9 
wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.60/bin/apache-tomcat-9.0.60.tar.gz

#Use tar command line tool to extract downloaded archive.
tar -xvzf /opt/apache-tomcat-9.0.60.tar.gz

#Rename tomcat to simplest name so easy for us to maintain in later stage.
mv apache-tomcat-9.0.60 tomcat

#Update folder permissions.
chown ec2-user /opt/tomcat/webapps
ln -s /opt/tomcat/bin/startup.sh /usr/local/bin/tomcatup
ln -s /opt/tomcat/bin/shutdown.sh /usr/local/bin/tomcatdown

#Enable and start tomcat service
tomcatup
