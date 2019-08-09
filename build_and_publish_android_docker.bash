#!/usr/bin/env bash

set -e

TAG=$1

PWD=`pwd`
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR/android

if (( $# < 1 )); then
    echo "build_and_publish_android_docker.bash DOCKER-TAG"
    exit 1
fi

git fetch --tags

if git rev-parse "$TAG" >/dev/null 2>&1; then
  echo "tag $TAG exists, please increase version number";
  exit 1;
fi

# should be done manually outside if you want to add manually username+pass
docker login
docker build . -t lutraconsulting/input-sdk:${TAG}

# Push to docker-hub
docker push lutraconsulting/input-sdk:${TAG}

# Tag GitHub repos
git tag ${TAG} && git push --tag

cd $PWD
