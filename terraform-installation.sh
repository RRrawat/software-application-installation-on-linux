#!/bin/bash

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
