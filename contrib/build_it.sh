#!/bin/bash
M=$(uname -m)
case $M in 
    x86_64)
        DF=Dockerfile
        ;;
    ppc64le)
        DF=Dockerfile.ppc64le
        ;;
    aarch64)
        DF=Dockerfile.arm64
        ;;
    *)
        echo "$M isn't supported. Exit" >&2
        exit 1
esac
TAG=$(git describe --tags --abbrev=4)
URL=harbor.mellanox.com/swx-infra/$M/whereabouts:$TAG
docker build -t $URL -f $DF .
