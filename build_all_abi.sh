#!/bin/bash

set -e

./build_libssh_linux.sh armeabi-v7a
./build_libssh_linux.sh arm64-v8a
./build_libssh_linux.sh x86
./build_libssh_linux.sh x86_64
