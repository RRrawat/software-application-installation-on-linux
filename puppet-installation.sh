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

