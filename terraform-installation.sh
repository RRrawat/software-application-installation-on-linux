#!/bin/bash

#You should have sudo access to run all the privilege commands
sudo su 

#First you need to update your system by using yum update command.
yum update -y

#Make sure you have wget and unzip tool installed in your system. If you don't have then you can download from below command.
yum install wget unzip

#Then you need to download the latest version of Terraform package.
wget https://releases.hashicorp.com/terraform/0.12.17/terraform_0.12.17_linux_amd64.zip

#Once downloaded you need to unzip the package on /usr/local/bin.
unzip terraform_0.12.17_linux_amd64.zip -d /usr/local/bin/

#After successfully unzipping the package, you can check the terraform version using terraform -v command.
terraform -v

#common comands in terraform 
terraform init #terraform init command is used to initialize a working directory containing Terraform configuration files. 
terraform fmt #The terraform fmt command is used to rewrite Terraform configuration files to a canonical format and style. 
terraform plan 
#The terraform plan command evaluates a Terraform configuration to determine the desired state of all the resources it declares, 
#then compares that desired state to the real infrastructure objects being managed with the current working directory and workspace.
terraform apply #Terraform apply command is used to create or introduce changes to real infrastructure. 
terraform destroy  #The terraform destroy command is a convenient way to destroy all remote objects managed by a particular Terraform configuration.
