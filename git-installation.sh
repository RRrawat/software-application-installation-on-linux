#!/bin/bash

#Update the software package of the instance using the below command.
sudo yum update -y

#Use yum, native package manager, to search for and install the latest git package available in repositories.
sudo yum install git

#If the command completes without error, you will have git downloaded and installed. 
#To double-check that it is working correctly, try running Git’s built-in version check.
git --version


<<Longcommet
Now that you have git installed, you will need to configure some information about yourself so that commit messages
will be generated with the correct information attached. To do this, use the git config command to 
provide the name and email address that you would like to have embedded into your commits:
Longcommet

git config --global user.name "Your Name"

git config --global user.email "you@example.com"

#To confirm that these configurations were added successfully, we can see all of the configuration items that have been set by typing:
git config --list
