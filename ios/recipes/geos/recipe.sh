#!/bin/bash

# version of your package in ../../version.conf

# dependencies of this recipe
DEPS_geos=()

# default build path
BUILD_geos=$BUILD_PATH/geos/$(get_directory $URL_geos)

# default recipe path
RECIPE_geos=$RECIPES_PATH/geos

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_geos() {
  cd $BUILD_geos

  # check marker
  if [ -f .patched ]; then
    return
  fi

  try cp $ROOT_OUT_PATH/.packages/config.sub $BUILD_geos
  try cp $ROOT_OUT_PATH/.packages/config.guess $BUILD_geos

  touch .patched
}

function shouldbuild_geos() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/libgeos.a -nt $BUILD_geos/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_geos() {
  try mkdir -p $BUILD_PATH/geos/build-$ARCH
  try cd $BUILD_PATH/geos/build-$ARCH
  push_arm

  try ${CMAKECMD} \
    -DANDROID=OFF \
    -DBUILD_TESTING=OFF \
    -DIOS=TRUE \
    -DBUILD_SHARED_LIBS=FALSE \
    $BUILD_geos

  echo '#define GEOS_SVN_REVISION 0' > $BUILD_PATH/geos/build-$ARCH/geos_svn_revision.h
  try $MAKESMP
  try $MAKESMP install

  pop_arm
}

# function called after all the compile have been done
function postbuild_geos() {
  LIB_ARCHS=`lipo -archs ${STAGE_PATH}/lib/libgeos.a`
  if [[ $LIB_ARCHS != *"$ARCH"* ]]; then
    error "Library was not successfully build for ${ARCH}"
    exit 1;
  fi
}
