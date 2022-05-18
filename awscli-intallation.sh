#You should have sudo access to run all the privilege commands
sudo su 

#Update Your System
yum update -y

#Install AWS CLI
yum install awscli -y

#Check AWS CLI version
aws --version

#Configure AWS CLI
aws configure

<<Longcommet
Now we can go ahead and configure aws command line to access the AWS Resources. 
You can configure it by using aws configure command as shown below. Here you need 
to provide AWS Access Key ID, AWS Secret Access Key and Default Region Name. 
Once you provide all the details you can see a hidden directory .aws created on 
User home directory which contains two files - Credentials and Config. 
You can find the aws secret key and aws access key in credential file and default region in config file.

Longcommet

#Top 10 common command

#Delete an S3 bucket and all its contents with just one command
aws s3 rb s3://bucket-name –force

#Recursively copy a directory and its subfolders from your PC to Amazon S3
aws s3 cp MyFolder s3://bucket-name — recursive [–region us-west-2]

#Display subsets of all available ec2 images
aws ec2 describe-images | grep ubuntu
