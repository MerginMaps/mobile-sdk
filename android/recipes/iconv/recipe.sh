#!/bin/bash

# version of your package in ../../version.conf

# dependencies of this recipe
DEPS_iconv=()

# default build path
BUILD_iconv=$BUILD_PATH/iconv/$(get_directory $URL_iconv)

# default recipe path
RECIPE_iconv=$RECIPES_PATH/iconv

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_iconv() {
  cd $BUILD_iconv

  # check marker
  if [ -f .patched ]; then
    return
  fi

  try patch -p1 < $RECIPES_PATH/iconv/patches/libiconv.patch
  try cp $ROOT_OUT_PATH/.packages/config.sub $BUILD_iconv/build-aux
  try cp $ROOT_OUT_PATH/.packages/config.guess $BUILD_iconv/build-aux
  try cp $ROOT_OUT_PATH/.packages/config.sub $BUILD_iconv/libcharset/build-aux
  try cp $ROOT_OUT_PATH/.packages/config.guess $BUILD_iconv/libcharset/build-aux

  touch .patched
}

function shouldbuild_iconv() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/libcharset.a -nt $BUILD_iconv/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_iconv() {
  try mkdir -p $BUILD_PATH/iconv/build-$ARCH
  try cd $BUILD_PATH/iconv/build-$ARCH

  push_arm

  try $BUILD_iconv/configure \
    --prefix=$STAGE_PATH \
    --host=$TOOLCHAIN_PREFIX \
    --build=x86_64 \
    --disable-shared
  
  try $MAKESMP
  try make install

  pop_arm
}

# function called after all the compile have been done
function postbuild_iconv() {
    if [ ! -f ${STAGE_PATH}/lib/libcharset.a ]; then
        error "Library was not successfully build for ${ARCH}"
        exit 1;
    fi
}
