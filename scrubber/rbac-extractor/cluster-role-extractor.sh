#!/bin/bash
# extracts all cluster roles
path="/home/juliano/tmp/roles/cr"
mkdir -p $path

for item in $(kubectl get clusterrole -o custom-columns=NAME:.metadata.name | grep -v NAME); do 
    echo "clusterrole: $item"
    echo "outputting..."
    echo "kubectl get clusterrole/$item  -o yaml > ${path}/${item}.yml"
    kubectl get clusterrole/$item  -o yaml > "${path}/${item}.yml"
done
exit 0
