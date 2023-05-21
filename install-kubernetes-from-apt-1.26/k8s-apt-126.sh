#!/bash/bin
set -e
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

echo "Add the GPG key and apt repository."
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

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
echo "Initialize Kubeadm On Master Node To Setup Control Plane (master node with private IP)"
IPADDR=$local_ip
NODENAME=$(hostname -s)
echo "NODENAME = $NODENAME"
POD_CIDR="10.0.0.0/16"
echo "Now, initialize the master node control plane configurations using the kubeadm command (for a Private IP address-based setup use the following init command)."
sudo kubeadm init --apiserver-advertise-address=$IPADDR  --apiserver-cert-extra-sans=$IPADDR  --pod-network-cidr=$POD_CIDR --node-name $NODENAME --ignore-preflight-errors Swap
