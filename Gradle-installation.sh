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

