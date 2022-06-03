#Prerequisites 
#The user you are logging in as must have sudo privileges to be able to install packages.
sudo su

#Gradle requires Java JDK or JRE version 7 or above to be installed.
#Install the OpenJDK 8 package with the following command:
sudo yum install java-1.8.0-openjdk-devel

#Verify the Java installation by printing the Java version :
java -version

<<Longcommet
Download Gradle:
At the time of writing this article, the latest version of Gradle is 5.0. Before continuing with the next step you should check the Gradle releases page
to see if a newer version is available.

Start by downloading the Gradle Binary-only zip file in the /tmp directory using the following wget command:

Longcommet

wget https://services.gradle.org/distributions/gradle-5.0-bin.zip -P /tmp

#When the download is complete, extract the zip file in the /opt/gradle directory:
sudo unzip -d /opt/gradle /tmp/gradle-5.0-bin.zip

#Verify that the Gradle files are extracted by listing the /opt/gradle/gradle-5.0 directory:
ls /opt/gradle/gradle-5.0

<<Longcommet
Setup environment variables
The next step is to configure the PATH environment variable to include the Gradle bin directory. To do so, 
open your text editor and create a new file named gradle.sh 
inside of the /etc/profile.d/ directory.

Longcommet
sudo nano /etc/profile.d/gradle.sh

#Paste the following configuration:
export GRADLE_HOME=/opt/gradle/gradle-5.0
export PATH=${GRADLE_HOME}/bin:${PATH}

#Save and close the file. This script will be sourced at shell startup.
#Make the script executable by issuing the following chmod command:
sudo chmod +x /etc/profile.d/gradle.sh

#Load the environment variables using the source command :
source /etc/profile.d/gradle.sh
