#!/bin/bash
set -e

docker tag blinkt sealsystems/rainbow:linux-$ARCH-$TRAVIS_TAG
docker push sealsystems/rainbow:linux-$ARCH-$TRAVIS_TAG

if [ $ARCH == "amd64" ]; then
  set +e
  echo "Waiting for other images sealsystems/rainbow:linux-arm-$TRAVIS_TAG"
  until docker run --rm stefanscherer/winspector sealsystems/rainbow:linux-arm-$TRAVIS_TAG
  do
    sleep 15
    echo "Try again"
  done
  until docker run --rm stefanscherer/winspector sealsystems/rainbow:linux-arm64-$TRAVIS_TAG
  do
    sleep 15
    echo "Try again"
  done
  set -e

  echo "Downloading manifest-tool"
  wget https://github.com/estesp/manifest-tool/releases/download/v0.4.0/manifest-tool-linux-amd64
  mv manifest-tool-linux-amd64 manifest-tool
  chmod +x manifest-tool
  ./manifest-tool

  echo "Pushing manifest sealsystems/rainbow:$TRAVIS_TAG"
  ./manifest-tool push from-args \
    --platforms linux/amd64,linux/arm,linux/arm64 \
    --template sealsystems/rainbow:OS-ARCH-$TRAVIS_TAG \
    --target sealsystems/rainbow:$TRAVIS_TAG

  echo "Pushing manifest sealsystems/rainbow:latest"
  ./manifest-tool push from-args \
    --platforms linux/amd64,linux/arm,linux/arm64 \
    --template sealsystems/rainbow:OS-ARCH-$TRAVIS_TAG \
    --target sealsystems/rainbow:latest
fi
