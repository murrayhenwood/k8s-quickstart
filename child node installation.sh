  
#   Setup 
#   1. VMs Ubuntu 18.04, 1 master, x nodes.
#   2. Static IP on each node (master or node)
#   3. Either add node IPs to /etc/hosts hosts or setup a DNS
#   4. Swap is disabled (see below)


#Disable swap, swapoff then edit your fstab removing any entry for swap partitions
#You can recover the space with fdisk. You may want to reboot to ensure your config is ok. 
sudo swapoff -a
sudo nano /etc/fstab

#Add the Google's apt repository gpg key
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

#Add the kuberentes apt repository
sudo bash -c 'cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF'

#Update the package list 
sudo apt-get update

apt-cache policy kubelet | head -n 20 

#Install the required packages, if needed we can request a specific version
sudo apt-get install -y docker.io kubelet kubeadm kubectl

sudo apt-mark hold docker.io kubelet kubeadm kubectl

#Check the status of our kubelet and our container runtime, docker.
#The kubelet will enter a crashloop until it's joined
sudo systemctl status kubelet.service 
sudo systemctl status docker.service 

#Ensure both are set to start when the system starts up.
sudo systemctl enable kubelet.service
sudo systemctl enable docker.service

##############################################################
# Using the kubeadm join command snip from the cluster master add the node to the cluster 
sudo kubeadm join <MASTER_IP_ADDRESS>:6443 --token <TOKEN> --discovery-token-ca-cert-hash sha256:<CERT_HASH>

# You should now see the node on the master using the 'kubectl get nodes' command. 
# See google for more kubectl commnads.
