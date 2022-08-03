#!/bin/bash

# version of your package in ../../../versions.conf

# dependencies of this recipe
DEPS_proj=(sqlite3 libtiff)

# default build path
BUILD_proj=$BUILD_PATH/proj/$(get_directory $URL_proj)

# default recipe path
RECIPE_proj=$RECIPES_PATH/proj

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_proj() {
  cd $BUILD_proj

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_proj() {
  # If lib is newer than the sourcecode skip build
  if [ $STAGE_PATH/lib/libproj.a -nt $BUILD_proj/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_proj() {
  try mkdir -p $BUILD_PATH/proj/build-$ARCH
  try cd $BUILD_PATH/proj/build-$ARCH

  push_arm

  try $CMAKECMD \
        -DCMAKE_INSTALL_PREFIX:PATH=$STAGE_PATH \
        -DBUILD_TESTING=OFF \
        -DBUILD_SHARED_LIBS=OFF \
        -DEXE_SQLITE3=`which sqlite3` \
        -DSQLITE3_INCLUDE_DIR=$STAGE_PATH/include \
        -DSQLITE3_LIBRARY=$STAGE_PATH/lib/libsqlite3.a \
        -DBUILD_APPS=OFF \
        -DENABLE_TIFF=ON \
        -DENABLE_CURL=OFF \
        -DPROJ_CMAKE_SUBDIR=share/cmake/proj4 \
        -DPROJ_DATA_SUBDIR=share/proj \
        -DPROJ_LIB_ENV_VAR_TRIED_LAST=OFF \
    $BUILD_proj

  try $MAKESMP install
  pop_arm
}

# function called after all the compile have been done
function postbuild_proj() {
    if [ ! -f ${STAGE_PATH}/lib/libproj.a ]; then
        error "Library was not successfully build for ${ARCH}"
        exit 1;
    fi
}
