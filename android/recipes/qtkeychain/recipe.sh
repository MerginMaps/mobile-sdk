#!/bin/bash

# version of your package in ../../version.conf

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

  # try patch --verbose --forward -p1 < $RECIPE_qtkeychain/patches/cxx11.patch
  # try patch --verbose --forward -p1 < $RECIPE_qtkeychain/patches/java.patch

  touch .patched
}

function shouldbuild_qtkeychain() {
 if [ -f $STAGE_PATH/lib/libqt5keychain_$ARCH.a ]; then
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
  -DQT4_BUILD=OFF \
  -DQCA_SUFFIX=qt5 \
  -DCMAKE_INSTALL_PREFIX:PATH=$STAGE_PATH \
  -DBUILD_TEST_APPLICATION=OFF \
  -DBUILD_TOOLS=OFF \
  -DWITH_nss_PLUGIN=OFF \
  -DWITH_pkcs11_PLUGIN=OFF \
  -DQTKEYCHAIN_STATIC=TRUE \
  $BUILD_qtkeychain

  try $MAKESMP VERBOSE=1 install

  pop_arm
}

# function called after all the compile have been done
function postbuild_qtkeychain() {
    if [ ! -f $STAGE_PATH/lib/libqt5keychain_$ARCH.a ]; then
        error "Library was not successfully build for ${ARCH}"
        exit 1;
    fi
}