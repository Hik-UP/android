#!/bin/bash

readonly WORKDIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

rm -rf ${WORKDIR}/apk/*

if ! docker compose up build; then
  docker-compose up build
fi
if ! docker compose rm -f build; then
  docker-compose rm -f build
fi
