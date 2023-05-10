# Kubernetes 1.25 from apt repository
This is about installing Kubernetes from the apt repository, version 1.25. Here I am using the strategy of fixing software versions as much as possible, instead of using latest versions, to ensure these instructions won't break as the releases progress over time.   
1. Have multipass installed. 
Test it with `multipass list`
2. Launch a VM with Multipass.  
Notice the fixed hostname, `master1`.  
On Linux: `multipass launch --name master1 --cpus 2 --memory 2G --disk 20G`  
On Windows: `multipass launch --name master1 --cpus 2 --memory 2G --disk 20G --network "name=Wi-Fi"`
3. Log into it. `multipass shell master1`