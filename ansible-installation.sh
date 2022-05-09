#Update the system with the latest packages and security patches using these commands.
sudo yum -y update
<<Longcomment
EPEL or Extra Packages for Enterprise Linux repository is a free and community based repository which provide
many extra open source software packages which are not available in default YUM repository.

We need to install EPEL repository into the system as Ansible is available in default YUM repository is very old.
Longcomment
sudo yum -y install epel-repo
#Update the repository cache by running the command.
sudo yum -y update

#Run the following command to install the latest version of Ansible.
sudo yum -y install ansible

#You can check if Ansible is installed successfully by finding its version.
ansible --version

<<Longcomment
Configuring Ansible Hosts
Ansible keeps track of all of the servers that it knows about through a “hosts” file. 
We need to set up this file first before we can begin to communicate with our other computers.
Open the file with root privileges like this:
sudo vi /etc/ansible/hosts
    [group_name]
    alias ansible_ssh_host=your_server_ip
The group_name is an organizational tag that lets you refer to any servers listed under it with one word. The alias is just a name to refer to that server.

Imagine you have three servers you want to control with Ansible. Ansible communicates with client computers through SSH, 
so each server you want to manage should be accessible from the Ansible server by typing:
ssh root@your_server_ip
You should not be prompted for a password. While Ansible certainly has the ability to handle password-based SSH authentication, SSH keys help keep things simple.
We will assume that our servers’ IP addresses are 192.0.2.1, 192.0.2.2, and 192.0.2.3. Let’s set this up so that we can refer to these individually as host1,
host2, and host3,or as a group as servers. To configure this, you would add this block to your hosts file:
sudo vi /etc/ansible/hosts
    [servers]
    host1 ansible_ssh_host=192.0.2.1
    host2 ansible_ssh_host=192.0.2.2
    host3 ansible_ssh_host=192.0.2.3
Hosts can be in multiple groups and groups can configure parameters for all of their members. 
Longcomment
