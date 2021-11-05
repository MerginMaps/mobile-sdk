#!/bin/bash

# version of your package in ../../version.conf

# dependencies of this recipe
DEPS_qgis=(exiv2 protobuf libtasn1 gdal qca proj libspatialite libspatialindex expat postgresql libzip qtkeychain geodiff qtlocation zxing)

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
  if [ ${STAGE_PATH}/QGIS.app/Contents/MacOS/lib/qgis_quick.framework/qgis_quick -nt $BUILD_qgis/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_qgis() {
  try mkdir -p $BUILD_PATH/qgis/build-$ARCH
  try cd $BUILD_PATH/qgis/build-$ARCH

  push_env

  try ${CMAKECMD} \
    -DQGIS_MAC_DEPS_DIR=$STAGE_PATH \
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
    -DQGIS_MACAPP_BUNDLE=-1 \
    -DFORCE_STATIC_LIBS=TRUE \
    $BUILD_qgis

  try $MAKESMP install

  try cp $BUILD_PATH/qgis/build-$ARCH/src/core/qgis_core.h ${STAGE_PATH}/QGIS.app/Contents/Frameworks/qgis_core.framework/Headers/

  # TODO
  # the installed QGIS references frameworks from build/qgis/build-mac/output/lib, see input/.github/workflows/autotests.yml

  # bundle QGIS's find packages too
  try mkdir -p $STAGE_PATH/cmake/
  try cp -Rf $BUILD_qgis/cmake/* $STAGE_PATH/cmake/

  pop_env
}

# function called after all the compile have been done
function postbuild_qgis() {
  :
}
