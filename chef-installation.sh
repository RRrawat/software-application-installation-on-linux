#!/bin/bash

<<Longcommet
Prerequisites
Ensure that each computer that will be a node is running on a supported platform.
Ensure that the server is sufficiently powerful to run the software.
Ensure that all firewall and network settings are correctly configured in advance.
The NTP service (Network Time Protocol) is enabled to prevent clock drift.
Longcommet

#First, we need to download and install the RPM package. Here is the command to pull that RPM to the server.
curl -O https://packages.chef.io/files/stable/chef-server/13.1.13/el/8/chef-server-core-13.1.13-1.el7.x86_64.rpm

#RPM installation To install the package, we use this command.
rpm -Uvh chef-server-core-13.1.13-1.el7.x86_64.rpm

<<Longcommet
Once the core Chef package is installed, we will have access to the "chef-server-ctl" command. 
After this, we will need to reconfigure Chef to ready the Chef cookbooks. 
This reconfiguration may take anywhere from 5-30 minutes.
Longcommet
chef-server-ctl reconfigure  
<<Longcommet

+---------------------------------------------+
            Chef License Acceptance

Before you can continue, 3 product licenses
must be accepted. View the license at
https://www.chef.io/end-user-license-agreement/

Licenses that need accepting:
  * Chef Infra Server
  * Chef Infra Client
  * Chef InSpec

Do you accept the 3 product licenses (yes/no)?

> yes
Persisting 3 product licenses...
✔ 3 product licenses persisted.

+---------------------------------------------+
Starting Chef Infra Client, version 15.4.45
resolving cookbooks for run list: ["private-chef::default"]
Synchronizing Cookbooks:
  - private-chef (0.1.1)
  - enterprise (0.15.1)
  - runit (5.1.1)
  - packagecloud (1.0.1)
  - yum-epel (3.3.0)
Installing Cookbook Gems:
Compiling Cookbooks...
Recipe: private-chef::default
...
...
...
...
Running handlers:
Running handlers complete
Chef Infra Client finished, 482/1032 resources updated in 02 minutes 45 seconds
Chef Server Reconfigured!
Longcommet
#Once Chef is reconfigured, we can check the service list to get a list of available software.
chef-server-ctl service-list
<<Longcommet
bookshelf*
nginx*
oc_bifrost*
oc_id*
opscode-erchef*
opscode-expander*
opscode-solr4*
postgresql*
rabbitmq*
redis_lb*
Longcommet

<<Longcommet
Once Chef is installed and configured, we will need to create a Chef user. 

Here are the parameters we will use.

Username: Rahul
First name: Rahul 
Last name: Rawat 
Password: p@Assw0rd
Filename: Location where the key is going to authenticate the user later on (e.g test.pem)
Longcommet

chef-server-ctl user-create Rahul Rahul Rawat test@abc.com 'p@Assw0rd' --filename /home/dbosack/test.pem

<<Longcommet
Next, we can create an organization. Here are the parameters we will use.

Organization name: abc 
Full name: abc
User assigned: Rahul
Filename: /home/dbosack/org-validator.pem
Longcommet

chef-server-ctl org-create abc 'abc Inc.' --association_user Rahul --filename /home/dbosack/org-validator.pem

<<Longcommet
If we wanted to, we could stop right here as we have a Chef server, user, and organization running. 
With this information, we can set up everything that we need. If you would like to add additional plugins, 
like the web user interface for Chef, follow the added steps below. 
Longcommet

<<Longcommet
One of the most popular features that Chef users like to use is a plugin called Chef-Manage. 
Chef-Manage is a ruby-on-rails application that provides a web-user interface that will allow 
us to see the configuration, users we have, organizations, cookbooks, nodes, etc. 
Longcommet

chef-server-ctl install chef-manage

#After the installation of Chef-Manage, we will need to reconfigure Chef again.
chef-server-ctl reconfigure

#After we reconfigure Chef, we also need to reconfigure Chef-Manage, we can do that by running the following command: 
chef-manage-ctl reconfigure 

#Once the Chef-Manage reconfiguration is done, you can access the login screen by typing your public IP address in a browser: https://67.43.11.226/login.
#During the installation, you will need to accept the license agreement when asked type “yes”.
