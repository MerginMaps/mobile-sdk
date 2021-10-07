#!/bin/bash

# version of your package
VERSION_geodiff=1.0.3

# dependencies of this recipe
DEPS_geodiff=()

# url of the package
URL_geodiff=https://github.com/lutraconsulting/geodiff/archive/${VERSION_geodiff}.tar.gz

# md5 of the package
MD5_geodiff=824782942c66e710d0a003851e0bac99

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
  if [ $STAGE_PATH/lib/libgeodiff.dylib -nt $BUILD_geodiff/.patched ]; then
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
    -DWITH_INTERNAL_SQLITE3:BOOL=FALSE \
    -DSQLite3_INCLUDE_DIR:PATH=$QGIS_DEPS/include \
    -DSQLite3_LIBRARY=$QGIS_DEPS/lib/libsqlite3.dylib \
    $BUILD_geodiff/geodiff

  try $MAKESMP
  try $MAKESMP install
  pop_env
}

# function called after all the compile have been done
function postbuild_geodiff() {
	true
}
