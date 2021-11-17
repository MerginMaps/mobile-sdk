#!/bin/bash
# a library to extract valid data from within an Excel (.xls) spreadsheet

# version of your package in ../../../versions.conf

# dependencies of this recipe
DEPS_freexl=(iconv)

# default build path
BUILD_freexl=$BUILD_PATH/freexl/$(get_directory $URL_freexl)

# default recipe path
RECIPE_freexl=$RECIPES_PATH/freexl

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_freexl() {
  cd $BUILD_freexl

  # check marker
  if [ -f .patched ]; then
    return
  fi

  try cp $ROOT_OUT_PATH/.packages/config.sub "$BUILD_freexl"
  try cp $ROOT_OUT_PATH/.packages/config.guess "$BUILD_freexl"

  touch .patched
}

function shouldbuild_freexl() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/libfreexl.a -nt $BUILD_freexl/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_freexl() {
  try mkdir -p $BUILD_PATH/freexl/build-$ARCH
  try cd $BUILD_PATH/freexl/build-$ARCH
  push_arm
  export LDFLAGS="$LDFLAGS -liconv"
  try $BUILD_freexl/configure --prefix=$STAGE_PATH --host=${TOOLCHAIN_PREFIX} --disable-shared
  try $MAKESMP install

  pop_arm
}

# function called after all the compile have been done
function postbuild_freexl() {
  LIB_ARCHS=`lipo -archs ${STAGE_PATH}/lib/libfreexl.a`
  if [[ $LIB_ARCHS != *"$ARCH"* ]]; then
    error "Library was not successfully build for ${ARCH}"
    exit 1;
  fi
}
