Sudo su 
#create a user and group for splunk by running the set of commands.
groupadd splunk
useradd -d /opt/splunk -m -g splunk splunk

#Check your OS architecture by executing the below command
uname -r

#Extract the downloaded splunk package by running the tar command followed by the downloaded zip file.
tar -xzvf splunk-6.6.3-e21ee54bc796-Linux-x86_64.tgz

#After extracting the downloaded package, copy all the content inside splunk directory to /opt/splunk directory which
#is the default home directory for splunk user that we have set in previous step.
cp -rp splunk/* /opt/splunk/

#Now change the ownership to splunk user
chown -R splunk: /opt/splunk/

#Switch to splunk user account and move to bin directory by executing the following command and list the files.
su - splunk
ls
cd bin
ls

#From the bin directory of splunk user execute the below command to install splunk onto your local machine.
./splunk start --accept-license

#Now splunk is installed in the target system. Switch over to the browser and goto link http://127.0.0.1:8000. The login page of Splunk appears on the screen.
