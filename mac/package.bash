#!/usr/bin/env bash

source `dirname $0`/config.conf

THIS=`pwd`
cd `dirname $0`/../build-mac/stage/mac

FNAME="input-sdk-qt-$QT_VER-deps-$DEPS_VER-mac-$1.tar.gz"

if [ -f $FNAME ]; then
  rm -f $FNAME
fi

tar -c -z -f ../../$FNAME ./

echo "created $FNAME"

cd $THIS
