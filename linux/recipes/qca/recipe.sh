#!/bin/bash

# version of your package in ../../../versions.conf

# dependencies of this recipe
DEPS_qca=()

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

  touch .patched
}

function shouldbuild_qca() {
 if [ -f $STAGE_PATH/lib/libqca-qt6.so ]; then
  DO_BUILD=0
 fi
}

# function called to build the source code
function build_qca() {
 try mkdir -p $BUILD_qca/build-$ARCH
 try cd $BUILD_qca/build-$ARCH

 push_env

 # configure
 try $CMAKECMD \
     -DQT6=ON \
     -DCMAKE_INSTALL_PREFIX:PATH=$STAGE_PATH \
     -DBUILD_TESTS=OFF \
     -DBUILD_TOOLS=OFF \
     -DWITH_nss_PLUGIN=OFF \
     -DWITH_pkcs11_PLUGIN=OFF \
     -DWITH_gnupg_PLUGIN=OFF \
     -DWITH_gcrypt_PLUGIN=OFF \
     -DWITH_botan_PLUGIN=NO \
     -DCMAKE_DISABLE_FIND_PACKAGE_Doxygen=TRUE \
     -DBUILD_SHARED_LIBS=ON \
  $BUILD_qca

 try $MAKESMP install

 pop_env
}

# function called after all the compile have been done
function postbuild_qca() {
    if [ ! -f $STAGE_PATH/lib/libqca-qt6.so ]; then
        error "Library was not successfully build for ${ARCH}"
        exit 1;
    fi
}
