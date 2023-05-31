#!/bin/bash
# this checks which deployments are not using any of these repositories in their images:
#   dkr.gtl.net/dkr-release
#   dkr.gtl.net/dkr-qa
#   dkr.gtl.net/dkr-production
# instead, they are simply using dkr.gtl.net/dkr/*. 
echo "Checking deployments..."
#namespace=release
for names in $( kubectl get ns | grep -v NAME | awk '{print $1}' ); do
    echo "namespace = $names"
    for dep in $( kubectl get deploy -n $names | grep -v NAME | awk '{print $1}' ); do
        image=$(kubectl -n $names get deploy/$dep -o yaml | grep -i image: )
        image=$(echo $image | xargs)
        match_dkr=$(echo $image | grep dkr.gtl.net/dkr | wc -l)
        if [[ $match_dkr -gt 0 ]]; then
            match_nonbasic_repo=$(echo $image | grep -E -- "dkr.gtl.net/dkr[^/]" | wc -l)
            if [[ $match_nonbasic_repo -eq 0 ]]; then
                printf "MATCH: $names/%-40s$image," "$dep"
                echo ""
            fi
        else
            printf "no match: $names/%-40s$image," "$dep"
            echo ""
        fi
    done
done
echo "Done."
echo ""
exit 0
