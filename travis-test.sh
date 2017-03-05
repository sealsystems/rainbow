#!/bin/bash
set -e

# test version
if [ -n $TRAVIS_TAG ]; then
  packageVersion=$(cat package.json | jq -j .version)
  if [ ! $TRAVIS_TAG == $packageVersion ]; then
    echo "Travis tag $TRAVIS_TAG and package.json version $packageVersion differ!"
    exit 1
  fi
fi

# test image
docker run --entrypoint node blinkt --version
