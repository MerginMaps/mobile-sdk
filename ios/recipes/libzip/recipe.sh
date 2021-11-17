#!/bin/bash

# version of your package in ../../../versions.conf

# dependencies of this recipe
DEPS_libzip=()

# default build path
BUILD_libzip=$BUILD_PATH/libzip/$(get_directory $URL_libzip)

# default recipe path
RECIPE_libzip=$RECIPES_PATH/libzip

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_libzip() {
  cd $BUILD_libzip

  # check marker
  if [ -f .patched ]; then
    return
  fi

  # NOTE TO MYSELF, on libzip master, src/examples/man... can be switched off
  # by cmake option, so patch should not be needed any more
  # try patch -p1 < $RECIPE_libzip/patches/cmake.patch
  # try patch -p1 < $RECIPE_libzip/patches/cmake2.patch

  touch .patched
}

function shouldbuild_libzip() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/libzip.a -nt $BUILD_libzip/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_libzip() {
  try mkdir -p $BUILD_PATH/libzip/build-$ARCH
  try cd $BUILD_PATH/libzip/build-$ARCH

  push_arm

  # configure
  try ${CMAKECMD} \
    -DBUILD_TESTS=OFF \
    -DBUILD_SHARED_LIBS=OFF \
    -DENABLE_OPENSSL=OFF \
    -DENABLE_COMMONCRYPTO=OFF \
    -DENABLE_GNUTLS=OFF \
    -DBUILD_TOOLS=OFF \
    -DBUILD_REGRESS=OFF \
    -DBUILD_EXAMPLES=OFF \
    -DBUILD_DOC=OFF \
    -DIOS=TRUE \
  $BUILD_libzip
  try $MAKESMP install

  pop_arm
}

# function called after all the compile have been done
function postbuild_libzip() {
  LIB_ARCHS=`lipo -archs ${STAGE_PATH}/lib/libzip.a`
  if [[ $LIB_ARCHS != *"$ARCH"* ]]; then
    error "Library was not successfully build for ${ARCH}"
    exit 1;
  fi
}
