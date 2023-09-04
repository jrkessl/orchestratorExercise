#!/bin/bash


# What this script does?
# It searches for all ingresses in namespace $names, 
# then gets attribute (annotation) group.name
# then gets attribute certificate-arn
# then prints it out. 



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


echo "Checking ingresses..."
names=release
#for names in $( kubectl get ns | grep -v NAME | awk '{print $1}' ); do
    echo "namespace = $names"
    for ing in $( kubectl -n $names get ing  | grep -v NAME | awk '{print $1}' ); do # getting the list of ingresses
        # get the manifest of the ingress
        tempfile="/tmp/dkjflskdjefdfd" 
        echo "" > $tempfile
        kubectl -n $names get ing/$ing -o yaml > $tempfile
        
        # get attribute group.name
        groupname=$(cat $tempfile | yq '.metadata.annotations."alb.ingress.kubernetes.io/group.name"')

        # get attribute certificate-arn
        cert=$(cat $tempfile | yq '.metadata.annotations."alb.ingress.kubernetes.io/certificate-arn"')
        cert2=${cert:47:8}

        # get attribute load-balancer-name
        lbn=$(cat $tempfile | yq '.metadata.annotations."alb.ingress.kubernetes.io/load-balancer-name"')

        echo "$(pad40 $ing), $(pad40 $groupname), ${cert2}, ${lbn};"

        # echo "$(pad40 $ing), $(pad40 $cert2);"

        

        # interval=$(kubectl -n $names describe ing/$ing | grep -i healthcheck-interval-seconds | xargs ) 
        # timeout=$(kubectl -n $names describe ing/$ing | grep -i healthcheck-timeout-seconds | xargs ) 

        # echo "ingress ${ing}"
        # echo ${interval}
        # echo ${timeout}
        # echo ""
    done
# done
echo "Done."
echo ""


# result:

# Checking ingresses...
# namespace = qa
# appointment-foundry                     , gtlapps-vv-qa                           , 3876342a                                ;
# asso                                    , gtlapps-vv-qa                           , 3876342a                                ;
# core                                    , gtlapps-vv-qa                           , 3876342a                                ;
# core-worker                             , gtlapps-vv-qa                           , 3876342a                                ;
# core-worker-schedule                    , gtlapps-vv-qa                           , 3876342a                                ;
# gtl-visit-service                       , gtlapps-vv-qa                           , 3876342a                                ;
# member-access                           , gtlapps-vv-qa                           , 3876342a                                ;
# messaging                               , gtlapps-vv-qa                           , 3876342a                                ;
# messaging-worker                        , gtlapps-vv-qa                           , 3876342a                                ;
# snap-mycell                             , gtlapps-vv-qa                           , 3876342a                                ;
# snap-rails                              , gtlapps-vv-qa                           , 3876342a                                ;
# spinalq                                 , gtlapps-vv-qa                           , 3876342a                                ;
# spinalstream                            , gtlapps-vv-qa                           , 3876342a                                ;
# telmate-jms                             , gtlapps-vv-qa                           , 3876342a                                ;
# telmate-mobile-service                  , gtlapps-vv-qa                           , 3876342a                                ;
# telmate-mobile-service-mqtt-tablet-worke                                       , gtlapps-vv-qa                           , 3876342a                                ;
# telmate-mobile-service-tablet-audit-work                                      , gtlapps-vv-qa                           , 3876342a                                ;
# telmate-mobile-service-worker           , gtlapps-vv-qa                           , 3876342a                                ;
# telmate-netsuite-connector              , gtlapps-vv-qa                           , 3876342a                                ;
# telmate-pay                             , gtlapps-vv-qa                           , 3876342a                                ;
# telmate-purse-service                   , gtlapps-vv-qa                           , 3876342a                                ;
# telmate-schedule                        , gtlapps-vv-qa                           , 3876342a                                ;
# telmate-visit-service                   , gtlapps-vv-qa                           , 3876342a                                ;
# tyger-member-ts                         , gtlapps-vv-qa                           , 3876342a                                ;
# tygerweb                                , gtlapps-vv-qa                           , 3876342a                                ;
# umdm-service                            , gtlapps-vv-qa                           , cc1f591a                                ;
# usso                                    , gtlapps-vv-qa                           , 3876342a                                ;
# wallet                                  , gtlapps-vv-qa                           , 3876342a                                ;
# zone                                    , gtlapps-vv-qa                           , 3876342a                                ;
# Done.
