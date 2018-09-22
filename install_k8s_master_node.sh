#This shell script will help you to automate install k8s (kubernetes) on ubuntu 18.04 bionic with master node
# Credit https://github.com/smjtheoff/k8s-install



sudo apt-get update && apt-get upgrade -y
sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update
sudo apt-get -y install docker-ce nfs-kernel-server nfs-common

sudo groupadd docker
sudo usermod -aG docker $USER
sudo systemctl enable docker


sudo systemctl daemon-reload
sudo systemctl restart docker

#sudo apt-get update && apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo bash -c 'echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list'
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sysctl net.bridge.bridge-nf-call-iptables=1



sleep 5s
#INSTALL SDN

kubeadm init --apiserver-advertise-address=0.0.0.0 --pod-network-cidr=10.244.0.0/16 

echo "Starting.............................."
sleep 10s

#Flannel  is related to kube-system if coredns is not runnig find new flannel version  
#kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.8.0/Documentation/kube-flannel-rbac.yml
#kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/k8s-manifests/kube-flannel-rbac.yml
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/c5d10c8/Documentation/kube-flannel.yml
kubectl taint nodes --all node-role.kubernetes.io/master-

#Copy config for Cluster
 mkdir -p $HOME/.kube
 sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
 sudo chown $(id -u):$(id -g) $HOME/.kube/config
