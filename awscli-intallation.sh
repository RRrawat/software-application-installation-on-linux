#!/bin/bash

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

#List users in a different format
aws iam list-users –output table

#List the sizes of an S3 bucket and its contents
aws s3api list-objects --bucket BUCKETNAME --output json --query "[sum(Contents[].Size), length(Contents[])]"

#Move S3 bucket to a different location
aws s3 sync s3://oldbucket s3://newbucket --source-region us-west-1 --region us-west-2

#List users by ARN
aws iam list-users –output json | jq -r .Users[].Arn
#Note: jq, might not be installed on your system by default. On Debian-based systems (including Ubuntu), use sudo apt-get install jq

#List all of your  instances that are currently stopped and the reason for the stop
aws ec2 describe-instances --filters Name=instance-state-name,Values=stopped --region eu-west-1 --output json | jq -r .Reservations[].Instances[].StateReason.Message

#Test one of your public CloudFormation templates
aws cloudformation validate-template --region eu-west-1 --template-url https://s3-eu-west-1.amazonaws.com/ca/ca.cftemplate

#Other ways to pass input parameters to the AWS CLI with JSON:
aws iam put-user-policy --user-name AWS-Cli-Test --policy-name Power-Access --policy-document '{ "Statement": [ { "Effect": "Allow", "NotAction": "iam:*", "Resource": "*" } ] }'
