#!/bin/bash

# version of your package in ../../version.conf

# dependencies of this recipe
DEPS_libpng=()

# filename because sourceforge likes to be special
FILENAME_libpng=libpng-${VERSION_libpng}.tar.xz

# default build path
BUILD_libpng=$BUILD_PATH/libpng/$(get_directory $FILENAME_libpng)

# default recipe path
RECIPE_libpng=$RECIPES_PATH/libpng

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_libpng() {
  cd $BUILD_libpng

  # check marker
  if [ -f .patched ]; then
    return
  fi
}

function shouldbuild_libpng() {
  # If lib is newer than the sourcecode skip build
  if [ $STAGE_PATH/lib/libpng.a -nt $BUILD_libpng/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_libpng() {
  try mkdir -p $BUILD_PATH/libpng/build-$ARCH
  try cd $BUILD_PATH/libpng/build-$ARCH
  push_arm

  # configure
  try $CMAKECMD \
    -DCMAKE_INSTALL_PREFIX:PATH=$STAGE_PATH \
    -DHAVE_LD_VERSION_SCRIPT=OFF \
    -DPNG_SHARED=OFF \
    $BUILD_libpng

  # try $MAKESMP
  try make genfiles
  try $MAKESMP install

  pop_arm
}

# function called after all the compile have been done
function postbuild_libpng() {
    if [ ! -f ${STAGE_PATH}/lib/libpng.a ]; then
        error "Library was not successfully build for ${ARCH}"
        exit 1;
    fi
}
