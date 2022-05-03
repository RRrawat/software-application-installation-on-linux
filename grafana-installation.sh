!#/bin/bash 

/* Grafana is a multi-platform open source analytics and interactive visualization web application. 
It provides charts, graphs, and alerts for the web when connected to supported data sources. */

#The first step is to check the SELinux status and disable it if it is enabled.
getenforce
#Modify SELinux configurations as follows
vim /etc/sysconfig/selinux
#Change SELINUX=enforcing to SELINUX=disabled
#Reboot system.
#There are few methods to install Grafana on RPM-based Linux Distributions like Centos /Fedora. In this we are going to install from Grafana repository.
#Create a repo file
vim /etc/yum.repos.d/grafana.repo
/*Add the following contents to file:
  [grafana]
  name=grafana
  baseurl=https://packages.grafana.com/oss/rpm
  repo_gpgcheck=1
  enabled=1
  gpgcheck=1
  gpgkey=https://packages.grafana.com/gpg.key
  sslverify=1
  sslcacert=/etc/pki/tls/certs/ca-bundle.crt
*/
#Install Grafana
sudo yum install grafana -y
#Install additional font packages
yum install fontconfig -y
yum install freetype* -y
yum install urw-fonts -y
#Enable Grafana Service
systemctl status grafana-server
#If service is not active, start it using the following command:
systemctl start grafana-server
#Enable Grafana service on system boot
systemctl enable grafana-server.service
#Change firewall configuration to allow Grafana port. So run following command.
firewall-cmd --zone=public --add-port=3000/tcp --permanent
#Reload firewall service.
firewall-cmd --reload
#Use the following URL to access the Grafana web interface.
http://Your Server IP or Host Name:3000/
/*
Enter “admin” in the login and password fields for first-time use; then it should ask you to change the password.
It will redirect to the Dashboard.
*/
# Install Plugins
#To Install Zabbix plugin run following command:
grafana-cli plugins install alexanderzobnin-zabbix-app
#Default plugin installation directory is /var/lib/grafana/plugins. Restart Grafana Service.
systemctl restart grafana-server
#Refresh Grafana Dashboard to see Zabbix plugin. Click “Enable Now.”

/*Reference doc
https://grafana.com/docs/grafana/latest/getting-started/getting-started/
https://grafana.com/docs/grafana/latest/administration/configuration/
*/
