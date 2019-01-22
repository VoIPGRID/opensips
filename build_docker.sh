#!/bin/bash
set -xe
gitver=$(git describe --tags --dirty)
mkdir -p output
docker build --force-rm --tag voipgrid/opensips:${gitver} .
docker run --rm --name opensips-${gitver} voipgrid/opensips:${gitver} bash -c 'tar -c /opensips*.deb /opensips_*' | tar -xvC output

echo "Packages are copied to ./output"
