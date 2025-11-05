#!/bin/bash

set -e

BUILD=$1

PHP_VERSIONS=("php82" "php82-arm" "php83" "php83-arm" "php84" "php84-arm")

if [ -n "$BUILD" ]; then
  for phpVersion in "${PHP_VERSIONS[@]}"; do
    echo "Building $phpVersion"
    ./build.sh $phpVersion
  done
fi

echo

echo "+--------------------------------------------------------"
echo "| TEST: test no extension is duplicated"
echo "+--------------------------------------------------------"
for phpVersion in "${PHP_VERSIONS[@]}"; do
    echo "Processing $phpVersion"
    
    if docker run vapor-$phpVersion:latest php -v 2>&1 | grep -q "it was already loaded"; then
        echo "Error found: Extension already loaded for $phpVersion"
        exit 1
    fi
done

echo

echo "+--------------------------------------------------------"
echo "| TEST: OPcache loaded"
echo "+--------------------------------------------------------"
for phpVersion in "${PHP_VERSIONS[@]}"; do
    echo "Processing $phpVersion"
    
    if ! docker run vapor-$phpVersion:latest php -m 2>&1 | grep -q "Zend OPcache"; then
        echo "Error found: OPCache not loaded for $phpVersion"
        exit 1
    fi
done

echo

echo "+--------------------------------------------------------"
echo "| Finshed tests. All tests passed"
echo "+--------------------------------------------------------"