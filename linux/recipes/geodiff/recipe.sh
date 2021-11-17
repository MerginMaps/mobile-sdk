#!/bin/bash

# version of your package in ../../../versions.conf

# dependencies of this recipe
DEPS_geodiff=()


# default build path
BUILD_geodiff=$BUILD_PATH/geodiff/$(get_directory $URL_geodiff)

# default recipe path
RECIPE_geodiff=$RECIPES_PATH/geodiff

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_geodiff() {
  cd $BUILD_geodiff

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_geodiff() {
  # If lib is newer than the sourcecode skip build
  if [ $STAGE_PATH/lib/libgeodiff.a -nt $BUILD_geodiff/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_geodiff() {
  try mkdir -p $BUILD_PATH/geodiff/build-$ARCH
  try cd $BUILD_PATH/geodiff/build-$ARCH

  push_env

  try $CMAKECMD \
    -DENABLE_TESTS=OFF \
    -DBUILD_TOOLS=OFF \
    -DBUILD_STATIC=ON \
    -DBUILD_SHARED=OFF \
    -DWITH_POSTGRESQL=OFF \
    $BUILD_geodiff/geodiff

  try $MAKESMP
  try $MAKESMP install
  pop_env
}

# function called after all the compile have been done
function postbuild_geodiff() {
    if [ ! -f ${STAGE_PATH}/lib/libgeodiff.a ]; then
        error "Library was not successfully build for ${ARCH}"
        exit 1;
    fi
}
