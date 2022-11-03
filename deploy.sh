#!/bin/bash

ACTION=""
ARGUMENT=""
HELP=false
VERBOSE=false
DEPLOY_FILE="deploy.sh"
STORAGE_FILE=".deploy/database/.repositories"

function initialize() {
  local positional_arguments=()

  while [[ $# -gt 0 ]]; do
    case $1 in
    -h | --help)
      HELP=true
      shift
      ;;
    -v | --verbose)
      VERBOSE=true
      shift
      ;;
    -f | --file)
      DEPLOY_FILE=$2
      shift 2
      ;;
    -* | --*)
      echo "Unknown option $1"
      exit 1
      ;;
    *)
      positional_arguments+=("$1")
      shift
      ;;
    esac
  done

  ACTION=${positional_arguments[0]}
  ARGUMENT=${positional_arguments[1]}

  readonly ACTION
  readonly ARGUMENT
  readonly HELP
  readonly VERBOSE
  readonly DEPLOY_FILE
  readonly STORAGE_FILE
}

function print_repositories() {
  # TODO: Make sure this line works along with remove command
  if [[ ! -s $STORAGE_FILE ]]; then
    echo "No repositories found"
    return
  fi

  while read -r line; do
    if [ "$VERBOSE" = true ]; then
      echo "$line"
    else
      echo "${line##*/}"
    fi
  done <"$STORAGE_FILE"
}

function list_repositories() {
  print_repositories
}

function add_repository() {
  echo "$ARGUMENT" >>"$STORAGE_FILE"
}

function remove_repository() {
  echo "Removing repository $ARGUMENT"
}

function deploy_repository() {
  echo "Deploying repository $ARGUMENT"
}

function unknown_command() {
  echo "Unknown command: $ACTION"
  echo
  display_help "help"
  exit 1
}

function display_help() {
  if [ -f .deploy/docs/$1.txt ]; then
    cat .deploy/docs/$1.txt
    exit 1
  fi
}

function validate() {
  if [ ! -f "$STORAGE_FILE" ]; then
    touch "$STORAGE_FILE"
  fi

  while [[ $# -gt 0 ]]; do
    case $1 in
    --argument)
      if [ -z "$ARGUMENT" ]; then
        echo "Repository name is required"
        exit 1
      fi
      shift
      ;;
    --absolute)
      if [[ $ARGUMENT != /* ]]; then
        echo "Repository location must be absolute"
        exit 1
      fi
      shift
      ;;
    --repository)
      if ! grep -q "$ARGUMENT" "$STORAGE_FILE"; then
        echo "Repository \"$ARGUMENT\" not found"
        exit 1
      fi
      shift
      ;;
    --no-repository)
      if grep -q "$ARGUMENT" "$STORAGE_FILE"; then
        echo "Repository already exists"
        exit 1
      fi
      shift
      ;;
    *)
      shift
      ;;
    esac
  done
}

function main() {
  initialize "$@"

  case $ACTION in
  "list")
    validate
    list_repositories
    ;;
  "add")
    validate --argument --absolute --no-repository
    add_repository
    ;;
  "remove")
    validate --argument --repository
    remove_repository
    ;;
  "deploy")
    validate --argument --repository
    deploy_repository
    ;;
  "")
    display_help "help"
    ;;
  *)
    unknown_command
    ;;
  esac
}

main "$@"
