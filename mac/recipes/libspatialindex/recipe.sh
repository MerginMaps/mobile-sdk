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

  # remove in release 1.9.4
  # see https://github.com/libspatialindex/libspatialindex/commit/387a5a07d4f7ab6d94d9f3aaf728f5cc81b2d944
  try patch --verbose --forward -p1 < $RECIPE_spatialindex/patches/temporaryfile.patch
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

  push_env

  try $CMAKECMD \
    -DCMAKE_INSTALL_PREFIX:PATH=$STAGE_PATH \
    -DBUILD_SHARED_LIBS=OFF \
    $BUILD_libspatialindex

  try $MAKESMP
  try $MAKESMP install

  pop_env
}

# function called after all the compile have been done
function postbuild_libspatialindex() {
    if [ ! -f ${STAGE_PATH}/lib/libspatialindex.a ]; then
        error "Library was not successfully build for ${ARCH}"
        exit 1;
    fi
}
