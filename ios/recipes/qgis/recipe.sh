#!/bin/bash

# version of your package in ../../../versions.conf

# dependencies of this recipe
DEPS_qgis=(exiv2 protobuf libtasn1 gdal qca proj libspatialite libspatialindex expat postgresql libzip qtkeychain geodiff zxing geodiff poly2tri)

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

  push_arm

  try ${CMAKECMD} \
    -DCMAKE_DISABLE_FIND_PACKAGE_HDF5=TRUE \
    -DWITH_DESKTOP=OFF \
    -DDISABLE_DEPRECATED=ON \
    -DWITH_QTWEBKIT=OFF \
    -DWITH_EPT=OFF \
    -DWITH_COPC=OFF \
    -DWITH_PDAL=OFF \
    -DFORCE_STATIC_LIBS=TRUE \
    -DQT_LRELEASE_EXECUTABLE=`which lrelease` \
    -DFLEX_EXECUTABLE=`which flex` \
    -DBISON_EXECUTABLE=`which bison` \
    -DWITH_AUTH=OFF \
    -DGDAL_CONFIG=$STAGE_PATH/bin/gdal-config \
    -DGDAL_CONFIG_PREFER_FWTOOLS_PAT=/bin_safe \
    -DGDAL_CONFIG_PREFER_PATH=$STAGE_PATH/bin \
    -DGDAL_INCLUDE_DIR=$STAGE_PATH/include \
    -DGDAL_LIBRARY=$STAGE_PATH/lib/libgdal.a \
    -DGDAL_VERSION=$VERSION_gdal \
    -DGEOS_CONFIG=$STAGE_PATH/bin/geos-config \
    -DGEOS_CONFIG_PREFER_PATH=$STAGE_PATH/bin \
    -DGEOS_INCLUDE_DIR=$STAGE_PATH/include \
    -DGEOS_LIBRARY=$STAGE_PATH/lib/libgeos_c.a \
    -DGEOS_LIB_NAME_WITH_PREFIX=-lgeos_c \
    -DGEOS_VERSION=$VERSION_geos \
    -DQCA_INCLUDE_DIR=$STAGE_PATH/include/Qca-qt6/QtCrypto \
    -DQCA_LIBRARY=$STAGE_PATH/lib/libqca-qt6.a \
    -DQCA_VERSION_STR=$VERSION_qca \
    -DPROJ_INCLUDE_DIR=$STAGE_PATH/include \
    -DPROJ_LIBRARY=$STAGE_PATH/lib/libproj.a \
    -DLIBTASN1_INCLUDE_DIR=$STAGE_PATH/include \
    -DLIBTASN1_LIBRARY=$STAGE_PATH/lib/libtasn1.a \
    -DLIBZIP_INCLUDE_DIR=$STAGE_PATH/include \
    -DLIBZIP_CONF_INCLUDE_DIR=$STAGE_PATH/include \
    -DLIBZIP_LIBRARY=$STAGE_PATH/lib/libzip.a \
    -DICONV_INCLUDE_DIR=$SYSROOT\
    -DICONV_LIBRARY=$SYSROOT/usr/lib/libiconv.tbd \
    -DSQLITE3_INCLUDE_DIR=$SYSROOT \
    -DSQLITE3_LIBRARY=$SYSROOT/usr/lib/libsqlite3.tbd \
    -DPOSTGRES_CONFIG= \
    -DPOSTGRES_CONFIG_PREFER_PATH= \
    -DPOSTGRES_INCLUDE_DIR=$STAGE_PATH/include \
    -DPOSTGRES_LIBRARY=$STAGE_PATH/lib/libpq.a \
    -DQTKEYCHAIN_INCLUDE_DIR=$STAGE_PATH/include/qt6keychain \
    -DQTKEYCHAIN_LIBRARY=$STAGE_PATH/lib/libqt6keychain.a \
    -DSPATIALINDEX_INCLUDE_DIR=$STAGE_PATH/include/spatialindex \
    -DSPATIALINDEX_LIBRARY=$STAGE_PATH/lib/libspatialindex.a \
    -DSPATIALITE_INCLUDE_DIR=$STAGE_PATH/include \
    -DSPATIALITE_LIBRARY=$STAGE_PATH/lib/libspatialite.a \
    -DPYTHON_EXECUTABLE=`which python3` \
    -DWITH_INTERNAL_POLY2TRI=FALSE \
    -DPoly2Tri_INCLUDE_DIR=$STAGE_PATH/include/poly2tri \
    -DPoly2Tri_LIBRARY=${QT_PATH}/lib/libQt6Bundled_Poly2Tri.a \
    -DWITH_QT5SERIALPORT=OFF \
    -DWITH_BINDINGS=OFF \
    -DWITH_INTERNAL_SPATIALITE=OFF \
    -DWITH_ANALYSIS=OFF \
    -DWITH_GRASS=OFF \
    -DWITH_GEOREFERENCER=OFF \
    -DWITH_QTMOBILITY=OFF \
    -DWITH_QUICK=OFF \
    -DCMAKE_INSTALL_PREFIX:PATH=$STAGE_PATH \
    -DBUILD_WITH_QT6=ON \
    -DENABLE_TESTS=OFF \
    -DEXIV2_INCLUDE_DIR=$STAGE_PATH/include \
    -DEXIV2_LIBRARY=$STAGE_PATH/lib/libexiv2.a \
    -DEXPAT_INCLUDE_DIR=$STAGE_PATH/include \
    -DEXPAT_LIBRARY=$STAGE_PATH/lib/libexpat.a \
    -DWITH_INTERNAL_QWTPOLAR=OFF \
    -DWITH_QWTPOLAR=OFF \
    -DWITH_GUI=OFF \
    -DWITH_APIDOC=OFF \
    -DWITH_ASTYLE=OFF \
    -DCMAKE_DISABLE_FIND_PACKAGE_QtQmlTools=TRUE \
    -DIOS=TRUE \
    -DLIBTIFF_LIBRARY=$STAGE_PATH/lib/libtiff.a \
    -DLIBTIFFXX_LIBRARY=$STAGE_PATH/lib/libtiffxx.a \
    -DFREEXL_LIBRARY=$STAGE_PATH/lib/libfreexl.a \
    -DCHARSET_LIBRARY=$STAGE_PATH/lib/libcharset.a \
    -DGEOSCXX_LIBRARY=$STAGE_PATH/lib/libgeos.a \
    -DWITH_QGIS_PROCESS=OFF \
    -DProtobuf_PROTOC_EXECUTABLE:FILEPATH=$NATIVE_STAGE_PATH/bin/protoc \
    -DProtobuf_INCLUDE_DIRS:PATH=$STAGE_PATH/include \
    -DProtobuf_LIBRARY=$STAGE_PATH/lib/libprotobuf.a \
    -DProtobuf_LITE_LIBRARY=$STAGE_PATH/lib/libprotobuf-lite.a \
    -DProtobuf_PROTOC_LIBRARY=$STAGE_PATH/lib/libprotoc.a \
    -DWITH_AUTH=ON \
    -DQGIS_MACAPP_BUNDLE=-1 \
    -DNATIVE_CRSSYNC_BIN=/usr/bin/true \
    $BUILD_qgis

  try $MAKESMP install

  # Why it is not copied by CMake?
  try cp $BUILD_PATH/qgis/build-$ARCH/src/core/qgis_core.h ${STAGE_PATH}/QGIS.app/Contents/Frameworks/qgis_core.framework/Headers/

  # bundle QGIS's find packages too
  try mkdir -p $STAGE_PATH/cmake/
  try cp -Rf $BUILD_qgis/cmake/* $STAGE_PATH/cmake/

  pop_arm
}

# function called after all the compile have been done
function postbuild_qgis() {
  # bundle QGIS's find packages too
  try mkdir -p $STAGE_PATH/cmake/
  try cp -Rf $BUILD_qgis/cmake/* $STAGE_PATH/cmake/
}
