#!/bin/bash

#update the package database
sudo yum check-update
#Now run this command. It will add the official Docker repository, download the latest version of Docker, and install it
curl -fsSL https://get.docker.com/ | sh
    #for amazon linux you can install by below commands.
    sudo yum update
    sudo yum search docker
    sudo yum info docker
    sudo yum install docker -y
    
#After installation has completed, start the Docker daemon
sudo systemctl start docker
#Verify that it’s running
sudo systemctl status docker
#Lastly, make sure it starts at every server reboot
sudo systemctl enable docker

#Executing Docker Command Without Sudo (Optional)
#If you want to avoid typing sudo whenever you run the docker command, add your username to the docker group
sudo usermod -aG docker $(whoami)
#If you need to add a user to the docker group that you’re not logged in as, declare that username explicitly using
sudo usermod -aG docker username
#With Docker installed and working, now’s the time to become familiar with the command line utility. 
#Using docker consists of passing it a chain of options and subcommands followed by arguments. The syntax takes this form.
docker [option] [command] [arguments]
