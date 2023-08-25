#!/bin/bash

# this works for release.

# What happens here?
# This script sweeps projects looking for the ones still using Docker instead of Kaniko.
# How does it work?
# 1) project need to be downloaded (git cloned) into the current folder
# 2) script will cd into project, git checkout a branch (master/main, but could be other)
# 3) grep project files looking for specific terms
# 4) output results.

set -e 

# clear results file
if [[ -e /tmp/result ]]; then
    rm /tmp/result
fi

# how many lines/projects in the current folder (excluding trash lines from ls -la)
quant=$(ls -alF | grep -E ^d | grep -v -E -- "\.\/" |  grep -v helm-command | grep -v helm-oms | wc -l)
# grep -E ^d           = filters out everything that is not a directory
# grep -v -E -- "\.\/" = filters out the first "." and ".." directories that are in the result of the ls -la command

for folder in $( ls -alF | grep -E ^d | grep -v -E -- "\.\/" |  grep -v helm-command | grep -v helm-oms | awk '{print $9}' ); do # for all the projects (for all the lines returned by this statement)
    echo "starting another one: ${folder}" 
    echo "current directory: $(pwd)"
    echo "will run: 'cd ${folder}'"
    cd ${folder}
    echo "we are in: $(pwd)"

    releasebranches=0
    echo "Lets see which release branches we have here."
    for rb in $( git branch -r | grep -E -- "release\/2[0-9]{2}\.[0-9]{1,3}\.[0-9]{1,3}$" | sort | sed 's/origin\///' | tail -n 3 ); do
        echo "We are in the loop."
        ((releasebranches++)) || echo "duh"
        echo "Found a release branch: ${rb}. Lets check it out."
        echo "will run 'git checkout ${rb}'..."
        error=0
        git checkout ${rb} || error=1
        if [[ $error -eq 1 ]]; then
            # string padding to 40 chars lenght
            echo "We could not check into branch ${rb}. What is going on?"
            exit 1
            # forty="                                        " 
            # folder="${folder:0:40}${forty:0:$((40 - ${#folder}))}"
            # echo " ---------------------- Project ${folder}, does not have a qa branch. " | tee -a /tmp/result
            # echo "One more tested!"
            # echo ""
            # cd .. 
        else
            currentbranch=$(git rev-parse --abbrev-ref HEAD)
            echo "we are in ${currentbranch}"
            echo "git pull ..." 
            git pull #>/dev/null
            echo "git pull finished." 
            echo "clearing file..."
            # clear /tmp/tmp file
            if [[ -e /tmp/tmp ]]; then
                rm /tmp/tmp
            fi
            # search for wanted keywords (docker keywords)
            echo "grepping directory..."
            echo "searching for 'docker tag'."
            grep -iRl "docker tag" .  | grep -v README | grep -v .git >> /tmp/tmp || echo "no docker tag found."
            echo "searching for 'docker build'."
            grep -iRl "docker build" .  | grep -v README | grep -v .git >> /tmp/tmp || echo "no docker build found."
            echo "searching for 'docker push'."
            grep -iRl "docker push" .  | grep -v README | grep -v .git >> /tmp/tmp || echo "no docker push found."
            # do we have anything?
            echo "lets see what we found."
            # echo "the contents of /tmp/tmp are: $(cat /tmp/tmp)."
            # echo "doing an ls: $(ls -la /tmp | grep tmp | grep -v snap-private)"
            # if [[ -s /tmp/tmp ]]; then
            #     echo "that is a true."
            # else
            #     echo "that is not a true."
            # fi
            if [[ -s /tmp/tmp ]]; then
                files=$(cat /tmp/tmp | sort | uniq)

                # string padding to 40 chars lenght
                forty="                                        " 
                folder="${folder:0:40}${forty:0:$((40 - ${#folder}))}"
                echo " ---------------------- Project ${folder}, branch ${currentbranch}, these files still use docker: " | tee -a /tmp/result
                echo "${files}" | tee -a /tmp/result
                rm /tmp/tmp
            else    
                # string padding to 40 chars lenght
                forty="                                        " 
                folder="${folder:0:40}${forty:0:$((40 - ${#folder}))}"
                echo " ---------------------- Project ${folder}, branch ${currentbranch}, is clear. " | tee -a /tmp/result
            fi
        fi
    done
    if [[ $releasebranches -eq 0 ]]; then
        echo "Whoops! Looks like project ${folder} does not have any matching release branches."
        # string padding to 40 chars lenght
        forty="                                        " 
        folder="${folder:0:40}${forty:0:$((40 - ${#folder}))}"
        echo " ---------------------- Project ${folder} does not have any matching release branches. " | tee -a /tmp/result

    fi
    echo "One more tested!"
    echo ""
    cd .. 
done

#cat /tmp/result

echo "goodbye"
