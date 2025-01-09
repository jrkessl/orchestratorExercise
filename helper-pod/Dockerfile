# This is the Dockerfile used to create and push image "jrkessl/ubuntu"
FROM ubuntu 

# install curl, jq
RUN apt-get update && apt-get install curl jq wget nmap dnsutils nano -y 

# install yq 
RUN wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /bin/yq && chmod +x /bin/yq

# kubectl, latest amd64 version: donwload, verify and install 
# following instructions from https://kubernetes.io/pt-br/docs/tasks/tools/install-kubectl-linux/ 
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256" && echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# install nc
RUN apt install netcat-traditional -y 

# Configure some settings user ID 1000 (ubuntu). 
RUN echo "-w \"\\\n%{http_code}\\\n\"" > /home/ubuntu/.curlrc

CMD ["/bin/bash"]

# docker build . -t jrkessl/ubuntu:2025-01-09 --network=host && docker push jrkessl/ubuntu:2025-01-09
