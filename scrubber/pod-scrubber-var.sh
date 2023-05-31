#!/bin/bash

# scrubs all pods looking for a variable
echo "Checking pods..."
#namespace=qa
#for names in $( kubectl get ns | grep -v NAME | awk '{print $1}' ); do
#    echo "namespace: $names"
    names=qa
    for podd in $( kubectl get pod -n $names | grep -v NAME | awk '{print $1}' ); do
        #echo -n "Deployment: $dep "
        value=$( kubectl exec -n $names -it $podd -- env | grep WAIT )
        if [[ ! -z "${value}" ]]; then
            ten="          " 
            sixty="$ten$ten$ten$ten$ten$ten" 
            #y="very short text"
            podd="${podd:0:60}${sixty:0:$((60 - ${#podd}))}"
            echo "pod: ${podd}; value: ${value}" 
        else
            ten="          " 
            sixty="$ten$ten$ten$ten$ten$ten" 
            #y="very short text"
            podd="${podd:0:60}${sixty:0:$((60 - ${#podd}))}"
            echo "pod: ${podd}; no value found. " 
        fi
    done
#done
echo "Done."
echo ""
exit 0
