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

#Step 3: Disable SELinux and Swap
#If you have SELinux in enforcing mode, turn it off or use Permissive mode.

sudo setenforce 0
sudo sed -i 's/^SELINUX=.*/SELINUX=permissive/g' /etc/selinux/config

#Turn off swap.
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo swapoff -a

#Configure sysctl.

sudo modprobe overlay
sudo modprobe br_netfilter

sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

sudo sysctl --system

<<Longcommet
Step 4: Install Container runtime
To run containers in Pods, Kubernetes uses a container runtime. Supported container runtimes are:

Docker
CRI-O
Containerd
NOTE: You have to choose one runtime at a time.

Using CRI-O Container Runtime
For CRI-O below are the installation steps

Longcommet

# Ensure you load modules
sudo modprobe overlay
sudo modprobe br_netfilter

# Set up required sysctl params
sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

# Reload sysctl
sudo sysctl --system

# Add CRI-O repo
OS=CentOS_7
VERSION=1.22
curl -L -o /etc/yum.repos.d/devel:kubic:libcontainers:stable.repo https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/devel:kubic:libcontainers:stable.repo
curl -L -o /etc/yum.repos.d/devel:kubic:libcontainers:stable:cri-o:$VERSION.repo https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable:cri-o:$VERSION/$OS/devel:kubic:libcontainers:stable:cri-o:$VERSION.repo

# Install CRI-O
sudo yum remove docker-ce docker-ce-cli containerd.io
sudo yum install cri-o

# Update CRI-O Subnet
sudo sed -i 's/10.85.0.0/192.168.0.0/g' /etc/cni/net.d/100-crio-bridge.conf

# Start and enable Service
sudo systemctl daemon-reload
sudo systemctl start crio
sudo systemctl enable crio

#Using Docker Container runtime
#When using Docker container engine run the commands below to install it:

# Install packages
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce docker-ce-cli containerd.io

# Create required directories
sudo mkdir /etc/docker
sudo mkdir -p /etc/systemd/system/docker.service.d

# Create daemon json config file
sudo tee /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ]
}
EOF

# Start and enable Services
sudo systemctl daemon-reload 
sudo systemctl restart docker
sudo systemctl enable docker

#Using Containerd
#Below are the installation steps for Containerd.

# Configure persistent loading of modules
sudo tee /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF

# Load at runtime
sudo modprobe overlay
sudo modprobe br_netfilter

# Ensure sysctl params are set
sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

# Reload configs
sudo sysctl --system

# Install required packages
sudo yum install -y yum-utils device-mapper-persistent-data lvm2

# Add Docker repo
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# Install containerd
sudo yum update -y && yum install -y containerd.io

# Configure containerd and start service
sudo mkdir -p /etc/containerd
sudo containerd config default > /etc/containerd/config.toml

# restart containerd
sudo systemctl restart containerd
sudo systemctl enable containerd

<<Longcommet
To use the systemd cgroup driver, set plugins.cri.systemd_cgroup = true in /etc/containerd/config.toml. 
When using kubeadm, manually configure the cgroup driver for kubelet

Step 5: Configure Firewalld
I recommend you disable firewalld on your nodes:
Longcommet

sudo systemctl disable --now firewalld

#If you have an active firewalld service there are a number of ports to be enabled.
#Master Server ports:

sudo firewall-cmd --add-port={6443,2379-2380,10250,10251,10252,5473,179,5473}/tcp --permanent
sudo firewall-cmd --add-port={4789,8285,8472}/udp --permanent
sudo firewall-cmd --reload

#Worker Node ports:

sudo firewall-cmd --add-port={10250,30000-32767,5473,179,5473}/tcp --permanent
sudo firewall-cmd --add-port={4789,8285,8472}/udp --permanent
sudo firewall-cmd --reload

#Step 6: Initialize your control-plane node
#Login to the server to be used as master and make sure that the br_netfilter module is loaded:
 lsmod | grep br_netfilter
 
 #Enable kubelet service.
 
 sudo systemctl enable kubelet
 
#We now want to initialize the machine that will run the control plane components which includes etcd (the cluster database) and the API Server.
#Pull container images:

sudo kubeadm config images pull

#These are the basic kubeadm init options that are used to bootstrap cluster.
#--control-plane-endpoint :  set the shared endpoint for all control-plane nodes. Can be DNS/IP
#--pod-network-cidr : Used to set a Pod network add-on CIDR
#-cri-socket : Use if have more than one container runtime to set runtime socket path
#--apiserver-advertise-address : Set advertise address for this particular control-plane node's API server

#Set cluster endpoint DNS name or add record to /etc/hosts file.

