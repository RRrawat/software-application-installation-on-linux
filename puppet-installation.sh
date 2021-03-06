#Installing Puppet Master and Agent in RHEL/CentOS 7/6/5

<<LongCommit
you must have root or superuser access to all of the servers that you want to use Puppet with. 
You will also be required to create a new CentOS 7 server to act as the Puppet master server. 
If you do not have an existing server infrastructure, feel free to recreate the example infrastructure (described below) 
by following the prerequisite DNS setup tutorial.

Before we get started with installing Puppet, ensure that you have the following prerequisites:

Private Network DNS: Forward and reverse DNS must be configured, and each server must have a unique hostname. 
Here is a tutorial to configure your own private network DNS server. If you do not have DNS configured, 
you must use your hosts file for name resolution. We will assume that you will use your private network for communication within your infrastructure.
Firewall Open Ports: The Puppet master must be reachable on port 8140. If your firewall is too restrictive, 
check out this FirewallD Tutorial for instructions on how to allow incoming requests on port 8140.


Install NTP
Because it acts as a certificate authority for agent nodes, the Puppet master server must maintain accurate system time to avoid potential problems when 
it issues agent certificates–certificates can appear to be expired if there are time discrepancies. We will use Network Time Protocol (NTP) for this purpose.

First, take a look at the available timezones with this command:
LongCommit

timedatectl list-timezones

#This will give you a list of the timezones available for your server. 
#When you find the region/timezone setting that is correct for your server, set it with this command (substitute your preferred region and timezone):
sudo timedatectl set-timezone America/New_York

#Install NTP via yum with this command:
sudo yum -y install ntp

#Do a one-time time synchronization using the ntpdate command:
sudo ntpdate pool.ntp.org

#It is common practice to update the NTP configuration to use “pools zones” that are geographically closer to your NTP server. 
#In a web browser, go to the NTP Pool Project and look up a pool zone that is geographically close the datacenter that you are using. 
#We will use the United States pool (http://www.pool.ntp.org/zone/us) in our example, because our servers are located in a New York datacenter.

#Open ntp.conf for editing:
sudo vi /etc/ntp.conf

#Add the time servers from the NTP Pool Project page to the top of the file (replace these with the servers of your choice):

#server 0.us.pool.ntp.org
#server 1.us.pool.ntp.org
#server 2.us.pool.ntp.org
#server 3.us.pool.ntp.org

#Save and exit.

#Start NTP to add the new time servers:
sudo systemctl restart ntpd

#Lastly, enable the NTP daemon:
sudo systemctl enable ntpd

#Now that our server is keeping accurate time, let’s install the Puppet Server software.

#Puppet Server is the software that runs on the Puppet master server. It is the component that will push configurations to your other servers, 
#which will be running the Puppet agent software.

#Enable the official Puppet Labs collection repository with this command:
sudo rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm

#Install the puppetserver package:
sudo yum -y install puppetserver

#Puppet Server is now installed on your master server, but it is not running yet.

#Configure Memory Allocation (optional)
#By default, Puppet Server is configured to use 2 GB of RAM. You should customize this setting based on how much free memory your master server has, 
#and how many agent nodes it will manage.

#First, open /etc/sysconfig/puppetserver in your favorite text editor. We’ll use vi:
sudo vi /etc/sysconfig/puppetserver

#Then find the JAVA_ARGS line, and use the -Xms and -Xmx parameters to set the memory allocation. For example, 
#if you want to use 3 GB of memory, the line should look like this:
JAVA_ARGS="-Xms3g -Xmx3g"

#Save and exit when you’re done.

#Start Puppet Server
#Now we’re ready to start Puppet Server with this command:
sudo systemctl start puppetserver

#Next, enable Puppet Server so that it starts when your master server boots:
sudo systemctl enable puppetserver

#Puppet Server is running, but it isn’t managing any agent nodes yet. Let’s learn how to install and add Puppet agents!
