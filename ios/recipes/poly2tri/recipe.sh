#!/bin/bash

# version of your package in ../../../versions.conf

# dependencies of this recipe
DEPS_poly2tri=()

# default build path
BUILD_poly2tri=$BUILD_PATH/poly2tri/$(get_directory $URL_poly2tri)

# default recipe path
RECIPE_poly2tri=$RECIPES_PATH/poly2tri

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_poly2tri() {
  cd $BUILD_poly2tri

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_poly2tri() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/include/poly2tri.h -nt $BUILD_poly2tri/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_poly2tri() {
  try cd $BUILD_poly2tri

  push_arm

  try mkdir ${STAGE_PATH}/include/poly2tri
  try cp src/3rdparty/poly2tri/poly2tri.h ${STAGE_PATH}/include/poly2tri/
  try mkdir ${STAGE_PATH}/include/poly2tri/sweep
  try cp -R src/3rdparty/poly2tri/sweep/*.h ${STAGE_PATH}/include/poly2tri/sweep/
  try mkdir ${STAGE_PATH}/include/poly2tri/common
  try cp -R src/3rdparty/poly2tri/common/*.h ${STAGE_PATH}/include/poly2tri/common/
  
  pop_arm
}

# function called after all the compile have been done
function postbuild_poly2tri() {
  if [ ! -f "${STAGE_PATH}/include/poly2tri/poly2tri.h" ]; then
        error "Library was not successfully build for ${ARCH}"
        exit 1
  fi
}
