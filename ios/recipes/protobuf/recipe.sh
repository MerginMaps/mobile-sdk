#!/bin/bash

# version of your package in ../../../versions.conf

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

  try cp $ROOT_OUT_PATH/.packages/config.sub "$BUILD_protobuf"
  try cp $ROOT_OUT_PATH/.packages/config.guess "$BUILD_protobuf"

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
function build_ios_protobuf() {
  try mkdir -p $BUILD_PATH/protobuf/build-$ARCH/
  try cd $BUILD_PATH/protobuf/build-$ARCH
  push_arm

  export CXXFLAGS="$CXXFLAGS -DNDEBUG"
  export CPPFLAGS="$CXXFLAGS"

  try $BUILD_protobuf/configure \
    --prefix=$STAGE_PATH \
    --host=$TOOLCHAIN_PREFIX \
    --disable-debug \
    --disable-dependency-tracking \
    --disable-shared \
    --with-protoc=$NATIVE_STAGE_PATH/bin/protoc

  try $MAKESMP
  try $MAKE install

  pop_arm
}

function build_protobuf() {
  build_native_protobuf
  build_ios_protobuf
}

# function called after all the compile have been done
function postbuild_protobuf() {
  true
}
