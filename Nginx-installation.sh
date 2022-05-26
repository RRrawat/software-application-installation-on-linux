#!/bin/bash

#Firstly, check if the EPEL repository is enabled.
sudo amazon-linux-extras list | grep epel

#you will get output similar to "24  epel      available    [ =7.11  =stable ]"
#If you don’t have EPEL repository already installed you can do it by typing:
sudo yum install epel-release

#To enable the EPEL repo on Amazon Linux 2 instance run.
sudo amazon-linux-extras enable epel

#Now you should be able to install the EPEL repo.
sudo yum install epel-release

# Once the EPEL repo is installed you can install the Nginx latest version as well.
sudo yum install nginx -y

#Once the installation is complete, enable and start the Nginx service with:
sudo systemctl enable nginx
sudo systemctl start nginx

#Check the status of the Nginx service with the following command
sudo systemctl status nginx

#If your server is protected by a firewall you need to open both HTTP (80) and HTTPS (443) ports.
sudo firewall-cmd --permanent --zone=public --add-service=http
sudo firewall-cmd --permanent --zone=public --add-service=https
sudo firewall-cmd --reload

#To verify your Nginx installation, open http://YOUR_IP in your browser of choice, and you will see the default Nginx welcome page.
#To stop the Nginx service
sudo systemctl stop nginx

#To restart the Nginx service :
sudo systemctl restart nginx

#Reload the Nginx service after you have made some configuration changes
sudo systemctl reload nginx


