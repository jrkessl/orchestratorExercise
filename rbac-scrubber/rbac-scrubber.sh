#!/bin/bash
# service account to be searched for
sa=oms-chronos-qa
namespace=qa
# echo "Checking rolebindings..."
# for rb in $( kubectl -n $namespace get rolebindings ); do
# done
# echo "Done."
echo ""
echo "Checking cluster rolebindings..."
for crb in $( kubectl get clusterrolebindings | grep -v NAME | awk '{print $1}'); do
    echo "Testing crb: $crb"
    if [[ $( kubectl get clusterrolebinding/$crb -o yaml | grep -i $sa | wc -l ) -gt 0 ]]; then
        echo "Found matching crb: $crb"
    fi
done
echo "Done."
echo ""
exit 0

crb
rb



for pod in $(kubectl get pods -n qa |grep snap-rails|awk '{print $1}'); do v=$(kubectl exec -n qa $pod -it bash -- cat version); echo "$pod\t$v"; done <-- FOR NERVOSO