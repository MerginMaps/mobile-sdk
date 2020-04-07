#!/bin/bash

# version of your package
VERSION_qgis=3.13

# dependencies of this recipe
DEPS_qgis=(zlib gdal qca libspatialindex libspatialite expat postgresql libzip qtkeychain exiv2 geodiff protobuf)

# url of the package
URL_qgis=https://github.com/qgis/QGIS/archive/550cb5d809866f4a18adead61553e78243c734d4.tar.gz

# md5 of the package
MD5_qgis=732aad2348a445122fa30a91a0bdb6aa

# default build path
BUILD_qgis=$BUILD_PATH/qgis/$(get_directory $URL_qgis)

# default recipe path
RECIPE_qgis=$RECIPES_PATH/qgis

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_qgis() {
  true
}

# function called to build the source code
function build_qgis() {
  try mkdir -p $BUILD_PATH/qgis/build-$ARCH
  try cd $BUILD_PATH/qgis/build-$ARCH

  push_arm

  try $CMAKECMD \
    -DCMAKE_DISABLE_FIND_PACKAGE_HDF5=TRUE \
    -DWITH_DESKTOP=OFF \
    -DWITH_ANALYSIS=OFF \
    -DDISABLE_DEPRECATED=ON \
    -DWITH_QTWEBKIT=OFF \
    -DQT_LRELEASE_EXECUTABLE=`which lrelease` \
    -DFLEX_EXECUTABLE=`which flex` \
    -DBISON_EXECUTABLE=`which bison` \
    -DGDAL_CONFIG=$STAGE_PATH/bin/gdal-config \
    -DGDAL_CONFIG_PREFER_FWTOOLS_PAT=/bin_safe \
    -DGDAL_CONFIG_PREFER_PATH=$STAGE_PATH/bin \
    -DGDAL_INCLUDE_DIR=$STAGE_PATH/include \
    -DGDAL_LIBRARY=$STAGE_PATH/lib/libgdal.so \
    -DGEOS_CONFIG=$STAGE_PATH/bin/geos-config \
    -DGEOS_CONFIG_PREFER_PATH=$STAGE_PATH/bin \
    -DGEOS_INCLUDE_DIR=$STAGE_PATH/include \
    -DGEOS_LIBRARY=$STAGE_PATH/lib/libgeos_c.so \
    -DGEOS_LIB_NAME_WITH_PREFIX=-lgeos_c \
    -DICONV_INCLUDE_DIR=$STAGE_PATH/include \
    -DICONV_LIBRARY=$STAGE_PATH/lib/libiconv.so \
    -DSQLITE3_INCLUDE_DIR=$STAGE_PATH/include \
    -DSQLITE3_LIBRARY=$STAGE_PATH/lib/libsqlite3.so \
    -DPOSTGRES_CONFIG= \
    -DPOSTGRES_CONFIG_PREFER_PATH= \
    -DPOSTGRES_INCLUDE_DIR=$STAGE_PATH/include \
    -DPOSTGRES_LIBRARY=$STAGE_PATH/lib/libpq.so \
    -DPYTHON_EXECUTABLE=`which python3` \
    -DWITH_BINDINGS=OFF \
    -DWITH_GRASS=OFF \
    -DWITH_QTMOBILITY=OFF \
    -DWITH_QUICK=ON \
    -DQCA_INCLUDE_DIR=$STAGE_PATH/include/Qca-qt5/QtCrypto \
    -DQCA_LIBRARY=$STAGE_PATH/lib/libqca-qt5_$ARCH.so \
    -DQTKEYCHAIN_INCLUDE_DIR=$STAGE_PATH/include \
    -DQTKEYCHAIN_LIBRARY=$STAGE_PATH/lib/libqt5keychain_$ARCH.so \
    -DCMAKE_INSTALL_PREFIX:PATH=$STAGE_PATH \
    -DENABLE_QT5=ON \
    -DENABLE_TESTS=OFF \
    -DEXPAT_INCLUDE_DIR=$STAGE_PATH/include \
    -DEXPAT_LIBRARY=$STAGE_PATH/lib/libexpat.so \
    -DWITH_INTERNAL_QWTPOLAR=OFF \
    -DWITH_QWTPOLAR=OFF \
    -DWITH_GUI=OFF \
    -DSPATIALINDEX_LIBRARY=$STAGE_PATH/lib/libspatialindex.so \
    -DWITH_APIDOC=OFF \
    -DWITH_ASTYLE=OFF \
    -DWITH_QUICK=ON \
    -DWITH_QT5SERIALPORT=OFF \
    -DNATIVE_CRSSYNC_BIN=/usr/bin/true \
    -DProtobuf_PROTOC_EXECUTABLE=$NATIVE_STAGE_PATH/bin/protoc \
    -DProtobuf_INCLUDE_DIRS=$STAGE_PATH/include \
    -DProtobuf_PROTOC_LIBRARIES=$STAGE_PATH/lib/libprotoc.so \
    -DProtobuf_LIBRARIES=$STAGE_PATH/lib/libprotobuf.so \
    -DProtobuf_LITE_LIBRARIES=$STAGE_PATH/lib/libprotobuf-lite.so \
    -DWITH_QSPATIALITE=OFF \
    $BUILD_qgis

  try $MAKESMP install
  pop_arm
}

# function called after all the compile have been done
function postbuild_qgis() {
  true
}
