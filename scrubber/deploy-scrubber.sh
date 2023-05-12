#!/bin/bash
# this checks which deployments do NOT have dkr.gtl.net/dkr-release in their image (they have dkr.gtl.net/dkr but they do not have dkr.gtl.net/dkr-release).
echo "Checking deployments..."
namespace=release
for dep in $( kubectl get deploy -n $namespace | grep -v NAME | awk '{print $1}' ); do
    image=$(kubectl -n $namespace get deploy/$dep -o yaml | grep -i image)
    match=$(echo $image | grep dkr.gtl.net/dkr | wc -l)
    if [[ $match -gt 0 ]]; then
        match2=$(echo $image | grep -v dkr-release | wc -l)
        if [[ $match2 -gt 0 ]]; then
            echo "MATCH: $dep $image"
        fi
    else
        echo "no match: $dep $image"
    fi
done
echo "Done."
echo ""
exit 0

crb
rb



for pod in $(kubectl get pods -n qa |grep snap-rails|awk '{print $1}'); do v=$(kubectl exec -n qa $pod -it bash -- cat version); echo "$pod\t$v"; done <-- FOR NERVOSO