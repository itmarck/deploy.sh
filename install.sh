#!/bin/bash

# Check if the user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script, please use root to install"
    exit 1
fi

folder=/usr/local/bin

cp deploy.sh $folder/deploy/ -r;
mv $folder/deploy/deploy.sh $folder/deploy/deploy;
chmod u+x $folder/deploy/deploy;
