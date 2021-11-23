#!/bin/bash

# version of your package


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

  patch_configure_file configure

  touch .patched
}

function shouldbuild_protobuf() {
  if [ -f ${STAGE_PATH}/lib/libprotobuf.a ]; then
    DO_BUILD=0
  fi
}

function build_protobuf() {
    try mkdir -p $BUILD_PATH/protobuf/build-$ARCH/
    try cd $BUILD_PATH/protobuf/build-$ARCH
    push_env

    export CXXFLAGS="$CXXFLAGS -DNDEBUG -fvisibility-inlines-hidden -fvisibility=hidden"
    export CPPFLAGS="$CXXFLAGS"
    export CFLAGS="$CFLAGS -DNDEBUG -fvisibility-inlines-hidden -fvisibility=hidden"

    $BUILD_protobuf/autogen.sh
    patch_configure_file $BUILD_protobuf/configure

    try $BUILD_protobuf/configure \
      --prefix=$STAGE_PATH \
      --disable-debug \
      --disable-dependency-tracking \
      --disable-shared \
      --with-protoc=$NATIVE_STAGE_PATH/bin/protoc

    try $MAKESMP
    try $MAKE install

    pop_env
}

# function called after all the compile have been done
function postbuild_protobuf() {
    if [ ! -f ${STAGE_PATH}/lib/libprotobuf.a ]; then
        error "Library was not successfully build for ${ARCH}"
        exit 1;
    fi
}
