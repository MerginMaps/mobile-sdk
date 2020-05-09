#!/usr/bin/env bash

set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

function error() {
  echo -e $1;
  exit -1
}

PWD=`pwd`
COMPRESS="tar -c -z --exclude=*.pyc -f"
DECOMPRESS="tar -xvzf"
function filesize() {
  du -h $1 | cut -f 1
}

source `dirname $0`/config.conf

echo "ios/create_package.bash"

QT=${QT_BASE}/ios
if [ ! -d $QT ]; then
  error "The root QT directory '$QT' not found. missing QT_BASE in config.conf?"
fi

STAGE_DIR=$ROOT_OUT_PATH/stage
if [ ! -d $STAGE_DIR ]; then
  error "The root STAGE_DIR directory '$STAGE_DIR' not found. build first"
fi

if [ "X$SDK_VERSION" == "X" ]; then
  error "you need SDK_VERSION argument in config.conf"
fi

echo "Create packages for input_sdk_ios from $ROOT_OUT_PATH"

##############################################
# Create QT package
QT_PACKAGE_FILE=qt-${QT_VERSION}-ios.tar.gz
QT_PACKAGE=$ROOT_OUT_PATH/${QT_PACKAGE_FILE}
QT_INSTALL_DIR=\$\{input_sdk_ios_PREFIX\}$QT_BASE/ios
if [ -f $QT_PACKAGE ]; then
  echo "Archive $QT_PACKAGE exists, skipping"
else
  echo "Arching $QT_PACKAGE"
  cd $QT_BASE/ios
  $COMPRESS ${QT_PACKAGE} ./
  cd $PWD
fi

##############################################
# Create Deps package
input_sdk_ios_PACKAGE_FILE=input-sdk-ios-${SDK_VERSION}.tar.gz
input_sdk_ios_PACKAGE=$ROOT_OUT_PATH/${input_sdk_ios_PACKAGE_FILE}
if [ -f $input_sdk_ios_PACKAGE ]; then
  echo "Archive $input_sdk_ios_PACKAGE exists, removing"
  rm -rf $input_sdk_ios_PACKAGE
fi

echo "Arching $input_sdk_ios_PACKAGE"
cd $STAGE_DIR
$COMPRESS ${input_sdk_ios_PACKAGE} ./
cd $PWD


##############################################
echo ""
echo "QT archive $QT_PACKAGE (`filesize $QT_PACKAGE`)"
echo "INPUT-SDK archive $input_sdk_ios_PACKAGE (`filesize $input_sdk_ios_PACKAGE`)"

echo "all done"