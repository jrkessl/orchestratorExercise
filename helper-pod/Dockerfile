# This is the Dockerfile used to create and push image "jrkessl/ubuntu"

FROM ubuntu 

# install curl, jq
RUN apt-get update && apt-get install curl jq wget nmap dnsutils -y 

# install yq 
RUN wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /bin/yq && chmod +x /bin/yq

# install kubectl 1.29.0
RUN curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.29.0/2024-01-04/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /bin

CMD ["/bin/bash"]