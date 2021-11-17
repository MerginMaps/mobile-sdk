#!/bin/bash

# version of your package in ../../../versions.conf

# dependencies of this recipe
DEPS_libzip=()

# default build path
BUILD_libzip=$BUILD_PATH/libzip/$(get_directory $URL_libzip)

# default recipe path
RECIPE_libzip=$RECIPES_PATH/libzip

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_libzip() {
  cd $BUILD_libzip

  # check marker
  if [ -f .patched ]; then
    return
  fi
}

function shouldbuild_libzip() {
  # If lib is newer than the sourcecode skip build
  if [ -f $STAGE_PATH/lib/libzip.a ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_libzip() {
  try mkdir -p $BUILD_PATH/libzip/build-$ARCH
  try cd $BUILD_PATH/libzip/build-$ARCH
  push_arm

  # configure
  try $CMAKECMD \
  -DCMAKE_INSTALL_PREFIX:PATH=$STAGE_PATH \
  -DBUILD_TESTS=OFF \
  -DBUILD_SHARED_LIBS=OFF \
  -DBUILD_TOOLS=OFF \
  -DBUILD_REGRESS=OFF \
  -DBUILD_EXAMPLES=OFF \
  -DBUILD_DOC=OFF \
  $BUILD_libzip

  # try $MAKESMP
  try $MAKESMP install

  pop_arm
}

# function called after all the compile have been done
function postbuild_libzip() {
    if [ ! -f ${STAGE_PATH}/lib/libzip.a ]; then
        error "Library was not successfully build for ${ARCH}"
        exit 1;
    fi
}
