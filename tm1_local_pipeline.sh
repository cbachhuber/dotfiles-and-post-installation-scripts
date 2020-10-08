#!/usr/bin/env bash
set -eu

CLEAN_BUILD=false
APPLY_CLANG_TIDY_FIX=true
FULL_CLANG_FORMAT=false

POSITIONAL=()
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -nofix | --dont-apply-clang-tidy-fix)
            APPLY_CLANG_TIDY_FIX=false
            shift # past argument
            ;;
        -c | --clean-build)
            CLEAN_BUILD=true
            shift # past argument
            ;;
        -f | --full-clang-format)
            FULL_CLANG_FORMAT=true
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
if [ "$CLEAN_BUILD" = true ]; then rm -rf build/; fi
mkdir -p build && cd build

if [ "$APPLY_CLANG_TIDY_FIX" = true ]; then
    mv $CMAKE_DIR/clang_tidy.cmake $CMAKE_DIR/old_clang_tidy.cmake
    cp ../my_stuff/clang_tidy.cmake $CMAKE_DIR/clang_tidy.cmake
fi
cmake -DCMAKE_INSTALL_PREFIX=/home/chris/TM1/install -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DBUILD_HM=OFF -DCMAKE_CXX_FLAGS="-Wall -Wextra -Wpedantic -Werror" ..
if [ "$APPLY_CLANG_TIDY_FIX" = true ]; then
    rm $CMAKE_DIR/clang_tidy.cmake
    mv $CMAKE_DIR/old_clang_tidy.cmake $CMAKE_DIR/clang_tidy.cmake
fi

make -j $(nproc)

if [ "$FULL_CLANG_FORMAT" = true ]; then
    cmake --build . --target clang_format
else
    cd ..
    git diff -U0 --no-color v7.0-dev | clang-format-diff -p1 -i  # not ideal to relate to v7.0-dev
    cd build
fi

ctest

