#!/bin/bash

# What happens here?
# This script sweeps projects looking for the ones still using Docker instead of Kaniko.
# How does it work?
# 1) project need to be downloaded (git cloned) into the current folder
# 2) script will cd into project, git checkout a branch (master/main, but could be other)
# 3) grep project files looking for specific terms
# 4) output results.


set -e 

# clear results file
if [[ -e ~/Documents/gitlab-viapath/result-oms ]]; then
    rm ~/Documents/gitlab-viapath/result-oms
fi

# how many lines/projects in the current folder (excluding trash lines from ls -la)
# quant=$(ls -alF | grep -E ^d | grep -v -E -- "\.\/" |  grep -v helm-command | grep -v helm-oms | wc -l)
# grep -E ^d           = filters out everything that is not a directory
# grep -v -E -- "\.\/" = filters out the first "." and ".." directories that are in the result of the ls -la command

for folder in $( ls -alF | grep -E ^d | grep -v -E -- "\.\/" |  grep -E -- "(oms-)|(oms\/)" | grep -v helm-oms | awk '{print $9}' ); do # for all the projects (for all the lines returned by this statement)
    echo "starting another one: ${folder}" 
    echo "current directory: $(pwd)"
    echo "will run: 'cd ${folder}'"
    cd ${folder}
    echo "we are in: $(pwd)"

    # here we test the branches one by one. --------------------------------
    bbranch=qa
    echo "git checkout ${bbranch}..."
    error=0
    git checkout ${bbranch} || error=1
    if [[ $error -eq 1 ]]; then
        # string padding to 40 chars lenght
        forty="                                        " 
        folder="${folder:0:40}${forty:0:$((40 - ${#folder}))}"
        echo " ---------------------- Project ${folder}, does not have a ${bbranch} branch, or cannot check into it. " | tee -a ~/Documents/gitlab-viapath/result-oms
    else
        currentbranch=$(git rev-parse --abbrev-ref HEAD)
        echo "we are in ${currentbranch}"
        echo "git pull ..." 
        git pull #>/dev/null
        echo "git pull finished." 
        echo "clearing file..."
        # clear /tmp/tmp-oms file
        if [[ -e /tmp/tmp-oms ]]; then
            rm /tmp/tmp-oms
        fi
        # search for wanted keywords (docker keywords)
        echo "grepping directory..."
        echo "searching for 'docker tag/build/push'."
        grep -iRlE "(docker push)|(docker tag)|(docker build)" .  | grep -v README | grep -v .git/ >> /tmp/tmp-oms || echo "no docker commands found."
        # do we have anything?
        echo "lets see what we found."
        # echo "the contents of /tmp/tmp-oms are: $(cat /tmp/tmp-oms)."
        # echo "doing an ls: $(ls -la /tmp | grep tmp | grep -v snap-private)"
        # if [[ -s /tmp/tmp-oms ]]; then
        #     echo "that is a true."
        # else
        #     echo "that is not a true."
        # fi
        if [[ -s /tmp/tmp-oms ]]; then
            files=$(cat /tmp/tmp-oms | sort | uniq)

            # string padding to 40 chars lenght
            forty="                                        " 
            folder="${folder:0:40}${forty:0:$((40 - ${#folder}))}"
            echo " ---------------------- Project ${folder}, branch ${currentbranch}, these files still use docker: " | tee -a ~/Documents/gitlab-viapath/result-oms
            echo "${files}" | tee -a ~/Documents/gitlab-viapath/result-oms
            rm /tmp/tmp-oms
        else    
            # string padding to 40 chars lenght
            forty="                                        " 
            folder="${folder:0:40}${forty:0:$((40 - ${#folder}))}"
            echo " ---------------------- Project ${folder}, branch ${currentbranch}, is clear. " | tee -a ~/Documents/gitlab-viapath/result-oms
        fi
    fi

    # here we test the branches one by one. --------------------------------
    bbranch=feature/feature-1.0.0
    echo "git checkout ${bbranch}..."
    error=0
    git checkout ${bbranch} || error=1
    if [[ $error -eq 1 ]]; then
        # string padding to 40 chars lenght
        forty="                                        " 
        folder="${folder:0:40}${forty:0:$((40 - ${#folder}))}"
        echo " ---------------------- Project ${folder}, does not have a ${bbranch} branch, or cannot check into it. " | tee -a ~/Documents/gitlab-viapath/result-oms
    else
        currentbranch=$(git rev-parse --abbrev-ref HEAD)
        echo "we are in ${currentbranch}"
        echo "git pull ..." 
        git pull #>/dev/null
        echo "git pull finished." 
        echo "clearing file..."
        # clear /tmp/tmp-oms file
        if [[ -e /tmp/tmp-oms ]]; then
            rm /tmp/tmp-oms
        fi
        # search for wanted keywords (docker keywords)
        echo "grepping directory..."
        echo "searching for 'docker tag/build/push'."
        grep -iRlE "(docker push)|(docker tag)|(docker build)" .  | grep -v README | grep -v .git/ >> /tmp/tmp-oms || echo "no docker commands found."
        # do we have anything?
        echo "lets see what we found."
        # echo "the contents of /tmp/tmp-oms are: $(cat /tmp/tmp-oms)."
        # echo "doing an ls: $(ls -la /tmp | grep tmp | grep -v snap-private)"
        # if [[ -s /tmp/tmp-oms ]]; then
        #     echo "that is a true."
        # else
        #     echo "that is not a true."
        # fi
        if [[ -s /tmp/tmp-oms ]]; then
            files=$(cat /tmp/tmp-oms | sort | uniq)

            # string padding to 40 chars lenght
            forty="                                        " 
            folder="${folder:0:40}${forty:0:$((40 - ${#folder}))}"
            echo " ---------------------- Project ${folder}, branch ${currentbranch}, these files still use docker: " | tee -a ~/Documents/gitlab-viapath/result-oms
            echo "${files}" | tee -a ~/Documents/gitlab-viapath/result-oms
            rm /tmp/tmp-oms
        else    
            # string padding to 40 chars lenght
            forty="                                        " 
            folder="${folder:0:40}${forty:0:$((40 - ${#folder}))}"
            echo " ---------------------- Project ${folder}, branch ${currentbranch}, is clear. " | tee -a ~/Documents/gitlab-viapath/result-oms
        fi
    fi

    # here we test the branches one by one. --------------------------------
    bbranch=release/release-1.0.0
    echo "git checkout ${bbranch}..."
    error=0
    git checkout ${bbranch} || error=1
    if [[ $error -eq 1 ]]; then
        # string padding to 40 chars lenght
        forty="                                        " 
        folder="${folder:0:40}${forty:0:$((40 - ${#folder}))}"
        echo " ---------------------- Project ${folder}, does not have a ${bbranch} branch, or cannot check into it. " | tee -a ~/Documents/gitlab-viapath/result-oms
    else
        currentbranch=$(git rev-parse --abbrev-ref HEAD)
        echo "we are in ${currentbranch}"
        echo "git pull ..." 
        git pull #>/dev/null
        echo "git pull finished." 
        echo "clearing file..."
        # clear /tmp/tmp-oms file
        if [[ -e /tmp/tmp-oms ]]; then
            rm /tmp/tmp-oms
        fi
        # search for wanted keywords (docker keywords)
        echo "grepping directory..."
        echo "searching for 'docker tag/build/push'."
        grep -iRlE "(docker push)|(docker tag)|(docker build)" .  | grep -v README | grep -v .git/ >> /tmp/tmp-oms || echo "no docker commands found."
        # do we have anything?
        echo "lets see what we found."
        # echo "the contents of /tmp/tmp-oms are: $(cat /tmp/tmp-oms)."
        # echo "doing an ls: $(ls -la /tmp | grep tmp | grep -v snap-private)"
        # if [[ -s /tmp/tmp-oms ]]; then
        #     echo "that is a true."
        # else
        #     echo "that is not a true."
        # fi
        if [[ -s /tmp/tmp-oms ]]; then
            files=$(cat /tmp/tmp-oms | sort | uniq)

            # string padding to 40 chars lenght
            forty="                                        " 
            folder="${folder:0:40}${forty:0:$((40 - ${#folder}))}"
            echo " ---------------------- Project ${folder}, branch ${currentbranch}, these files still use docker: " | tee -a ~/Documents/gitlab-viapath/result-oms
            echo "${files}" | tee -a ~/Documents/gitlab-viapath/result-oms
            rm /tmp/tmp-oms
        else    
            # string padding to 40 chars lenght
            forty="                                        " 
            folder="${folder:0:40}${forty:0:$((40 - ${#folder}))}"
            echo " ---------------------- Project ${folder}, branch ${currentbranch}, is clear. " | tee -a ~/Documents/gitlab-viapath/result-oms
        fi
    fi

    # here we test the branches one by one. --------------------------------
    bbranch=master
    echo "git checkout ${bbranch}..."
    error=0
    git checkout ${bbranch} || error=1
    if [[ $error -eq 1 ]]; then
        # string padding to 40 chars lenght
        forty="                                        " 
        folder="${folder:0:40}${forty:0:$((40 - ${#folder}))}"
        echo " ---------------------- Project ${folder}, does not have a ${bbranch} branch, or cannot check into it. " | tee -a ~/Documents/gitlab-viapath/result-oms
    else
        currentbranch=$(git rev-parse --abbrev-ref HEAD)
        echo "we are in ${currentbranch}"
        echo "git pull ..." 
        git pull #>/dev/null
        echo "git pull finished." 
        echo "clearing file..."
        # clear /tmp/tmp-oms file
        if [[ -e /tmp/tmp-oms ]]; then
            rm /tmp/tmp-oms
        fi
        # search for wanted keywords (docker keywords)
        echo "grepping directory..."
        echo "searching for 'docker tag/build/push'."
        grep -iRlE "(docker push)|(docker tag)|(docker build)" .  | grep -v README | grep -v .git/ >> /tmp/tmp-oms || echo "no docker commands found."
        # do we have anything?
        echo "lets see what we found."
        # echo "the contents of /tmp/tmp-oms are: $(cat /tmp/tmp-oms)."
        # echo "doing an ls: $(ls -la /tmp | grep tmp | grep -v snap-private)"
        # if [[ -s /tmp/tmp-oms ]]; then
        #     echo "that is a true."
        # else
        #     echo "that is not a true."
        # fi
        if [[ -s /tmp/tmp-oms ]]; then
            files=$(cat /tmp/tmp-oms | sort | uniq)

            # string padding to 40 chars lenght
            forty="                                        " 
            folder="${folder:0:40}${forty:0:$((40 - ${#folder}))}"
            echo " ---------------------- Project ${folder}, branch ${currentbranch}, these files still use docker: " | tee -a ~/Documents/gitlab-viapath/result-oms
            echo "${files}" | tee -a ~/Documents/gitlab-viapath/result-oms
            rm /tmp/tmp-oms
        else    
            # string padding to 40 chars lenght
            forty="                                        " 
            folder="${folder:0:40}${forty:0:$((40 - ${#folder}))}"
            echo " ---------------------- Project ${folder}, branch ${currentbranch}, is clear. " | tee -a ~/Documents/gitlab-viapath/result-oms
        fi
    fi

    
    echo "One more tested!"
    echo ""
    cd .. 
done

#cat ~/Documents/gitlab-viapath/result-oms

echo "goodbye"
