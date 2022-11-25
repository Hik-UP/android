#!/bin/bash

start_docker() {
  ANDROID_CMD="$@" docker compose up -d	\
  --no-build				\
  --no-recreate				\
  android
  docker attach android

  local readonly EXIT_CODE=$?

  docker compose stop --timeout 60 android
  docker compose rm --force  android
  exit ${EXIT_CODE}
}

stop_docker() {
  docker compose stop --timeout 60 android
  docker compose rm --force android
}

restart_docker() {
  stop_docker
  start_docker 'dev'
}

shell_docker() {
  docker compose exec --user 'root' android bash
}

logs_docker() {
  docker compose logs --follow android
}

install_docker() {
  docker compose build --no-cache --pull android
  mkdir "${WORKDIR}/app/apk"
  mkdir "${WORKDIR}/app/coverage"
}

uninstall_docker() {
  stop_docker
  rm -rf "${WORKDIR}/app/apk"
  rm -rf "${WORKDIR}/app/coverage"
  docker rmi hikup/android
  docker network rm "${FOLDER_NAME}_network"
  docker builder prune --all --force
}

reinstall_docker() {
  uninstall_docker
  install_docker
}

parse_docker() {
  case $1 in
    dev|build|test)
      start_docker "$@"
      exit $?
      ;;
    stop)
      stop_docker
      exit $?
      ;;
    restart)
      restart_docker
      exit $?
      ;;
    shell)
      shell_docker
      exit $?
      ;;
    logs)
      logs_docker
      exit $?
      ;;
    install)
      install_docker
      exit $?
      ;;
    uninstall)
      uninstall_docker
      exit $?
      ;;
    reinstall)
      reinstall_docker
      exit $?
      ;;
    *)
      help
      exit 1
      ;;
  esac
}
