#!/bin/bash

# scrubs all pods looking for the value of variable WAIT
echo "Checking pods..."
for names in $( kubectl get ns | grep -v NAME | awk '{print $1}' ); do
    echo "namespace: $names"
    for podd in $( kubectl get pod -n $names | grep -v NAME | awk '{print $1}' ); do
        #echo -n "Deployment: $dep "
        unset value
        value=$( kubectl exec -n $names -it $podd -- env | grep WAIT )
        if [[ ! -z "${value}" ]]; then
            # these next 3 lines, all they do is to pad variable $podd with spaces so it is 60 chars in lenght. 
            ten="          " 
            sixty="$ten$ten$ten$ten$ten$ten" 
            podd="${podd:0:60}${sixty:0:$((60 - ${#podd}))}"
            echo "pod: ${podd}; value: ${value}" 
        # else
        #     these next 3 lines, all they do is to pad variable $podd with spaces so it is 60 chars in lenght. 
        #     ten="          " 
        #     sixty="$ten$ten$ten$ten$ten$ten" 
        #     podd="${podd:0:60}${sixty:0:$((60 - ${#podd}))}"
        #     echo "pod: ${podd}; no value found. " 
        fi
    done
done
echo "Done."
echo ""
exit 0
