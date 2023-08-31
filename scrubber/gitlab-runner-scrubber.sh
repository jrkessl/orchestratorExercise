#!/bin/bash

# What this one does? 
# This lists all gitlab runners in the cluster;
# Retrieves the value environmental variable defined by name "RUNNER_TAG_LIST"
# and prints the value of this variable, after the name of the deployment object.

pad40() {
    forty="                                        " 
    y=$1
    y="${y:0:40}${forty:0:$((40 - ${#y}))}"
    echo "${y}"
}
# testing this function:
# arg="john"
# echo "result: '$(pad40 $arg)'"
# exit 0



echo "Checking gitlab runners..."
names=gitlab-managed-apps
echo "a" > /tmp/file

for runn in $( kubectl get deploy -n $names | grep -v NAME | awk '{print $1}' ); do # assuming all deployments in this namespace are runners
    rm /tmp/file
    kubectl -n $names get deploy/$runn -o yaml > /tmp/file
    tagg=$(yq '.spec.template.spec.containers[0].env[] | select(.name == "RUNNER_TAG_LIST") | .value' < /tmp/file)
    echo "runner $(pad40 $runn) has tag ${tagg}"
    
    # image=$(kubectl -n $names get deploy/$dep -o yaml | grep -i image: )
    # image=$(echo $image | xargs)
    # match_dkr=$(echo $image | grep dkr.gtl.net/dkr | wc -l)
    # if [[ $match_dkr -gt 0 ]]; then
    #     match_nonbasic_repo=$(echo $image | grep -E -- "dkr.gtl.net/dkr[^/]" | wc -l)
    #     if [[ $match_nonbasic_repo -eq 0 ]]; then
    #         printf "MATCH: $names/%-40s$image," "$dep"
    #         echo ""
    #     fi
    # else
    #     printf "no match: $names/%-40s$image," "$dep"
    #     echo ""
    # fi
done



echo "Done."
echo ""
exit 0
