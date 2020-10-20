#!/usr/bin/env bash
set -eu

SCRIPT_DIR="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

export CC=/usr/bin/gcc
export CXX=/usr/bin/g++
printf "Build using only gcc\n"
"$SCRIPT_DIR"/tm1_local_pipeline.sh -c -b -hm

export CC=/usr/bin/clang
export CXX=/usr/bin/clang++
printf "\n\nBuild sing clang, do clang-tidy, clang-format, ctest\n\n"
"$SCRIPT_DIR"/tm1_local_pipeline.sh -c -hm

