#!/bin/bash

# Check if the user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script, please use root to install";
    exit 1;
fi

folder=/usr/local/bin

cp deploy.sh $folder/ -r;
mv $folder/deploy.sh $folder/deploy;
chmod u+x $folder/deploy;
