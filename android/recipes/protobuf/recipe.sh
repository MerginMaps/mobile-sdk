#!/bin/bash

# dependencies of this recipe
DEPS_protobuf=()

# default build path
BUILD_protobuf=$BUILD_PATH/protobuf/$(get_directory $URL_protobuf)

# default recipe path
RECIPE_protobuf=$RECIPES_PATH/protobuf

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_protobuf() {
  cd $BUILD_protobuf

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_protobuf() {
  if [ -f ${STAGE_PATH}/lib/libprotobuf.a ]; then
    DO_BUILD=0
  fi
}

function build_native_protobuf() {
  # also we need to build protobuf native executable,
  # since we need to create C++ files
  # from .proto files at build time for QGIS
  try mkdir -p $BUILD_PATH/protobuf/build-native/
  try cd $BUILD_PATH/protobuf/build-native

  push_native

  try cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -Dprotobuf_BUILD_TESTS=OFF \
    -DCMAKE_INSTALL_PREFIX:PATH=$NATIVE_STAGE_PATH \
    $BUILD_protobuf/cmake

  try make -j$CORES
  try make install

  pop_arm
}

# function called to build the source code
function build_android_protobuf() {
  #try rsync -a $BUILD_protobuf/ $BUILD_PATH/protobuf/build-$ARCH/
  try mkdir -p $BUILD_PATH/protobuf/build-$ARCH/
  try cd $BUILD_PATH/protobuf/build-$ARCH
  push_arm

  try $CMAKECMD \
    -Dprotobuf_BUILD_TESTS=OFF \
    -DCMAKE_INSTALL_PREFIX:PATH=$STAGE_PATH \
    -DBUILD_SHARED_LIBS=OFF \
    $BUILD_protobuf/cmake

  try $MAKESMP
  try $MAKE install

  pop_arm
}

function build_protobuf() {
  build_native_protobuf
  build_android_protobuf
}

# function called after all the compile have been done
function postbuild_protobuf() {
    if [ ! -f ${STAGE_PATH}/lib/libprotobuf.a ]; then
        error "Library was not successfully build for ${ARCH}"
        exit 1;
    fi
}
