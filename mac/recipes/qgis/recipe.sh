#!/bin/bash

# version of your package
VERSION_qgis=3.16

# dependencies of this recipe
DEPS_qgis=(geodiff)

# url of the package
URL_qgis=https://github.com/qgis/QGIS/archive/981b8037c15e250d992e942d04f2728abe0add57.tar.gz

# md5 of the package
MD5_qgis=5b3b8456d92f426fffe37e352b47ff40

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
    -DQGIS_MAC_DEPS_DIR=$QGIS_DEPS \
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
