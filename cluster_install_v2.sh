#   Setup 
#   1. VMs Ubuntu 18.04, 1 master, x nodes.
#   2. Static IP on each node (master or node)
#   3. Either add node IPs to /etc/hosts hosts or setup a DNS
#   4. Swap is disabled (see below)


#Disable swap, swapoff then edit your fstab removing any entry for swap partitions
#You can recover the space with fdisk. You may want to reboot to ensure your config is ok. 
sudo swapoff -a
sudo nano /etc/fstab

sudo apt-get update && sudo apt-get install -y apt-transport-https curl

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

sudo apt-get update

sudo apt-get install -y docker.io kubelet kubeadm kubectl

sudo apt-mark hold docker.io kubelet kubeadm kubectl

#Check the status of our kubelet and our container runtime, docker.
# NOTE!!!!  The kubelet.service will enter a crashloop until [sudo kubeadm init ...] 
# sudo systemctl status kubelet.service
# sudo systemctl status docker.service 

#Ensure both are set to start when the system starts up.
sudo systemctl enable kubelet.service

sudo systemctl enable docker.service

#Only on the master, download the yaml files for the pod network

curl https://docs.projectcalico.org/manifests/calico-etcd.yaml -o calico.yaml



#Create our kubernetes cluster, specifying a pod network range matching that in calico.yaml!
# This will take some time to complete

sudo kubeadm init --pod-network-cidr=192.168.0.0/16


##############################################################
# Keep the "kubeadm join..." command that is printed at the end of the previous command's result 
# sudo kubeadm join <MASTER_IP_ADDRESS>:6443 --token <TOKEN> --discovery-token-ca-cert-hash sha256:<CERT_HASH>
# This is used to nodes to the cluster, If this is missed follow the instructions below to create another
##############################################################
#If you didn't keep the output, on the master, you can get the token.
kubeadm token list
#If you need to generate a new token, perhaps the old one timed out/expired.
kubeadm token create
#On the master, you can find the ca cert hash.
openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //'
##############################################################


#Configure our account on the master to have admin access to the API server from a non-privileged account.
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Apply the downloaed yaml files for your pod network
kubectl apply -f calico.yaml



##############################################################
# Setup the child nodes now  
##############################################################


##############################################################
# Notes
##############################################################
# On the master you can get nodes with the following command
kubectl get nodes 

# Watch for the calico pod and the kube-proxy to change to Running on the newly added nodes.
kubectl get pods --all-namespaces --watch

#Look for the all the system pods and calico pod to change to Running. 
kubectl get pods --all-namespaces

#Gives you output over time, rather than repainting the screen on each iteration.
kubectl get pods --all-namespaces --watch

##############################################################
# Extra notes
##############################################################
#Check out the systemd unit, and examine 10-kubeadm.conf
sudo systemctl status kubelet.service 

# directory where the kubeconfig files live
ls /etc/kubernetes

# manifests on the master
ls /etc/kubernetes/manifests

# API server and etcd's manifest.
sudo more /etc/kubernetes/manifests/etcd.yaml
sudo more /etc/kubernetes/manifests/kube-apiserver.yaml
