#!/usr/bin/env bash
set -eu

SCRIPT_DIR="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

export CC=/usr/bin/gcc
export CXX=/usr/bin/g++
"$SCRIPT_DIR"/tm1_local_pipeline.sh -c

export CC=/usr/bin/clang
export CXX=/usr/bin/clang++
"$SCRIPT_DIR"/tm1_local_pipeline.sh -c

