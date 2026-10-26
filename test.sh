#!/bin/bash

set -e

BUILD=$1

PHP_VERSIONS=("php82" "php82-arm" "php83" "php83-arm" "php84" "php84-arm" "php85" "php85-arm")

if [ -n "$BUILD" ]; then
  for phpVersion in "${PHP_VERSIONS[@]}"; do
    echo "Building $phpVersion"
    ./build.sh $phpVersion
  done
fi

echo

echo "+--------------------------------------------------------"
echo "| TEST: No extension is duplicated"
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
echo "| TEST: brotli-libs is at least 1.2.1-r0"
echo "+--------------------------------------------------------"
for phpVersion in "${PHP_VERSIONS[@]}"; do
    echo "Processing $phpVersion"

    result=$(docker run --rm vapor-$phpVersion:latest sh -c \
        'v=$(apk list --installed brotli-libs 2>/dev/null | cut -d" " -f1 | sed "s/^brotli-libs-//"); echo "$v $(apk version -t "$v" 1.2.1-r0)"')

    if [ "${result#* }" = "<" ]; then
        echo "Error found: brotli-libs ${result% *} is older than 1.2.1-r0 in $phpVersion"
        exit 1
    fi

    if ! docker run --rm vapor-$phpVersion:latest sh -c 'ldd /usr/lib/libcurl.so.4 | grep -q libbrotlidec'; then
        echo "Error found: libcurl is not linked against libbrotlidec in $phpVersion"
        exit 1
    fi
done

echo

echo "+--------------------------------------------------------"
echo "| Finished tests. All tests passed"
echo "+--------------------------------------------------------"
