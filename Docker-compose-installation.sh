#!/bin/bash

<<Comment
Docker Compose is a tool that was developed to help define and share multi-container applications. With Compose, 
we can create a YAML file to define the services and with a single command, 
can spin everything up or tear it all down.
Comment

#Prerequisites- Docker installed

#To install curl, use the command

sudo yum install curl

#First, download the current stable release of Docker Compose (1.24.1.) by running the curl command.

sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# change the file permissions to make the software executable

sudo chmod +x /usr/local/bin/docker-compose

#Docker Compose does not require running an installation script. As soon as you download the software, it will be ready to use.
#To verify the installation, use the following command that checks the version installed

docker–compose –-version

#-------------------------------------------------------------------------------------------------------------------------------#
#If you are having trouble installing Docker Compose with the steps mentioned above, try downloading the software using the Pip package manager
#Simply type in the following command in the terminal window

sudo pip install docker-compose -y

#-----------------------------------------------------------#
#To uninstall Docker Compose, if you installed using curl run
sudo rm /usr/local/bin/docker-compose

#If you installed the software using the pip command, remove Docker Compose with the command
pip uninstall docker-compose
