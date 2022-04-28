#!/bin/sh
#Update the software package of the instance using the below command.
sudo yum update -y
#Install java packages.
sudo amazon-linux-extras install -y java-openjdk11
#Add the stable Jenkins repo.
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo
#Import the key file.
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum upgrade
#Install Jenkins using the below command
sudo yum install -y jenkins
sudo chkconfig jenkins on
#Start the Jenkins service.
sudo service jenkins start

#Open the browser and hit the public IP along with the 8080 port. Jenkins will ask for the admin password Copy the path and get the password from the server.
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

#after login into the jenkins server Install the suggested plugins and add the user credentials and save it
#Installation and configuration are completed and now you can start creating the Jenkins jobs.




