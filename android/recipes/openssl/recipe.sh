#!/bin/bash

# OpenSSL 1.1.x has new API compared to 1.0.2
# We need to stick with the version of SSL that is
# compatible with Qt's binaries, otherwise
# you got (runtime)
# "qt.network.ssl: QSslSocket::connectToHostEncrypted: TLS initialization failed"
#
# https://blog.qt.io/blog/2019/06/17/qt-5-12-4-released-support-openssl-1-1-1/
# see https://wiki.qt.io/Qt_5.12_Tools_and_Versions
# see https://wiki.qt.io/Qt_5.14.0_Known_Issues
# Qt 5.12.3 OpenSSL 1.0.2b
# Qt 5.12.4 OpenSSL 1.1.1
# Qt 5.13.0 OpenSSL 1.1.1
# Qt 5.14.1 OpenSSL 1.1.1d

# version of your package
VERSION_openssl=1.1.1f

# dependencies of this recipe
DEPS_openssl=()

# url of the package
URL_openssl=https://github.com/openssl/openssl/archive/OpenSSL_${VERSION_openssl//./_}.tar.gz

# default recipe path
RECIPE_openssl=$RECIPES_PATH/openssl

# default build path
BUILD_openssl=$BUILD_PATH/openssl/$(get_directory $URL_openssl)

# function called for preparing source code if needed
function prebuild_openssl() {
  touch .patched
}

function shouldbuild_openssl() {
  # If lib is newer than the sourcecode skip build
  if [ $STAGE_PATH/lib/libssl.so -nt $BUILD_openssl/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_openssl() {

  # Setup compiler toolchain based on CPU architecture
  if [ "X${ARCH}" == "Xarmeabi-v7a" ]; then
      export SSL_ARCH=android-arm
  elif [ "X${ARCH}" == "Xarm64-v8a" ]; then
      export SSL_ARCH=android-arm64
  elif [ "X${ARCH}" == "Xx86" ]; then
      export SSL_ARCH=android-x86
  elif [ "X${ARCH}" == "Xx86_64" ]; then
      export SSL_ARCH=android-x86_64
  else
      echo "Error: Please report issue to enable support for arch (${ARCH})."
      exit 1
  fi

  push_arm

  try $BUILD_openssl/Configure shared ${SSL_ARCH} -D__ANDROID_API__=$ANDROIDAPI --prefix=/
  ${MAKE} depend
  ${MAKE} DESTDIR=${STAGE_PATH} SHLIB_VERSION_NUMBER= SHLIB_EXT=_1_1.so build_libs

  # install
  try ${MAKE} SHLIB_VERSION_NUMBER= SHLIB_EXT=_1_1.so DESTDIR=$STAGE_PATH install_dev install_engines

  pop_arm
}

# function called after all the compile have been done
function postbuild_openssl() {
  true
}