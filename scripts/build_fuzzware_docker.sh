#!/bin/sh

mkdir -p install
DIR="$(dirname "$(readlink -f "$0")")"
install_dir=$DIR/../install
fuzzware_dir=$install_dir/fuzzware

GIT_ARGS="-C $fuzzware_dir"

mkdir -p $install_dir
rm -rf $fuzzware_dir
git clone https://github.com/fuzzware-fuzzer/fuzzware $fuzzware_dir
#git $GIT_ARGS checkout 2bb5004ef3f0c199920f314a37289261f085701a
git $GIT_ARGS submodule update --init --recursive

#git $GIT_ARGS apply $DIR/fuzzware-dockerfile.patch
#cp $DIR/requirements-fuzzware-eval-docker.txt $fuzzware_dir

# Compile QEMU without CPU-specific features
sed -i 's/ -march=native//g' "$fuzzware_dir/emulator/unicorn/fuzzware-unicorn/Makefile"

# temporary env, useful for running scripts that require a specific working
# directory without permanently changing the current directory of the parent shell.
( cd $fuzzware_dir && $fuzzware_dir/build_docker.sh)