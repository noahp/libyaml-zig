#!/usr/bin/env bash

# Simple test script to run the tests in docker

# Error on any non-zero command, and print the commands as they're run
set -ex

# Make sure we have the docker utility
if ! command -v docker; then
    echo "🐋 Please install docker first 🐋"
    exit 1
fi

# Set the docker image name to default to repo basename
DOCKER_IMAGE_NAME=${DOCKER_IMAGE_NAME:-$(basename -s .git "$(git remote --verbose | awk 'NR==1 { print tolower($2) }')")}

# build the docker image
DOCKER_BUILDKIT=1 docker build -t "$DOCKER_IMAGE_NAME" --build-arg "UID=$(id -u)" -f Dockerfile .

# build libyaml with zig cc, statically linked with musl
# then build the small test application and run it with foo.yaml input
# docker run -i -v "$(pwd)":/mnt/workspace -t "$DOCKER_IMAGE_NAME" bash -c "
#     export CC='zig cc -target x86_64-linux-musl -static' &&
#     cd /mnt/workspace &&
#     (
#         cd libyaml &&
#         ./bootstrap && ./configure && make -j6
#     ) &&
#     zig cc -target x86_64-linux-musl -static -O2 test.c ./libyaml/src/.libs/libyaml.a && ./test foo.yaml"

# Windows cross not working :(
# docker run -i -v "$(pwd)":/mnt/workspace -t "$DOCKER_IMAGE_NAME" bash -c "
#     export CC='zig cc -target x86_64-windows-gnu -static' &&
#     cd /mnt/workspace &&
#     (
#         cd libyaml &&
#         ./bootstrap && ./configure --build x86_64-linux-gnu --host x86_64-windows-gnu && make -j6
#     ) &&
#     zig cc -target x86_64-windows-gnu -static -static test.c ./libyaml/src/.libs/libyaml.a && wine64 ./test foo.yaml"

