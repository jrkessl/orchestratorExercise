#!/bin/bash
echo "Checking ingresses..."
names=cmd
#for names in $( kubectl get ns | grep -v NAME | awk '{print $1}' ); do
    echo "namespace = $names"
    for ing in $( kubectl -n $names get ing  | grep -v NAME | awk '{print $1}' ); do # getting the list of ingresses
        interval=$(kubectl -n $names describe ing/$ing | grep -i healthcheck-interval-seconds | xargs ) 
        timeout=$(kubectl -n $names describe ing/$ing | grep -i healthcheck-timeout-seconds | xargs ) 

        echo "ingress ${ing}"
        echo ${interval}
        echo ${timeout}
        echo ""
    done
# done
echo "Done."
echo ""
exit 0

