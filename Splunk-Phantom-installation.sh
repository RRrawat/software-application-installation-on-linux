#!/bin/bash

<<Longcommet
Install Splunk Phantom as an unprivileged user
Tar file distributions of Splunk Phantom are available for installations where Splunk Phantom will run as an unprivileged user.

Before you install Splunk Phantom as an unprivileged user, the root user or a user with sudo access must prepare the system.

Do all these tasks with root permissions, either by logging in as root or as a user with sudo permission.

Install the operating system dependencies
Do all these tasks with root permissions, either by logging in as root or as a user with sudo permission

Longcommet

#Edit /etc/selinux/config to disable SELinux. Change the SELINUX= entry to:
SELINUX=disabled

#Clear yum caches.
yum clean all

#Update installed packages. 
yum update -y

#Restart the operating system.
shutdown -r now

#Install dependencies.
yum install -y libevent libicu c-ares bind-utils java-1.8.0-openjdk-headless mailcap fontconfig ntpdate perl rsync xmlsec1 xmlsec1-openssl libxslt ntp zip net-tools policycoreutils-python libxml2 libcurl gnutls

#If you are using an external file share using GlusterFS, download the GlusterFS packages.

mkdir gfinstall

cd gfsinstall 

curl -O https://repo.phantom.us/phantom/4.10/base/7/x86_64/glusterfs-7.5-1.el7.x86_64.rpm

curl -O https://repo.phantom.us/phantom/4.10/base/7/x86_64/glusterfs-api-7.5-1.el7.x86_64.rpm

curl -O https://repo.phantom.us/phantom/4.10/base/7/x86_64/glusterfs-cli-7.5-1.el7.x86_64.rpm

curl -O https://repo.phantom.us/phantom/4.10/base/7/x86_64/glusterfs-client-xlators-7.5-1.el7.x86_64.rpm

curl -O https://repo.phantom.us/phantom/4.10/base/7/x86_64/glusterfs-coreutils-0.2.0-1.el7.x86_64.rpm

curl -O https://repo.phantom.us/phantom/4.10/base/7/x86_64/glusterfs-devel-7.5-1.el7.x86_64.rpm

curl -O https://repo.phantom.us/phantom/4.10/base/7/x86_64/glusterfs-events-7.5-1.el7.x86_64.rpm

curl -O https://repo.phantom.us/phantom/4.10/base/7/x86_64/glusterfs-fuse-7.5-1.el7.x86_64.rpm

curl -O https://repo.phantom.us/phantom/4.10/base/7/x86_64/glusterfs-libs-7.5-1.el7.x86_64.rpm

curl -O https://repo.phantom.us/phantom/4.10/base/7/x86_64/glusterfs-server-7.5-1.el7.x86_64.rpm

#If you are using an external file share using GlusterFS, install the GlusterFS packages.
yum install *.rpm -y

#Set firewall rules to allow the required ports listed in Splunk Phantom required ports.
#Synchronize the system clock.

ntpdate -v -u 0.centos.pool.ntp.org
systemctl enable ntpd

<<Longcommet
Create the user account that will run Splunk Phantom
An unprivileged install of Splunk Phantom will run in the user space of a specific user.
Create the user account that will be used to run Splunk Phantom.

Longcommet

adduser -c "Phantom User" <username>
passwd <username>

#Create a directory for Splunk Phantom.
su - <username> -c "mkdir /home/<username>/<directory_name>"

#Create a file called /etc/security/limits.d/25-phantom-limits.conf. This file sets resource limits for the user that will run Splunk Phantom.
touch /etc/security/limits.d/25-phantom-limits.conf

#Edit the file /etc/security/limits.d/25-phantom-limits.conf to add these settings:
<username>          hard    nofile          64000
<username>          soft    nofile          64000
<username>          hard    nproc           64000
<username>          soft    nproc           64000 

#Save the file.
#Apply the new security settings.
sysctl --system
<<Longcommet
Install Splunk Phantom from the tar file
Log in as the user that will run Splunk Phantom. Do not perform these steps as the root user.
Copy the installation tar file to the directory /home/<username>/<directory_name> created earlier.
Verify your downloaded file's SHA256 hash against the SHA256 hash displayed on the Splunk Phantom Community site.
Longcommet

sha256sum  phantom-<version>.tgz

#Extract the Splunk Phantom tar file.

tar -xvzf phantom-<version>.tgz

#Copy the new kernel settings file 50-phantom.conf from the the extracted files to /etc/sysctl.d. This step requires sudo permissions.
cp /home/<directory_name>/etc/sysctl.d/50-phantom.conf /etc/sysctl.d/

#Apply the new kernel settings. This step requires sudo permissions.

sysctl --system

#Run the installation script. Make sure to specify the ports for Splunk Phantom to use for HTTPS traffic. The HTTPS port cannot be a port which is already in use. This port must be a port greater than 1023.
./phantom_tar_install.sh install --https-port=<port>

#For more installation command line options, see phantom_tar_install.sh options.
#You can log in to the Splunk Phantom web interface after the setup script completes to configure user accounts and additional settings. See Log in to the Splunk Phantom web interface.
