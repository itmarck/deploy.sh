#!/bin/bash

ACTION=""
REPOSITORY=""
VERBOSE=false
DEPLOY_FILE="deploy.sh"

WORKSPACE=""
WORKSPACE_STORAGE=""
WORKSPACE_DOCS=""

function initialize() {
  local positional_arguments=()

  WORKSPACE="$(dirname -- $(readlink -f -- "$0"))/.deploy"
  WORKSPACE_STORAGE="$WORKSPACE/database/.repositories"
  WORKSPACE_DOCS="$WORKSPACE/docs"

  if [ ! -d "$WORKSPACE" ]; then
    echo "Installation Error: Source folder not found"
    exit 1
  fi

  while [[ $# -gt 0 ]]; do
    case $1 in
    -a | --add)
      if [ -z "$ACTION" ]; then
        ACTION="add"
        shift
      fi
      ;;
    -r | --remove)
      if [ -z "$ACTION" ]; then
        ACTION="remove"
        shift
      fi
      ;;
    -f | --file)
      DEPLOY_FILE=$2
      shift 2
      ;;
    -v | --verbose)
      VERBOSE=true
      shift
      ;;
    --version)
      ACTION="version"
      shift
      ;;
    --help)
      ACTION="help"
      shift
      ;;
    -* | --*)
      echo "Unknown option $1"
      echo "Try 'deploy --help' for more information."
      exit 1
      ;;
    *)
      positional_arguments+=("$1")
      shift
      ;;
    esac
  done

  REPOSITORY=${positional_arguments[0]}

  if [ -z "$ACTION" ]; then
    if [ -n "$REPOSITORY" ]; then
      ACTION="deploy"
    else
      ACTION="list"
    fi
  fi

  readonly ACTION
  readonly REPOSITORY
  readonly VERBOSE
  readonly DEPLOY_FILE

  readonly WORKSPACE
  readonly WORKSPACE_STORAGE
  readonly WORKSPACE_DOCS
}

function print_repositories() {
  if [[ ! -s $WORKSPACE_STORAGE ]]; then
    echo "No repositories found"
    return
  fi

  while read -r line; do
    if [ "$VERBOSE" = true ]; then
      echo "$line"
    else
      echo "${line##*/}"
    fi
  done <"$WORKSPACE_STORAGE"
}

function list_repositories() {
  print_repositories
}

function add_repository() {
  echo "$REPOSITORY" >>"$WORKSPACE_STORAGE"
  echo "$REPOSITORY"
  echo "Repository added successfully"
}

function remove_repository() {
  cat "$WORKSPACE_STORAGE" >"$WORKSPACE_STORAGE.tmp"
  sed -i "/\/$REPOSITORY$/d" "$WORKSPACE_STORAGE"
  diff "$WORKSPACE_STORAGE.tmp" "$WORKSPACE_STORAGE" | grep "<" | sed "s/< //g" | cat
  rm "$WORKSPACE_STORAGE.tmp"
  echo "Repository removed successfully"
}

function deploy_repository() {
  echo "Deploying repository $REPOSITORY"
}

function unknown_command() {
  echo "Unknown command: $REPOSITORY"
  exit 1
}

function display_help() {
  if [ -f "$WORKSPACE_DOCS/$1.txt" ]; then
    cat "$WORKSPACE_DOCS/$1.txt"
    exit 1
  fi
}

function validate() {
  if [ ! -f "$WORKSPACE_STORAGE" ]; then
    touch "$WORKSPACE_STORAGE"
  fi

  while [[ $# -gt 0 ]]; do
    case $1 in
    --argument)
      if [ -z "$REPOSITORY" ]; then
        echo "Repository name is required"
        exit 1
      fi
      shift
      ;;
    --absolute)
      if [[ $REPOSITORY != /* ]]; then
        echo "Repository location must be absolute"
        exit 1
      fi
      shift
      ;;
    --repository)
      if ! grep -q "$REPOSITORY" "$WORKSPACE_STORAGE"; then
        echo "Repository \"$REPOSITORY\" not found"
        exit 1
      fi
      shift
      ;;
    --no-repository)
      if grep -q "$REPOSITORY" "$WORKSPACE_STORAGE"; then
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
  "deploy")
    validate --argument --repository
    deploy_repository
    ;;
  "add")
    validate --argument --absolute --no-repository
    add_repository
    ;;
  "remove")
    validate --argument --repository
    remove_repository
    ;;
  "help")
    display_help "help"
    ;;
  "version")
    display_help "version"
    ;;
  esac
}

main "$@"
