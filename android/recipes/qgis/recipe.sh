#!/bin/bash

# version of your package in ../../../versions.conf

# dependencies of this recipe
DEPS_qgis=(libtasn1 gdal qca libspatialindex libspatialite expat postgresql libzip qtkeychain exiv2 geodiff protobuf zxing)

# default build path
BUILD_qgis=$BUILD_PATH/qgis/$(get_directory $URL_qgis)

# default recipe path
RECIPE_qgis=$RECIPES_PATH/qgis

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
    if [ ${STAGE_PATH}/lib/libqgis_core.a -nt $BUILD_qgis/.patched ]; then
      DO_BUILD=0
    fi
}

# function called to build the source code
function build_qgis() {
  try mkdir -p $BUILD_PATH/qgis/build-$ARCH
  try cd $BUILD_PATH/qgis/build-$ARCH

  push_arm
      
  try $CMAKECMD \
    -DCMAKE_DISABLE_FIND_PACKAGE_HDF5=TRUE \
    -DWITH_DESKTOP=OFF \
    -DWITH_EPT=OFF \
    -DWITH_PDAL=OFF \
    -DWITH_COPC=OFF \
    -DWITH_ANALYSIS=OFF \
    -DDISABLE_DEPRECATED=ON \
    -DWITH_QTWEBKIT=OFF \
    -DFORCE_STATIC_LIBS=TRUE \
    -DQT_LRELEASE_EXECUTABLE=`which lrelease` \
    -DFLEX_EXECUTABLE=`which flex` \
    -DBISON_EXECUTABLE=`which bison` \
    -DGDAL_CONFIG=$STAGE_PATH/bin/gdal-config \
    -DGDAL_CONFIG_PREFER_FWTOOLS_PAT=/bin_safe \
    -DGDAL_CONFIG_PREFER_PATH=$STAGE_PATH/bin \
    -DGDAL_INCLUDE_DIR=$STAGE_PATH/include \
    -DGDAL_LIBRARY=$STAGE_PATH/lib/libgdal.a \
    -DGEOS_CONFIG=$STAGE_PATH/bin/geos-config \
    -DGEOS_CONFIG_PREFER_PATH=$STAGE_PATH/bin \
    -DGEOS_INCLUDE_DIR=$STAGE_PATH/include \
    -DGEOS_LIBRARY=$STAGE_PATH/lib/libgeos_c.a \
    -DGEOS_LIB_NAME_WITH_PREFIX=-lgeos_c \
    -DICONV_INCLUDE_DIR=$STAGE_PATH/include \
    -DICONV_LIBRARY=$STAGE_PATH/lib/libiconv.a \
    -DSQLITE3_INCLUDE_DIR=$STAGE_PATH/include \
    -DSQLITE3_LIBRARY=$STAGE_PATH/lib/libsqlite3.a \
    -DPOSTGRES_CONFIG= \
    -DPOSTGRES_CONFIG_PREFER_PATH= \
    -DPOSTGRES_INCLUDE_DIR=$STAGE_PATH/include \
    -DPOSTGRES_LIBRARY=$STAGE_PATH/lib/libpq.a \
    -DPYTHON_EXECUTABLE=`which python3` \
    -DWITH_BINDINGS=OFF \
    -DWITH_GRASS=OFF \
    -DWITH_GEOREFERENCER=OFF \
    -DWITH_QTMOBILITY=OFF \
    -DWITH_QUICK=OFF \
    -DLIBTASN1_INCLUDE_DIR=$STAGE_PATH/include \
    -DLIBTASN1_LIBRARY=$STAGE_PATH/lib/libtasn1.a \
    -DQCA_INCLUDE_DIR=$STAGE_PATH/include/Qca-qt6/QtCrypto \
    -DQCA_LIBRARY=$STAGE_PATH/lib/libqca-qt6.a \
    -DQTKEYCHAIN_INCLUDE_DIR=$STAGE_PATH/include/qt6keychain \
    -DQTKEYCHAIN_LIBRARY=$STAGE_PATH/lib/libqt6keychain.a \
    -DCMAKE_INSTALL_PREFIX:PATH=$STAGE_PATH \
    -DBUILD_WITH_QT6=ON \
    -DENABLE_TESTS=OFF \
    -DEXPAT_INCLUDE_DIR=$STAGE_PATH/include \
    -DEXPAT_LIBRARY=$STAGE_PATH/lib/libexpat.a \
    -DWITH_INTERNAL_QWTPOLAR=OFF \
    -DWITH_QWTPOLAR=OFF \
    -DWITH_GUI=OFF \
    -DSPATIALINDEX_LIBRARY=$STAGE_PATH/lib/libspatialindex.a \
    -DWITH_APIDOC=OFF \
    -DWITH_ASTYLE=OFF \
    -DWITH_QUICK=OFF \
    -DWITH_QTSERIALPORT=OFF \
    -DWITH_QT5SERIALPORT=OFF \
    -DWITH_3D=OFF \
    -DNATIVE_CRSSYNC_BIN=/usr/bin/true \
    -DWITH_QGIS_PROCESS=OFF \
    -DProtobuf_PROTOC_EXECUTABLE:FILEPATH=$NATIVE_STAGE_PATH/bin/protoc \
    -DProtobuf_INCLUDE_DIRS:PATH=$STAGE_PATH/include \
    -DProtobuf_LIBRARY=$STAGE_PATH/lib/libprotobuf.a \
    -DProtobuf_LITE_LIBRARY=$STAGE_PATH/lib/libprotobuf-lite.a \
    -DProtobuf_PROTOC_LIBRARY=$STAGE_PATH/lib/libprotoc.a \
    -DWITH_QSPATIALITE=OFF \
    $BUILD_qgis

  try $MAKESMP VERBOSE=1
  try $MAKESMP install
  pop_arm

  # bundle QGIS's find packages too
  try mkdir -p $STAGE_PATH/cmake/
  try cp -Rf $BUILD_qgis/cmake/* $STAGE_PATH/cmake/
}

# function called after all the compile have been done
function postbuild_qgis() {
  if [ ! -f ${STAGE_PATH}/lib/libqgis_core.a ]; then
      error "Library was not successfully build for ${ARCH}"
      exit 1;
  fi
}
