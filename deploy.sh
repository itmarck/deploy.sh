#!/bin/bash

if [ $1 = "register" ]; then
    printf "$2\n" >> repositories;
    echo "$2 was registered";
elif [ $1 = "list" ]; then
    i=0;
    echo -e "\nID\tFolder";
    while read line; do
        i=$((i+1));
        echo -e "$i\t$line";
    done < repositories;
elif [ $1 = "deploy" ]; then
    deploy_file="deploy.sh";
    i=0;
    while read line; do
        i=$((i+1));
        if [ $i = $2 ]; then
            echo "Deploying from $line";
            echo "Fetching data from remote server";
            if [ -f "$line/$deploy_file" ]; then
                echo "Reading $line/$deploy_file file";
                # check if deploy file is executable
                if [ -x "$line/$deploy_file" ]; then
                    echo "Running deploy file";
                    $line/deploy.sh;
                else
                    # make deploy file executable
                    echo "Making deploy file executable";
                    chmod +x $line/deploy.sh;
                    $line/deploy.sh;
                    echo "Deploy file is not executable";
                fi
            else
                echo "Deploy file not found";
            fi
            # cp -r ./service/* $line;
            echo "Service deployed";
            exit 0;
        fi
    done < repositories;
else
    echo "Usage: $0 {register|list|deploy}"
fi
