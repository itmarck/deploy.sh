#!/bin/bash

DEPLOY_REPOSITORY=https://github.com/itmarck/deploy.sh.git
DEPLOY_TEMPORAL_FOLDER=$HOME/.deploy.temp
DEPLOY_WORKSPACE_FOLDER=/usr/local/bin

function install() {
  if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script, please use root to install"
    exit 1
  fi

  echo "Cloning the repository from $DEPLOY_REPOSITORY"
  git clone $DEPLOY_REPOSITORY $DEPLOY_TEMPORAL_FOLDER

  echo "Copying the .deploy folder to $DEPLOY_WORKSPACE_FOLDER"
  mkdir -p $DEPLOY_WORKSPACE_FOLDER/.deploy
  cp -r $DEPLOY_TEMPORAL_FOLDER/.deploy/. $DEPLOY_WORKSPACE_FOLDER/.deploy/

  echo "Copying the deploy.sh file to $DEPLOY_WORKSPACE_FOLDER"
  cp $DEPLOY_TEMPORAL_FOLDER/deploy.sh $DEPLOY_WORKSPACE_FOLDER/
  mv $DEPLOY_WORKSPACE_FOLDER/deploy.sh $DEPLOY_WORKSPACE_FOLDER/deploy

  echo "Set the deploy.sh file as executable"
  chmod u+x $DEPLOY_WORKSPACE_FOLDER/deploy

  echo "Cleaning the temporal folder"
  rm -rf $DEPLOY_TEMPORAL_FOLDER

  echo "Deploy.sh installed successfully"
}

install
