#!/bin/bash
set -xe
gitver=$(git describe --tags --dirty)
mkdir -p output
fullver=$(head -n1 packaging/debian/changelog | grep -Po '(?<=opensips \()[a-z0-9.~+-]+(?=\))')
distver=$(echo "$fullver" | cut -d '-' -f 1)
vgver=$(echo "$fullver" | cut -d '-' -f 2-)
docker build \
	--build-arg VGVER=$vgver \
	--build-arg VER=$distver \
	--force-rm \
	--tag voipgrid/opensips:${gitver} \
	.
docker run \
	--rm \
	--name opensips-${gitver} \
	voipgrid/opensips:${gitver} \
	bash -c 'tar -c /opensips*.deb /opensips_*' | tar -xvC output

echo "Packages are copied to ./output"
