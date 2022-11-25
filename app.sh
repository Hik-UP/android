#!/bin/bash

if [ "${EUID}" -eq 0 ]; then
  echo "Don't run this script as root"
  exit 1
fi

readonly WORKDIR="$(dirname $(readlink -f "${BASH_SOURCE[0]}"))"

source "${WORKDIR}/scripts/global.sh"
source "${WORKDIR}/scripts/docker.sh"

help() {
  echo
  echo 'USAGE:'
  echo './app.sh	docker				dev'
  echo './app.sh	docker				build'
  echo './app.sh	docker				test'
  echo './app.sh	docker				stop'
  echo './app.sh	docker				restart'
  echo './app.sh	docker				shell'
  echo './app.sh	docker				logs'
  echo './app.sh	docker				install'
  echo './app.sh	docker				uninstall'
  echo './app.sh	docker				reinstall'
  echo
}

parse() {
  case $1 in
    docker)
      shift
      parse_docker "$@"
      exit $?
      ;;
    *)
      help
      exit 1
      ;;
  esac
}

if [ "$#" -lt 1 ]; then
  help
  exit 1
fi

parse "$@"
