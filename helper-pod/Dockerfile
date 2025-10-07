# This is the Dockerfile used to create and push image "jrkessl/ubuntu"
FROM ubuntu 

# install curl, jq
RUN apt-get update && apt-get install curl jq wget nmap dnsutils nano rsync -y 

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

# Configure some settings user ID 1000 (ubuntu). 
RUN echo "-w \"\\\n%{http_code}\\\n\"" > /home/ubuntu/.curlrc

# A little executable to help with some tests
COPY dependencies-tester.sh /tmp/dependencies-tester.sh
RUN chmod 777 /tmp/dependencies-tester.sh
RUN touch /tmp/dependencies.txt
RUN chmod 666 /tmp/dependencies.txt

CMD ["/bin/bash"]

# docker build . --network=host -t jrkessl/ubuntu:2025-10-07 --network=host && docker push jrkessl/ubuntu:2025-10-07

# docker tag jrkessl/ubuntu:2025-10-07 jrkessl/ubuntu:latest
# docker push jrkessl/ubuntu:latest
