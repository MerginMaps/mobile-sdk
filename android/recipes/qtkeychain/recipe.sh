#!/bin/bash

# version of your package in ../../../versions.conf

# dependencies of this recipe
DEPS_qtkeychain=()

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

  try patch -p1 < $RECIPE_qtkeychain/patches/androidkeystore.patch
  try patch -p1 < $RECIPE_qtkeychain/patches/androidkeystore_p.patch
  try patch -p1 < $RECIPE_qtkeychain/patches/cmake.patch
  try patch -p1 < $RECIPE_qtkeychain/patches/keychain_android.patch
  
  touch .patched
}

function shouldbuild_qtkeychain() {
 if [ -f $STAGE_PATH/lib/libqt6keychain.a ]; then
  DO_BUILD=0
 fi
}

# function called to build the source code
function build_qtkeychain() {
 try mkdir -p $BUILD_qtkeychain/build-$ARCH
 try cd $BUILD_qtkeychain/build-$ARCH

 push_arm

 # configure
 try $CMAKECMD \
      -DCMAKE_INSTALL_PREFIX:PATH=$STAGE_PATH \
      -DBUILD_WITH_QT6=ON \
      -DBUILD_TEST_APPLICATION=OFF \
      -DBUILD_SHARED_LIBS=OFF \
      -DBUILD_TOOLS=OFF \
      -DWITH_nss_PLUGIN=OFF \
      -DWITH_pkcs11_PLUGIN=OFF \
      -DANDROID=TRUE \
  $BUILD_qtkeychain

  try $MAKESMP install

  pop_arm
}

# function called after all the compile have been done
function postbuild_qtkeychain() {
    if [ ! -f $STAGE_PATH/lib/libqt6keychain.a ]; then
        error "Library was not successfully build for ${ARCH}"
        exit 1;
    fi
}
