#!/bin/bash

# version of your package
# VERSION_qtkeychain=0.8.0
VERSION_qtkeychain=0.9.1

# dependencies of this recipe
DEPS_qtkeychain=()

# url of the package
URL_qtkeychain=https://github.com/frankosterfeld/qtkeychain/archive/v${VERSION_qtkeychain}.tar.gz
# URL_qtkeychain=https://github.com/hasselmm/qtkeychain/archive/androidkeystore.tar.gz

# md5 of the package
# MD5_qtkeychain=8ac371cb68aad1582e7b8e7b0b4530cd
MD5_qtkeychain=e6921de6f256259784f2a9edd1eeb8f5

# default build path
BUILD_qtkeychain=$BUILD_PATH/qtkeychain/$(get_directory $URL_qtkeychain)

# default recipe path
RECIPE_qtkeychain=$RECIPES_PATH/qtkeychain

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_qtkeychain() {
  cd $BUILD_qtkeychain
  # check marker
  if [ -f .patched ]; then
    return
  fi

  try patch --verbose --forward -p1 < $RECIPE_qtkeychain/patches/cxx11.patch

  touch .patched
}

function shouldbuild_qtkeychain() {
 # If lib is newer than the sourcecode skip build
 if [ $BUILD_qtkeychain/build-$ARCH/libqt5keychain.a -nt $BUILD_qtkeychain/.patched ]; then
  DO_BUILD=0
 fi
}

# function called to build the source code
function build_qtkeychain() {
 try mkdir -p $BUILD_qtkeychain/build-$ARCH
 try cd $BUILD_qtkeychain/build-$ARCH

 push_arm

 # configure
 try ${CMAKECMD} \
  -DQT4_BUILD=OFF \
  -DQCA_SUFFIX=qt5 \
  -DBUILD_TESTS=OFF \
  -DBUILD_TOOLS=OFF \
  -DWITH_nss_PLUGIN=OFF \
  -DWITH_pkcs11_PLUGIN=OFF \
  -DQTKEYCHAIN_STATIC=TRUE \
  $BUILD_qtkeychain
 try $MAKESMP install

 pop_arm
}

# function called after all the compile have been done
function postbuild_qtkeychain() {
  LIB_ARCHS=`lipo -archs ${STAGE_PATH}/lib/libqt5keychain.a`
  if [[ $LIB_ARCHS != *"$ARCH"* ]]; then
    error "Library was not successfully build for ${ARCH}"
    exit 1;
  fi
}
