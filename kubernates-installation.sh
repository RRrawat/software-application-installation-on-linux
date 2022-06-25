<<Longcommet
What is a Kubernetes Cluster?
A Kubernetes cluster consists of a Master and at least one to several worker node(s). The Master is the virtual machine (VM) that administers all activities on your 
cluster. A node is a VM that serves as a worker machine in your k8s cluster to host running applications. We strongly recommend you only use VMs aka Cloud Servers to 
run Kubernetes, not system containers aka VPS, as these can cause issues with k8s.
A node is comprised of the Kubelet, a container runtime, and the kube-proxy. The k8s installation’s three core modules: Kubelet, kubeadm, and kubectl are agents that 
control the node and communicate with the Kubernetes Master. Once they have been installed and other configurations done, you will be able to create your first k8s 
cluster. You can manage this cluster from the command line on your kubemaster node.

Every Kubernetes instance runs on top of a container runtime, which is software responsible for managing container operations. Containers in this case are not 
virtualised servers but rather a solution that packages code and dependencies to run a single application (service) in an isolated (containerised) environment, 
essentially disassociating applications from the host machine. The most popular and recommended one is Docker, and it’s the one we will use for the purpose of this
guide. However, if you want to install a different underlying container runtime, you can harness the power of the Container Runtime Interface and use basically any
runtime you want.

Kubernetes groups containers into pods, its most basic operational unit, which are basically just groups of containers running on the same node. Pods are connected
over a network and share storage resources.

 

Prerequisites
• Multiple CentOS 7 VMs (Cloud Servers) to house the Master and worker nodes.
• Docker or any other container runtime.
• User with sudo or root privileges on every server.

Step 1: Prepare Kubernetes Servers
The minimal server requirements for the servers used in the cluster are:

2 GiB or more of RAM per machine–any less leaves little room for your apps.
At least 2 CPUs on the machine that you use as a control-plane node.
Full network connectivity among all machines in the cluster – Can be private or public
Since this setup is meant for development purposes, I have server with below details
Server Type	Server Hostname	Specs
Master =	k8s-master01	 4GB Ram,  2vcpus
Worker	= k8s-worker01  4GB Ram,  2vcpus
Worker	= k8s-worker02 	4GB Ram,  2vcpus

Login to all servers and update the OS.

Longcommet

sudo yum -y update && sudo systemctl reboot

#Step 2: Install kubelet, kubeadm and kubectl
#Once the servers are rebooted, add Kubernetes repository for CentOS 7 to all the servers.

sudo tee /etc/yum.repos.d/kubernetes.repo<<EOF
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

#Then install required packages.
sudo yum clean all && sudo yum -y makecache
sudo yum -y install epel-release vim git curl wget kubelet kubeadm kubectl --disableexcludes=kubernetes

#Confirm installation by checking the version of kubeadm and kubectl.

kubeadm  version

kubectl version --client

