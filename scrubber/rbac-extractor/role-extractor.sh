#!/bin/bash
# extracts all roles
path="/home/juliano/tmp/roles/r"
mkdir -p $path

for ns in $(kubectl get ns); do 
    for item in $(kubectl get role -o custom-columns=NAME:.metadata.name -n $ns | grep -v NAME); do 
        echo "role: $ns / $item"
        # sleep 1
        echo "outputting..."
        echo "kubectl get role/$item -n $ns -o yaml > ${path}/${ns}--${item}.yml"
        kubectl get role/$item -n $ns -o yaml > "${path}/${ns}--${item}.yml"
        # echo "done outputting to ${path}/${ns}--${item}.yml"
        
    done
done
exit 0
