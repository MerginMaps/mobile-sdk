#!/bin/bash

# version of your package
VERSION_geodiff=0.8.4

# dependencies of this recipe
DEPS_geodiff=()

# url of the package
URL_geodiff=https://github.com/lutraconsulting/geodiff/archive/${VERSION_geodiff}.tar.gz

# md5 of the package
MD5_geodiff=fc71253a40c234e59baecb890c837c6e

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
  if [ $BUILD_PATH/geodiff/build-$ARCH/libgeodiff.so -nt $BUILD_geodiff/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_geodiff() {
  try mkdir -p $BUILD_PATH/geodiff/build-$ARCH
  try cd $BUILD_PATH/geodiff/build-$ARCH

  push_arm

  try $CMAKECMD \
    -DCMAKE_INSTALL_PREFIX:PATH=$STAGE_PATH \
    -DENABLE_TESTS=OFF \
    -DBUILD_TOOLS=OFF \
    $BUILD_geodiff/geodiff

  try $MAKESMP
  try $MAKESMP install
  pop_arm
}

# function called after all the compile have been done
function postbuild_geodiff() {
	true
}
