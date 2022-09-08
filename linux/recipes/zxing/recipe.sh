#!/bin/bash

# Reading/Writing of QR Codes

# version of your package in ../../../versions.conf

# dependencies of this recipe
DEPS_zxing=()

# default build path
BUILD_zxing=$BUILD_PATH/zxing/$(get_directory $URL_zxing)

# default recipe path
RECIPE_zxing=$RECIPES_PATH/zxing

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_zxing() {
  cd $BUILD_zxing

  # check marker
  if [ -f .patched ]; then
    return
  fi
}

function shouldbuild_zxing() {
  # If lib is newer than the sourcecode skip build
  if [ $STAGE_PATH/lib/libZXing.so -nt $BUILD_zxing/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_zxing() {
  try mkdir -p $BUILD_PATH/zxing/build-$ARCH
  try cd $BUILD_PATH/zxing/build-$ARCH
  push_env

  # configure
  try $CMAKECMD \
    -DBUILD_EXAMPLES=OFF \
    -DBUILD_BLACKBOX_TESTS=OFF \
    -DBUILD_SHARED_LIBS=ON \
    -DBUILD_UNIT_TESTS=OFF \
    $BUILD_zxing
  
  try $MAKESMP
  try $MAKE install

  pop_env
}

# function called after all the compile have been done
function postbuild_zxing() {
    if [ ! -f ${STAGE_PATH}/lib/libZXing.so ]; then
        error "Library was not successfully build for ${ARCH}"
        exit 1;
    fi
}
