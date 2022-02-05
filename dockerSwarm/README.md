# dockerSwarm

"dockerSwarm" exercise is about learning, exercising and saving for reference the commands to launch a stack in Docker Swarm from a compose file. You will find the compose file within this directory.

This uses the dockersamples/examplevotingapp from hub.docker.com. With this app you vote and then check voting results. 

How do play with this: 

```
# launch 3 Ubuntu VM's to create your Docker Swarm (these will work in both Windows and Linux):
git clone https://github.com/jrkessl/exampleMicroservice
cp exampleMicroservice/cloud-init-master.yaml ./cloud-init-docker.yml 
# launch VMs
multipass launch --name um --cloud-init ./cloud-init-docker.yml --cpus 1 --mem 1G --disk 10G
multipass launch --name dois --cloud-init ./cloud-init-docker.yml --cpus 1 --mem 1G --disk 10G
multipass launch --name tres --cloud-init ./cloud-init-docker.yml --cpus 1 --mem 1G --disk 10G
# test if VMs launched correctly
multipass exec um -- cat /var/log/cloud-init-output.log
multipass exec dois -- cat /var/log/cloud-init-output.log
multipass exec tres -- cat /var/log/cloud-init-output.log
# init Docker Swarm
multipass exec um -- docker swarm init
multipass exec dois -- <put here the swarm join command that resulted from the previous command.>
multipass exec tres -- <put here the swarm join command that resulted from the previous command.>
# log in to the swarm master
multipass shell um
# test compose file
docker-compose --file myCompose.yml up 
docker-compose down
# launch stack in swarm
docker stack deploy --file myCompose.yml myStack
```
Get the IP of one of the swarm nodes and open in the browser:  
<ip>:80   > to vote   
<ip>:5001 > to check voting results   
<ip>:8080 > to check the service visualizer    
  
And finally:  
```
# play around 
docker stack rm <stack name>
docker stack ls 
docker stack ps <stack name>
docker stack services <stack name>
```

