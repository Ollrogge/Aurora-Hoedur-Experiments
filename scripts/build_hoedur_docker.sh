#!/bin/sh

DIR="$(dirname "$(readlink -f "$0")")"

args=""
while [ "$1" ]; do
    args="$cmd $1"
    shift
done

docker build -t aurora_hoedur $args $DIR -f ./Dockerfile
