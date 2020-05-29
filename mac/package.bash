#!/usr/bin/env bash

echo "Creating package for MAC input-sdk"

source `dirname $0`/config.conf

THIS=`pwd`
cd $ROOT_OUT_PATH/stage/mac

FNAME="input-sdk-qt-$QT_VER-deps-$DEPS_VER-mac-$SDK_VERSION.tar.gz"
FPATH=$ROOT_OUT_PATH/$FNAME

if [ -f $FPATH ]; then
  rm -f $FPATH
fi

tar -c -z -f $FPATH ./

echo "created $FPATH"

cd $THIS