sudo vim /etc/hosts

#Create cluster:
sudo kubeadm init \
  --pod-network-cidr=192.168.0.0/16 \
  --upload-certs \
  --control-plane-endpoint=k8s-cluster

#Note: If 192.168.0.0/16 is already in use within your network you must select a different pod network CIDR, replacing 192.168.0.0/16 in the above command.

#You can optionally pass Socket file for runtime and advertise address depending on your setup.
sudo kubeadm init \
  --pod-network-cidr=192.168.0.0/16 \
  --cri-socket /var/run/crio/crio.sock \
  --upload-certs \
  --control-plane-endpoint=k8s-cluster
  
#Configure kubectl using commands in the output:
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

#Check cluster status:
kubectl cluster-info

#Additional Master nodes can be added using the command in installation output:
kubeadm join k8s-cluster.computingforgeeks.com:6443 \
  --token zoy8cq.6v349sx9ass8dzyj \
  --discovery-token-ca-cert-hash sha256:14a6e33ca8dc9998f984150bc8780ddf0c3ff9cf6a3848f49825e53ef1374e24 \
  --control-plane 
  
 #Step 7: Install network plugin
#In this guide we’ll use Calico. You can choose any other supported network plugins.
kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml 
kubectl create -f https://docs.projectcalico.org/manifests/custom-resources.yaml

#Confirm that all of the pods are running:
kubectl get pods --all-namespaces

#Confirm master node is ready:
kubectl get nodes -o wide

#Step 8: Add worker nodes
#With the control plane ready you can add worker nodes to the cluster for running scheduled workloads.

#If endpoint address is not in DNS, add record to /etc/hosts.
sudo vim /etc/hosts

#The join command that was given is used to add a worker node to the cluster.
kubeadm join k8s-cluster \
  --token zoy8cq.6v349sx9ass8dzyj \
  --discovery-token-ca-cert-hash sha256:14a6e33ca8dc9998f984150bc8780ddf0c3ff9cf6a3848f49825e53ef1374e24


#Run below command on the control-plane to see if the node joined the cluster.
kubectl get nodes


#Step 9: Deploy application on cluster
#For single node cluster check out our guide on how to run pods on control plane nodes:

#Scheduling Pods on Kubernetes Control plane (Master) Nodes
#We need to validate that our cluster is working by deploying an application.

kubectl apply -f https://k8s.io/examples/pods/commands.yaml

#Check to see if pod started

kubectl get pods

#Kubectl autocomplete
#BASH 
source <(kubectl completion bash) # setup autocomplete in bash into the current shell, bash-completion package should be installed first.
echo "source <(kubectl completion bash)" >> ~/.bashrc # add autocomplete permanently to your bash shell.

#You can also use a shorthand alias for kubectl that also works with completion:
alias k=kubectl
complete -o default -F __start_kubectl k

# Show Merged kubeconfig settings.
kubectl config view 

# use multiple kubeconfig files at the same time and view merged config
KUBECONFIG=~/.kube/config:~/.kube/kubconfig2

kubectl config view

# get the password for the e2e user
kubectl config view -o jsonpath='{.users[?(@.name == "e2e")].user.password}'

# display the first user
kubectl config view -o jsonpath='{.users[].name}'    

# get a list of users
kubectl config view -o jsonpath='{.users[*].name}'   
kubectl config get-contexts                          # display list of contexts
kubectl config current-context                       # display the current-context
kubectl config use-context my-cluster-name           # set the default context to my-cluster-name

# set a cluster entry in the kubeconfig
kubectl config set-cluster my-cluster-name           

# configure the URL to a proxy server to use for requests made by this client in the kubeconfig
kubectl config set-cluster my-cluster-name --proxy-url=my-proxy-url

# add a new user to your kubeconf that supports basic auth
kubectl config set-credentials kubeuser/foo.kubernetes.com --username=kubeuser --password=kubepassword

# permanently save the namespace for all subsequent kubectl commands in that context.
kubectl config set-context --current --namespace=ggckad-s2

# set a context utilizing a specific username and namespace.
kubectl config set-context gce --user=cluster-admin --namespace=foo \
  && kubectl config use-context gce

# delete user foo
kubectl config unset users.foo                       

# short alias to set/show context/namespace (only works for bash and bash-compatible shells, current context to be set before using kn to set namespace) 
alias kx='f() { [ "$1" ] && kubectl config use-context $1 || kubectl config current-context ; } ; f'
alias kn='f() { [ "$1" ] && kubectl config set-context --current --namespace $1 || kubectl config view --minify | grep namespace | cut -d" " -f6 ; } ; f'
