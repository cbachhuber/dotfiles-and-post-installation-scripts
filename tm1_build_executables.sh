#!/usr/bin/env bash
set -eu

CLEAN_BUILD=false

POSITIONAL=()
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -c | --clean-build)
            CLEAN_BUILD=true
            shift # past argument
            ;;
        *)                     # unknown option
            POSITIONAL+=("$1") # save it in an array for later
            shift              # past argument
            ;;
    esac
done

set -- "${POSITIONAL[@]}" # restore positional parameters

cd /home/chris/TM1
CMAKE_DIR="$(pwd)/CMake"
mkdir -p build.install && cd build.install
if [ "$CLEAN_BUILD" = true ]; then cmake clean; fi

cmake -DCMAKE_INSTALL_PREFIX=/home/chris/TM1/install \
    -DENABLE_CLANG_TIDY=OFF \
    -DBUILD_CATCH2=OFF \
    -DBUILD_HM=ON \
    -DBUILD_TAppEncoder=TRUE \
    -DBUILD_TAppDecoder=TRUE \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_CXX_FLAGS="-O3" \
    -DNO_INTERNET=ON \
    ..

make -j $(nproc) install

