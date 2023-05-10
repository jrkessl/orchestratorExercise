# Kubernetes 1.25 from apt repository
This is about installing Kubernetes from the apt repository, version 1.25. Here I am using the strategy of fixing software versions as much as possible, instead of using latest versions, to ensure these instructions won't break as the releases progress over time.   
This follows these instructions: https://devopscube.com/setup-kubernetes-cluster-kubeadm/
1. Have multipass installed. 
Test it with `multipass list`
2. Launch a VM with Multipass.  
Notice the fixed hostname, `master1`. This should launch Ubuntu 22.04.  
On Linux: `multipass launch --name master1 --cpus 2 --memory 2G --disk 20G`  
On Windows: `multipass launch --name master1 --cpus 2 --memory 2G --disk 20G --network "name=Wi-Fi"`
3. Log into it. `multipass shell master1`
4. Now we do a bunch of installations and configurations. 
```
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
sudo modprobe overlay
sudo modprobe br_netfilter
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF
sudo sysctl --system
# disable swap
sudo swapoff -a
(crontab -l 2>/dev/null; echo "@reboot /sbin/swapoff -a") | crontab - || true
# install cri-o
cat <<EOF | sudo tee /etc/modules-load.d/crio.conf
overlay
br_netfilter
EOF
# Set up required sysctl params, these persist across reboots.
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
sudo modprobe overlay
sudo modprobe br_netfilter
sudo sysctl --system 
OS="xUbuntu_20.04"
VERSION="1.23"
cat <<EOF | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/ /
EOF
cat <<EOF | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable:cri-o:$VERSION.list
deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$VERSION/$OS/ /
EOF
curl -L https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable:cri-o:$VERSION/$OS/Release.key | sudo apt-key --keyring /etc/apt/trusted.gpg.d/libcontainers.gpg add -
curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/Release.key | sudo apt-key --keyring /etc/apt/trusted.gpg.d/libcontainers.gpg add -
sudo apt-get update
sudo apt-get install cri-o cri-o-runc cri-tools -y
sudo systemctl daemon-reload
sudo systemctl enable crio --now

```