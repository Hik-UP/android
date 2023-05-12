#!/bin/bash

check_argument() {
  case $1 in
    dev|build|test)
      ;;
    *)
      exit 1
      ;;
  esac
}

main() {
  local readonly USER_UID=$(ls -n /usr/app	|
  grep "coverage"				|
  cut -d " " -f 3)
  local readonly USER_GID=$(ls -n /usr/app	|
  grep "coverage"				|
  cut -d " " -f 4)

  check_argument "$@"
  flutter pub upgrade
  flutter pub get
  if [ $1 = 'dev' ]; then
    flutter run -d web-server --web-hostname 172.20.0.2 --web-port=8080
  elif [ $1 = 'build' ]; then
    flutter build apk
    mv /usr/app/build/app/outputs/flutter-apk/* /usr/app/apk
  else
    flutter test --coverage
    genhtml /usr/app/coverage/lcov.info -o /usr/app/coverage/html
    chown -R "${USER_UID}":"${USER_GID}" /usr/app/coverage
  fi
}

main "$@"
