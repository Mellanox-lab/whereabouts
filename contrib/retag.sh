#!/bin/bash -e
export DOCKER_CLI_EXPERIMENTAL=enabled
eval $(dpkg-architecture -s)
ARCH=$(uname -m)
set -x
TAG=$(git describe --tags --abbrev=4)
MAIN=harbor.mellanox.com/swx-infra/whereabouts:$TAG
docker manifest create $MAIN --amend \
    harbor.mellanox.com/swx-infra/aarch64/whereabouts:$TAG \
    harbor.mellanox.com/swx-infra/x86_64/whereabouts:$TAG
if [ "$DEB_BUILD_ARCH_CPU" == "ppc64el" ] ; then
    DEB_BUILD_ARCH_CPU=ppc64le
fi
docker manifest annotate $MAIN \
    harbor.mellanox.com/swx-infra/$ARCH/whereabouts:$TAG --arch "$DEB_BUILD_ARCH_CPU"
docker --config ~/.docker/swx-infra manifest push $MAIN
