#!/bin/bash
set -e

if [ $ARCH != "amd64" ]; then
  # prepare qemu
  docker run --rm --privileged multiarch/qemu-user-static:register --reset

  if [ $ARCH == "arm64" ]; then
    # prepare qemu binary
    docker create --name register hypriot/qemu-register
    docker cp register:qemu-aarch64 qemu-aarch64-static
  fi
fi

if [ -d tmp ]; then
  docker rm build
  rm -rf tmp
fi

# build image
docker build -t build -f Dockerfile.$ARCH-build .
docker create --name build build
docker cp build:/code/ tmp/
docker build -t blinkt -f Dockerfile.$ARCH .
