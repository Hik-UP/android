#!/bin/bash

export readonly ANDROID_CMD='dev'

readonly FOLDER_NAME="$(cd "${WORKDIR}" && echo "${PWD##*/}")"
