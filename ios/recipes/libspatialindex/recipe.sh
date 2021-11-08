#!/bin/bash

# version of your package in ../../version.conf

# dependencies of this recipe
DEPS_libspatialindex=()

# default build path
BUILD_libspatialindex=$BUILD_PATH/libspatialindex/$(get_directory $URL_libspatialindex)

# default recipe path
RECIPE_libspatialindex=$RECIPES_PATH/libspatialindex

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_libspatialindex() {
  cd $BUILD_libspatialindex

  # check marker
  if [ -f .patched ]; then
    return
  fi

  try cp $ROOT_OUT_PATH/.packages/config.sub "$BUILD_libspatialindex"
  try cp $ROOT_OUT_PATH/.packages/config.guess "$BUILD_libspatialindex"

  try patch -p1 < $RECIPE_libspatialindex/patches/spatialindex.patch

  touch .patched
}

function shouldbuild_libspatialindex() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/libspatialindex.a -nt $BUILD_libspatialindex/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_libspatialindex() {
  try mkdir -p $BUILD_PATH/libspatialindex/build-$ARCH
  try cd $BUILD_PATH/libspatialindex/build-$ARCH

  push_arm

  try $CMAKECMD \
    -DCMAKE_INSTALL_PREFIX:PATH=$STAGE_PATH \
    $BUILD_libspatialindex

  try $MAKESMP
  try $MAKESMP install

  pop_arm
}

# function called after all the compile have been done
function postbuild_libspatialindex() {
  LIB_ARCHS=`lipo -archs ${STAGE_PATH}/lib/libspatialindex.a`
  if [[ $LIB_ARCHS != *"$ARCH"* ]]; then
    error "Library was not successfully build for ${ARCH}"
    exit 1;
  fi
}
