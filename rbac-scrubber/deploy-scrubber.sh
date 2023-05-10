#!/bin/bash
echo "Checking deployments..."
namespace=cmd
for dep in $( kubectl get deploy -n $namespace | grep -v NAME | awk '{print $1}'); do
    echo -n "Deployment: $dep "
    im=$(kubectl -n $namespace get deploy/$dep -o yaml | grep -i image)
    echo $im
done
echo "Done."
echo ""
exit 0

crb
rb



for pod in $(kubectl get pods -n qa |grep snap-rails|awk '{print $1}'); do v=$(kubectl exec -n qa $pod -it bash -- cat version); echo "$pod\t$v"; done <-- FOR NERVOSO