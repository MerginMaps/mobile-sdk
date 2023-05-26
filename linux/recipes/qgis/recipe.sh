#!/bin/bash

# version of your package in ../../../versions.conf

# dependencies of this recipe
DEPS_qgis=(geodiff zxing qca qtkeychain proj libspatialite gdal)

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
      -DBUILD_WITH_QT6=ON \
      -DWITH_BINDINGS=FALSE \
      -DWITH_DESKTOP=OFF \
      -DWITH_EPT=OFF \
      -DWITH_COPC=OFF \
      -DWITH_PDAL=OFF \
      -DWITH_ANALYSIS=OFF \
      -DDISABLE_DEPRECATED=ON \
      -DWITH_QTWEBKIT=OFF \
      -DWITH_QUICK=OFF \
      -DENABLE_TESTS=OFF \
      -DWITH_GUI=OFF \
      -DWITH_APIDOC=OFF \
      -DWITH_ASTYLE=OFF \
      -DWITH_QT5SERIALPORT=OFF \
      -DWITH_QSPATIALITE=OFF \
      -DWITH_3D=FALSE \
      -DWITH_QGIS_PROCESS=OFF \
      -DFORCE_STATIC_LIBS=TRUE \
      -DUSE_OPENCL=OFF \
      -DWITH_QT5SERIALPORT=OFF \
      -DGDAL_CONFIG=$STAGE_PATH/bin/gdal-config \
    $BUILD_qgis
  
  try $MAKESMP
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
