#!/bin/bash

# version of your package in ../../../versions.conf

# dependencies of this recipe
DEPS_qgis=(exiv2 protobuf libtasn1 gdal qca proj libspatialite libspatialindex expat postgresql libzip qtkeychain geodiff zxing geodiff)

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
  
  # remove when https://github.com/qgis/QGIS/pull/50866 is merged
  try patch -p1 < $RECIPE_qgis/patches/qt640.patch
  
  # remove when using qgis 3.30+
  try patch -p1 < $RECIPE_qgis/patches/geonode.patch
  
  touch .patched
}

function shouldbuild_qgis() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/QGIS.app/Contents/Frameworks/qgis_core.framework/qgis_core -nt $BUILD_qgis/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_qgis() {
  try mkdir -p $BUILD_PATH/qgis/build-$ARCH
  try cd $BUILD_PATH/qgis/build-$ARCH

  push_env
 
  # we want to produce CRSSYNC database here (at least somewhere)
  # so we can add it to release artefacts
  export LDFLAGS="$LDFLAGS -L$STAGE_PATH/lib -lgeodiff  -lproj -lZXing -lqt6keychain -lqca-qt6 -lgdal -lpq -lspatialite -lcharset -lxml2 -ltasn1 -lbz2 -lproj -lspatialindex -lgeos -lgeos_c -lprotobuf-lite -lexpat -lfreexl -lexiv2 -lexiv2-xmp -ltiff -lsqlite3 -liconv -lz -lzip -lwebp -ljpeg -lcurl -framework Security -framework CoreFoundation -framework SystemConfiguration"
  
  try ${CMAKECMD} \
    -DBUILD_WITH_QT6=ON \
    -DQGIS_MAC_DEPS_DIR=$STAGE_PATH \
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
    -DQGIS_MACAPP_BUNDLE=-1 \
    -DFORCE_STATIC_LIBS=TRUE \
    -DUSE_OPENCL=OFF \
    -DWITH_QT5SERIALPORT=OFF \
    -DPOSTGRES_INCLUDE_DIR=$STAGE_PATH/include \
    -DPOSTGRES_LIBRARY=$STAGE_PATH/lib/libpq.a \
    $BUILD_qgis
  
  check_file_configuration CMakeCache.txt
  
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
