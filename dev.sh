#!/bin/bash

if ! docker compose up -d 'dev'; then
  docker-compose up -d 'dev'
fi
docker attach 'hikup_android_dev'
if ! docker compose rm -f 'dev'; then
  docker-compose rm -f 'dev'
fi
