#!/usr/bin/env bash

set -e

TAG=$1

PWD=`pwd`
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR/ios

if (( $# < 1 )); then
    echo "build_ios.bash REPO-TAG"
    exit 1
fi

git fetch --tags

if git rev-parse "$TAG" >/dev/null 2>&1; then
  echo "tag $TAG exists, please increase version number";
  exit 1;
fi

IOS_CONFIG=config_rel.conf ./distribute -dqgis

# Tag GitHub repos
git tag ${TAG} && git push --tag

cd $PWD
