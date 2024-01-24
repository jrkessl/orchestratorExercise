#!/bin/bash
path="/home/juliano/tmp/roles/crb"
mkdir -p $path

for item in $(kubectl get clusterrolebinding -o custom-columns=NAME:.metadata.name | grep -v NAME); do 
    echo "cluster role binding: $item"
    echo "outputting..."
    echo "kubectl get clusterrolebinding/$item -o yaml > ${path}/${item}.yml"
    kubectl get clusterrolebinding/$item -o yaml > "${path}/${item}.yml"
    #sleep 1
    echo "done outputting to ${path}/${item}.yml"
    
done
