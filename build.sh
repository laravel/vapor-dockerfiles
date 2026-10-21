#!/bin/bash

PHP_VERSION=$1
PUBLISH=$2

# Build for the image's own platform, not the host's, and skip provenance
# attestations so the tag is a plain single-platform manifest.
if [[ "$PHP_VERSION" == *-arm ]]; then
  PLATFORM=linux/arm64
else
  PLATFORM=linux/amd64
fi

docker build --platform ${PLATFORM} --provenance=false -f ${PWD}/${PHP_VERSION}.Dockerfile -t vapor-${PHP_VERSION}:latest .

docker tag vapor-${PHP_VERSION}:latest laravelphp/vapor:${PHP_VERSION}

if [ -n "$PUBLISH" ]; then
  docker push laravelphp/vapor:${PHP_VERSION}
fi