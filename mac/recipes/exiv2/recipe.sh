#!/bin/bash

# version of your package in ../../../versions.conf

# dependencies of this recipe
DEPS_exiv2=(expat)

# default build path
BUILD_exiv2=$BUILD_PATH/exiv2/$(get_directory $URL_exiv2)

# default recipe path
RECIPE_exiv2=$RECIPES_PATH/exiv2

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_exiv2() {
  cd $BUILD_exiv2

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_exiv2() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/libexiv2.a -nt $BUILD_exiv2/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_exiv2() {
	
  try mkdir -p $BUILD_PATH/exiv2/build-$ARCH
  try cd $BUILD_PATH/exiv2/build-$ARCH
  push_env
  
  try $CMAKECMD \
    -DBUILD_SHARED_LIBS=OFF \
    -DEXIV2_BUILD_EXIV2_COMMAND=OFF \
    -DEXIV2_BUILD_SAMPLES=OFF \
    -DEXIV2_BUILD_UNIT_TESTS=OFF \
    -DEXIV2_BUILD_DOC=OFF \
    -DEXIV2_ENABLE_NLS=OFF \
    -DIconv_IS_BUILT_IN=OFF \
    $BUILD_exiv2
  
  check_file_configuration CMakeCache.txt
  
  try $MAKESMP install

  pop_env
}

# function called after all the compile have been done
function postbuild_exiv2() {
  if [ ! -f ${STAGE_PATH}/lib/libexiv2.a ]; then
      error "Library was not successfully build for ${ARCH}"
      exit 1;
  fi
}