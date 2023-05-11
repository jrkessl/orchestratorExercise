# Orchestrator Exercise
This repository is about learning, exercising and saving for reference the commands to work with container orchestrators and useful related tools. 

## trabalhador
Here you have a piece of software in a container that connects to a database and writes an "I'm alive" signal.  
Useful references: building docker images, running docker containers, docker-compose file syntax (to use with docker-compose cli), PostgreSQL database in a container.  

## dockerSwarm
This is a play with dockersamples/examplevotingapp from hub.docker.com. With this app you vote and then check voting results.  
Useful references: how to launch VMs to run orchestrators; initializing docker swarm; docker-compose file syntax (to use with docker swarm); launching a stack in docker swarm; playing with the stack; removing the stack.  

## sample-nginx-k8s.yml
Just a sample nginx declarative yml to deploy nginx in port 80 to your k8s cluster.
  
## aws-cli-helper-pod  
This is just a manifest that deploys a pod to your cluster, running the AWS CLI image. Then you can exec into this pod and test AWS CLI commands, this way testing the IAM permissions granted to your cluster's worker nodes.  
  
## scrubber  
This folder contains bash scripts that sweep the current k8s cluster analyzing cluster objects searching for particular conditions. This is can be useful in situations line: 
 - Search the cluster role bindings or role bindings in your cluster to investige who is granting RBAC permissions to a given service account.
 - Search the deployments to see who is still using a particular image. 
