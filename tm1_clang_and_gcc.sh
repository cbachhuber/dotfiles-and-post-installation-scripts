#!/usr/bin/env bash
set -eu


export CC=/usr/bin/gcc
export CXX=/usr/bin/g++
local_pipeline -c

export CC=/usr/bin/clang
export CXX=/usr/bin/clang++
local_pipeline -c

