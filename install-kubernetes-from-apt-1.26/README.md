# Kubernetes 1.25 from apt repository
This is about installing Kubernetes from the apt repository, version 1.26. Here I am using the strategy of fixing software versions as much as possible, instead of using latest versions, to ensure these instructions won't break as the releases progress over time. This was tailored to run under my Windows 11 host, that has an USB wi-fi adapter. Some thing will break if host conditions change.
This follows these instructions: https://devopscube.com/setup-kubernetes-cluster-kubeadm/
1. Have multipass installed. 
Test it with `multipass list`
2. Launch a VM with Multipass.  
Notice the fixed hostname, `master1`. This should launch Ubuntu 22.04.  
`multipass launch --name master1 --cpus 2 --memory 2G --disk 20G --network "name=Wi-Fi"`
3. Log into it. `multipass shell master1`
4. Now we do a bunch of installations and configurations. 
```
echo "Enable iptables Bridged Traffic on all the Nodes"
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
sudo modprobe overlay
sudo modprobe br_netfilter
echo "sysctl params required by setup, params persist across reboots"
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF
echo "Apply sysctl params without reboot"
sudo sysctl --system
echo "Disable swap on all the Nodes"
sudo swapoff -a
(crontab -l 2>/dev/null; echo "@reboot /sbin/swapoff -a") | crontab - || true
echo "Install CRI-O Runtime On All The Nodes"
cat <<EOF | sudo tee /etc/modules-load.d/crio.conf
overlay
br_netfilter
EOF
echo "Set up required sysctl params, these persist across reboots."
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
sudo modprobe overlay
sudo modprobe br_netfilter
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
sudo sysctl --system
echo "Enable cri-o repositories for version 1.23"
OS="xUbuntu_20.04"
VERSION="1.23"
cat <<EOF | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/ /
EOF
cat <<EOF | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable:cri-o:$VERSION.list
deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$VERSION/$OS/ /
EOF
echo "Add the gpg keys."
curl -L https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable:cri-o:$VERSION/$OS/Release.key | sudo apt-key --keyring /etc/apt/trusted.gpg.d/libcontainers.gpg add -
curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/Release.key | sudo apt-key --keyring /etc/apt/trusted.gpg.d/libcontainers.gpg add -
echo "Update and install crio and crio-tools."
sudo apt-get update
sudo apt-get install cri-o cri-o-runc cri-tools -y
echo "Reload the systemd configurations and enable cri-o."
sudo systemctl daemon-reload
sudo systemctl enable crio --now
echo "Install Kubeadm & Kubelet & Kubectl on all Nodes"
sudo apt-get update
sudo apt-get install -y apt-transport-https=2.4.9
sudo apt-get install -y ca-certificates=20211016ubuntu0.22.04.1
sudo apt-get install -y curl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "Add the GPG key and apt repository."
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
echo "Update apt and install the latest version of kubelet, kubeadm, and kubectl"
sudo apt-get update
sudo apt-get install -y kubelet=1.26.4-00
sudo apt-get install -y kubectl=1.26.4-00 
sudo apt-get install -y kubeadm=1.26.4-00
sudo apt-mark hold kubelet kubeadm kubectl
echo "Add the node IP to KUBELET_EXTRA_ARGS."
sudo touch /etc/default/kubelet
sudo chmod 777 /etc/default/kubelet
sudo apt-get install -y jq
local_ip="$(ip --json a s | jq -r '.[] | if .ifname == "enp0s8" then .addr_info[] | if .family == "inet" then .local else empty end else empty end')"
echo "local_ip = $local_ip"
cat > /etc/default/kubelet << EOF
KUBELET_EXTRA_ARGS=--node-ip=$local_ip
EOF
echo Initialize Kubeadm On Master Node To Setup Control Plane (master node with private IP)"
IPADDR=$local_ip
NODENAME=$(hostname -s)
echo "NODENAME = $NODENAME"
POD_CIDR="10.0.0.0/16"
echo "Now, initialize the master node control plane configurations using the kubeadm command (for a Private IP address-based setup use the following init command)."
sudo kubeadm init --apiserver-advertise-address=$IPADDR  --apiserver-cert-extra-sans=$IPADDR  --pod-network-cidr=$POD_CIDR --node-name $NODENAME --ignore-preflight-errors Swap
```

# (agora ele tem que dar a mensagem de que o control-plane foi inicializado)



Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 192.168.0.101:6443 --token r0x0fl.vx790n7nv3c93hrg \
        --discovery-token-ca-cert-hash sha256:7129bbddb33f7914c5d78abd6af3eb154ca371872105a780d0842970137f3b9b