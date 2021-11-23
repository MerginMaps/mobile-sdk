#!/bin/bash

# version of your package in ../../version.conf

# dependencies of this recipe
DEPS_webp=()

# default build path
BUILD_webp=$BUILD_PATH/webp/$(get_directory $URL_webp)

# default recipe path
RECIPE_webp=$RECIPES_PATH/webp

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_webp() {
  cd $BUILD_webp

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_webp() {
  # If lib is newer than the sourcecode skip build
  if [ $STAGE_PATH/lib/libwebp.a -nt $BUILD_webp/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_webp() {
  try mkdir -p $BUILD_PATH/webp/build-$ARCH
  try cd $BUILD_PATH/webp/build-$ARCH
  push_env
  try $CMAKECMD \
    -DCMAKE_INSTALL_PREFIX:PATH=$STAGE_PATH \
    -DBUILD_SHARED_LIBS=OFF \
    -DWEBP_BUILD_GIF2WEBP=OFF \
    -DCMAKE_DISABLE_FIND_PACKAGE_GIF=TRUE \
    -DCMAKE_DISABLE_FIND_PACKAGE_JPEG=TRUE \
    -DCMAKE_DISABLE_FIND_PACKAGE_PNG=TRUE \
    -DCMAKE_DISABLE_FIND_PACKAGE_TIFF=TRUE \
    $BUILD_webp

  check_file_configuration CMakeCache.txt

  try $MAKESMP
  try $MAKESMP install
  pop_env
}

# function called after all the compile have been done
function postbuild_webp() {
    if [ ! -f $STAGE_PATH/lib/libwebp.a ]; then
        error "Library was not successfully build for ${ARCH}"
        exit 1;
    fi
}
