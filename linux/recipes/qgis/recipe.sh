#!/bin/bash

# version of your package in ../../version.conf

# dependencies of this recipe
DEPS_qgis=(geodiff zxing)

# default build path
BUILD_qgis=$BUILD_PATH/qgis/$(get_directory $URL_qgis)

# default recipe path
RECIPE_qgis=$RECIPES_PATH/qgis

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_qgis() {
  cd $BUILD_qgis
  # check marker
  if [ -f .patched ]; then
    return
  fi
  
  touch .patched
}

function shouldbuild_qgis() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/libqgis_core.a -nt $BUILD_qgis/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_qgis() {
  try mkdir -p $BUILD_PATH/qgis/build-$ARCH
  try cd $BUILD_PATH/qgis/build-$ARCH

  push_env

  try ${CMAKECMD} \
    -DWITH_BINDINGS=FALSE \
    -DWITH_DESKTOP=OFF \
    -DWITH_EPT=OFF \
    -DWITH_PDAL=OFF \
    -DWITH_ANALYSIS=OFF \
    -DDISABLE_DEPRECATED=ON \
    -DWITH_QTWEBKIT=OFF \
    -DWITH_GRASS=OFF \
    -DWITH_GEOREFERENCER=OFF \
    -DWITH_QTMOBILITY=OFF \
    -DWITH_QUICK=OFF \
    -DENABLE_QT5=ON \
    -DENABLE_TESTS=OFF \
    -DWITH_INTERNAL_QWTPOLAR=OFF \
    -DWITH_QWTPOLAR=OFF \
    -DWITH_GUI=OFF \
    -DWITH_APIDOC=OFF \
    -DWITH_ASTYLE=OFF \
    -DWITH_QT5SERIALPORT=OFF \
    -DWITH_QSPATIALITE=OFF \
    -DWITH_3D=FALSE \
    -DWITH_QGIS_PROCESS=OFF \
    -DFORCE_STATIC_LIBS=TRUE \
    -DUSE_OPENCL=OFF \
    $BUILD_qgis
  
  try $MAKESMP install

  pop_env
}

# function called after all the compile have been done
function postbuild_qgis() {
    if [ ! -f ${STAGE_PATH}/lib/libqgis_core.a ]; then
        error "Library was not successfully build for ${ARCH}"
        exit 1;
    fi
}
