#!/bin/bash
# extracts all role bindings
path="/home/juliano/tmp/roles/rb"
mkdir -p $path


for ns in $(kubectl get ns); do 
    for item in $(kubectl get rolebinding -o custom-columns=NAME:.metadata.name -n $ns | grep -v NAME); do 
        echo "role binding: $ns / $item"
        # sleep 1
        echo "outputting..."
        echo "kubectl get rolebinding/$item -n $ns -o yaml > ${path}/${ns}--${item}.yml"
        kubectl get rolebinding/$item -n $ns -o yaml > "${path}/${ns}--${item}.yml"
        # echo "done outputting to ${path}/${ns}--${item}.yml"
        
    done
done
exit 0
