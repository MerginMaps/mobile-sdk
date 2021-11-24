#!/bin/bash

# version of your package in ../../../versions.conf

# dependencies of this recipe
DEPS_libtasn1=()

# default build path
BUILD_libtasn1=$BUILD_PATH/libtasn1/$(get_directory $URL_libtasn1)

# default recipe path
RECIPE_libtasn1=$RECIPES_PATH/libtasn1

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_libtasn1() {
  cd $BUILD_libtasn1

  # check marker
  if [ -f .patched ]; then
    return
  fi

  try cp $ROOT_OUT_PATH/.packages/config.sub "$BUILD_libtasn1"
  try cp $ROOT_OUT_PATH/.packages/config.guess "$BUILD_libtasn1"

  touch .patched
}

function shouldbuild_libtasn1() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/libtasn1.a -nt $BUILD_libtasn1/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_libtasn1() {
  push_arm

  export CFLAGS="${CFLAGS} -Wno-error=implicit-function-declaration"

  try cd $BUILD_libtasn1
  try $MAKE autoreconf

  try mkdir -p $BUILD_PATH/libtasn1/build-$ARCH
  try cd $BUILD_PATH/libtasn1/build-$ARCH

  try $BUILD_libtasn1/configure --disable-doc --disable-valgrind-tests --prefix=$STAGE_PATH --host=${TOOLCHAIN_PREFIX} --disable-shared
  try $MAKESMP install

  pop_arm
}

# function called after all the compile have been done
function postbuild_libtasn1() {
  LIB_ARCHS=`lipo -archs ${STAGE_PATH}/lib/libtasn1.a`
  if [[ $LIB_ARCHS != *"$ARCH"* ]]; then
    error "Library was not successfully build for ${ARCH}"
    exit 1;
  fi
}
