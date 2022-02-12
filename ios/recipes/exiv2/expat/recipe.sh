#!/bin/bash

# version of your package in ../../../versions.conf

# dependencies of this recipe
DEPS_expat=()

# default build path
BUILD_expat=$BUILD_PATH/expat/$(get_directory $URL_expat)

# default recipe path
RECIPE_expat=$RECIPES_PATH/expat

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_expat() {
  cd $BUILD_expat

  # check marker
  if [ -f .patched ]; then
    return
  fi

  try cp $ROOT_OUT_PATH/.packages/config.sub "$BUILD_expat/conftools/"
  try cp $ROOT_OUT_PATH/.packages/config.guess "$BUILD_expat/conftools/"

  if [ "X${ARCH}" == "Xarm64" ]; then
    try patch -p1 < $RECIPE_expat/patches/readfilemap.patch
  fi

  touch .patched
}

function shouldbuild_expat() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/libexpat.a -nt $BUILD_expat/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_expat() {
  try mkdir -p $BUILD_PATH/expat/build-$ARCH
  try cd $BUILD_PATH/expat/build-$ARCH
  push_arm
  try $BUILD_expat/configure \
    --prefix=$STAGE_PATH \
    --host=${TOOLCHAIN_PREFIX} \
    --disable-shared
  try $MAKESMP install

  pop_arm
}

# function called after all the compile have been done
function postbuild_expat() {
  LIB_ARCHS=`lipo -archs ${STAGE_PATH}/lib/libexpat.a`
  if [[ $LIB_ARCHS != *"$ARCH"* ]]; then
    error "Library was not successfully build for ${ARCH}"
    exit 1;
  fi
}