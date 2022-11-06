#!/bin/bash

REPOSITORY=https://github.com/itmarck/deploy.sh.git
TEMPORAL_FOLDER=$HOME/.deploy
INSTALLATION_FOLDER=/usr/local/bin

function install() {
  if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script, please use root to install"
    exit 1
  fi

  echo "(1/6) Cloning the repository from $REPOSITORY"
  git clone $REPOSITORY $TEMPORAL_FOLDER

  echo "(2/6) Copying the source folder into $INSTALLATION_FOLDER"
  mkdir -p $INSTALLATION_FOLDER/.deploy
  cp -r $TEMPORAL_FOLDER/.deploy/. $INSTALLATION_FOLDER/.deploy/

  echo "(3/6) Moving the script file into $INSTALLATION_FOLDER"
  cp $TEMPORAL_FOLDER/deploy.sh $INSTALLATION_FOLDER/
  mv $INSTALLATION_FOLDER/deploy.sh $INSTALLATION_FOLDER/deploy

  echo "(4/6) Setting the script file as executable"
  chmod u+x $INSTALLATION_FOLDER/deploy

  echo "(5/6) Cleaning all temporal files"
  rm -rf $TEMPORAL_FOLDER

  echo "(6/6) Script installed successfully"
}

install
