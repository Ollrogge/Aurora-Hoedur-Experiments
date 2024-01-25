#!/bin/bash

usage() {
    echo "Usage: <path to build dir> <script to execute in container> <options>"
}

#cd "$(dirname $0)" || exit 1

if [ $# -eq 0 ]; then
    usage
    exit 0
fi

if [ ! -d $1 ]; then
    echo "Path to build directory is not a directory"
    exit 1
fi

BUILD_DIR=$1

shift

FOLDER_NAME=$(basename $BUILD_DIR)

#docker run --rm --user "$(id -u):$(id -g)" --env "HOME=/home/user" --mount src="$PWD/..",target=/home/user/hoedur-experiments,type=bind --mount src="$PWD/../targets",target=/home/user/hoedur-targets,type=bind -it aurora_hoedur $@
docker run --rm --user "$(id -u):$(id -g)" --env "HOME=/home/user" --mount src="$BUILD_DIR",target=/home/user/hoedur-targets/arm/$FOLDER_NAME,type=bind -it aurora_hoedur $@
