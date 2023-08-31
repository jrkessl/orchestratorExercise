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
names=qa
#for names in $( kubectl get ns | grep -v NAME | awk '{print $1}' ); do
    echo "namespace = $names"
    for ing in $( kubectl -n $names get ing  | grep -v NAME | awk '{print $1}' ); do # getting the list of ingresses
        
        groupnameline=$(kubectl -n $names describe ing/$ing | grep group.name | awk '{print $2}')
        cert=$(kubectl -n $names describe ing/$ing | grep certificate-arn | awk '{print $3}')
        cert2=${cert:47:8}

        echo "$(pad40 $ing), $(pad40 $groupnameline), $(pad40 $cert2);"

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
