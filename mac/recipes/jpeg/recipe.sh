#!/bin/bash


# version of your package in ../../../versions.conf


# dependencies of this recipe
DEPS_jpeg=()

# default build path
BUILD_jpeg=$BUILD_PATH/jpeg/$(get_directory $URL_jpeg)

# default recipe path
RECIPE_jpeg=$RECIPES_PATH/jpeg

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_jpeg() {
  cd $BUILD_jpeg

  # check marker
  if [ -f .patched ]; then
    return
  fi

  # so it is not picked by install step!
  try cp $RECIPE_jpeg/patches/cpl_port.h $BUILD_jpeg/frmts/jpeg/
  
  try rm $BUILD_jpeg/frmts/jpeg/libjpeg/CMakeLists.txt
  try cp $RECIPE_jpeg/patches/CMakeLists.txt $BUILD_jpeg/frmts/jpeg/libjpeg/

  # https://github.com/OSGeo/gdal/pull/6725
  try patch -p1 < $RECIPE_jpeg/patches/jerror.patch
  
  touch .patched
}

function shouldbuild_jpeg() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/libjpeg.a -nt $BUILD_jpeg/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_jpeg() {
  try mkdir -p $BUILD_PATH/jpeg/build-$ARCH
  try cd $BUILD_PATH/jpeg/build-$ARCH

  push_env
  
  try $CMAKECMD \
    -DCMAKE_INSTALL_PREFIX:PATH=$STAGE_PATH \
    -DBUILD_SHARED_LIBS=OFF \
    -DRENAME_INTERNAL_JPEG_SYMBOLS=ON \
    $BUILD_jpeg/frmts/jpeg/libjpeg/
  
  check_file_configuration CMakeCache.txt
     
  try $MAKESMP
  
  try mkdir -p ${STAGE_PATH}/lib/
  try cp $BUILD_PATH/jpeg/build-$ARCH/libjpeg.a ${STAGE_PATH}/lib/
  try mkdir -p ${STAGE_PATH}/include/
  try cp $BUILD_jpeg/frmts/jpeg/libjpeg/*.h ${STAGE_PATH}/include/

  pop_env
}

# function called after all the compile have been done
function postbuild_jpeg() {
    if [ ! -f ${STAGE_PATH}/lib/libjpeg.a ]; then
        error "Library was not successfully build for ${ARCH}"
        exit 1;
    fi
}
