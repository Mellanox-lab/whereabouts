#!/bin/bash
export DOCKER_CLI_EXPERIMENTAL=enabled
eval $(dpkg-architecture -s)
ARCH=$(uname -m)
set -x
SRC_TAG=v0.5.1
M_TAG=v0.5.1
MAIN=harbor.mellanox.com/swx-infra/whereabouts:$M_TAG
#
docker --config ~/.docker/swx-infra \
    manifest create $MAIN --amend \
    harbor.mellanox.com/swx-infra/aarch64/whereabouts:$SRC_TAG \
    harbor.mellanox.com/swx-infra/x86_64/whereabouts:$SRC_TAG \
    harbor.mellanox.com/swx-infra/ppc64le/whereabouts:$SRC_TAG
if [ "$DEB_BUILD_ARCH_CPU" == "ppc64el" ] ; then
    DEB_BUILD_ARCH_CPU=ppc64le
fi
docker --config ~/.docker/swx-infra/ \
    manifest annotate $MAIN \
    harbor.mellanox.com/swx-infra/$ARCH/whereabouts:$SRC_TAG --arch "$DEB_BUILD_ARCH_CPU"

docker --config ~/.docker/swx-infra \
    manifest push $MAIN
