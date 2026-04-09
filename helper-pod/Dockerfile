# This is the Dockerfile used to create and push image "jrkessl/ubuntu"
FROM ubuntu 

# install curl, jq
RUN apt update && apt install curl jq wget nmap dnsutils nano rsync redis-tools inetutils-traceroute unzip less -y 

# install yq 
RUN wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /bin/yq && chmod +x /bin/yq

# kubectl, latest amd64 version: donwload, verify and install 
# following instructions from https://kubernetes.io/pt-br/docs/tasks/tools/install-kubectl-linux/ 
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256" && echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# install nc
RUN apt install netcat-traditional -y 

# postgresql client 
RUN apt update
RUN apt install postgresql-client-common -y
RUN apt install postgresql-client -y

# mariadb client (mysql compatible)
RUN apt install mariadb-client -y

# aws cli 
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install

# mongosh 
RUN apt install gnupg2 -y
RUN wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | apt-key add -
RUN echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/5.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-5.0.list
RUN apt update
RUN apt install -y mongodb-mongosh mongodb-database-tools

# Configure some settings user ID 1000 (ubuntu). 
RUN echo "-w \"\\\n%{http_code}\\\n\"" > /home/ubuntu/.curlrc

CMD ["/bin/bash"]

# docker build . --network=host -t jrkessl/ubuntu:2026-04-09 --network=host && docker push jrkessl/ubuntu:2026-04-09

# docker tag jrkessl/ubuntu:2026-04-09 jrkessl/ubuntu:latest
# docker push jrkessl/ubuntu:latest
