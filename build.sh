#!/bin/bash

PHP_VERSION=php82-arm
PUBLISH=true

docker build -f ${PWD}/${PHP_VERSION}.Dockerfile -t vapor-${PHP_VERSION}:latest .

docker tag vapor-${PHP_VERSION}:latest 774901956562.dkr.ecr.us-east-1.amazonaws.com/vapor:${PHP_VERSION}

if [ -n "$PUBLISH" ]; then
  docker push 774901956562.dkr.ecr.us-east-1.amazonaws.com/vapor:${PHP_VERSION}
fi
