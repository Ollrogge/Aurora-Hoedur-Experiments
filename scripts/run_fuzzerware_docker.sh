#!/bin/sh

DIR="$(dirname "$(readlink -f "$0")")"
targets_dir="$1"
cmd=""

shift
while [ "$1" ]; do
    cmd="$cmd $1"
    shift
done

if [[ -z $targets_dir ]]; then
    echo "Missing target directory of firmware"
    exit 0
fi

[[ -d "$targets_dir" ]] || { echo "directory $targets_dir does not exist" && exit 1; }

docker_options=""
if [ -t 0 ]; then
    docker_options="-t"
fi

if [ -z "$cmd" ]; then
    cmd="/bin/bash"
    echo "[*] defaulting to cmd         '$cmd'"
fi

if [ ! -t 0 ]; then
    docker_options="-i"
    echo "[+] Running with -i"
else
    docker_options="-it"
    echo "[+] Running with -it"
fi

docker run \
    --rm -i \
    --user "$(id -u):$(id -g)" \
    --env "HOME=/home/user" \
    --env "PYTHON_EGG_CACHE=/tmp/.cache" \
    "$docker_options" \
    --mount type=bind,source="$(realpath $targets_dir)",target=/home/user/fuzzware/targets \
    "fuzzware:latest" $cmd