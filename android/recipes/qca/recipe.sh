#!/bin/bash

# version of your package in ../../../versions.conf

# dependencies of this recipe
DEPS_qca=(openssl)

# default build path
BUILD_qca=$BUILD_PATH/qca/$(get_directory $URL_qca)

# default recipe path
RECIPE_qca=$RECIPES_PATH/qca

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_qca() {
  cd $BUILD_qca
  # check marker
  if [ -f .patched ]; then
    return
  fi

  # UPSTREAM patch: https://phabricator.kde.org/D23289
  try patch -p1 < $RECIPE_qca/patches/no_setuid.patch

  touch .patched
}

function shouldbuild_qca() {
 if [ -f $STAGE_PATH/lib/libqca-qt5.a ]; then
  DO_BUILD=0
 fi
}

# function called to build the source code
function build_qca() {
 try mkdir -p $BUILD_qca/build-$ARCH
 try cd $BUILD_qca/build-$ARCH

 push_arm

 # configure
 try $CMAKECMD \
  -DQT4_BUILD=OFF \
  -DQCA_SUFFIX=qt5 \
  -DCMAKE_INSTALL_PREFIX:PATH=$STAGE_PATH \
  -DBUILD_TESTS=OFF \
  -DBUILD_TOOLS=OFF \
  -DWITH_nss_PLUGIN=OFF \
  -DWITH_pkcs11_PLUGIN=OFF \
  -DWITH_gcrypt_PLUGIN=OFF \
  -DCMAKE_DISABLE_FIND_PACKAGE_Doxygen=TRUE \
  -DBUILD_SHARED_LIBS=OFF \
  $BUILD_qca

 try $MAKESMP install

 pop_arm
}

# function called after all the compile have been done
function postbuild_qca() {
    if [ ! -f $STAGE_PATH/lib/libqca-qt5.a ]; then
        error "Library was not successfully build for ${ARCH}"
        exit 1;
    fi
}
