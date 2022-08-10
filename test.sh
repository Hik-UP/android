#!/bin/bash

readonly WORKDIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

rm -rf ${WORKDIR}/coverage

if ! docker compose up 'test'; then
  docker-compose up 'test'
fi
if ! docker compose rm -f 'test'; then
  docker-compose rm -f 'test'
fi

sudo chown -R ${EUID}:${EUID} ${WORKDIR}/coverage
genhtml ${WORKDIR}/coverage/lcov.info -o ${WORKDIR}/coverage/html
