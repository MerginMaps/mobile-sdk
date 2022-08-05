#!/bin/bash

# version of your package in ../../../versions.conf

# dependencies of this recipe
DEPS_libspatialite=(sqlite3 proj iconv freexl geos)

# default build path
BUILD_libspatialite=$BUILD_PATH/libspatialite/$(get_directory $URL_libspatialite)

# default recipe path
RECIPE_libspatialite=$RECIPES_PATH/libspatialite

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_libspatialite() {
  cd $BUILD_libspatialite

  # check marker
  if [ -f .patched ]; then
    return
  fi
    
  try cp $ROOT_OUT_PATH/.packages/config.sub $BUILD_libspatialite
  try cp $ROOT_OUT_PATH/.packages/config.guess $BUILD_libspatialite
  
  # try patch -p1 < $RECIPE_libspatialite/patches/configure.patch
  try patch -p1 < $RECIPE_libspatialite/patches/spatialite.patch
  
  touch .patched
}

function shouldbuild_libspatialite() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/libspatialite.a -nt $BUILD_libspatialite/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_libspatialite() {
  try rsync -a $BUILD_libspatialite/ $BUILD_PATH/libspatialite/build-$ARCH/
  try cd $BUILD_PATH/libspatialite/build-$ARCH
  push_arm

  # so the configure script can check that geos library is ok
  export LDFLAGS="$LDFLAGS -lgeos_c -lgeos"
  export LDFLAGS="$LDFLAGS -lproj -ltiff -lwebp"
  
  rm $BUILD_libspatialite/config.h
  rm $BUILD_libspatialite/src/headers/spatialite/gaiaconfig.h

  export CFLAGS="$CFLAGS -I$BUILD_PATH/libspatialite/build-$ARCH/src/headers"
  
  try $BUILD_libspatialite/configure \
    --prefix=$STAGE_PATH \
    --host=$TOOLCHAIN_PREFIX \
    --build=x86_64 \
    --target=android \
    --with-geosconfig=$STAGE_PATH/bin/geos-config \
    --enable-libxml2=no \
    --disable-examples \
    --enable-proj=yes \
    --enable-gcp=no \
    --enable-minizip=no \
    --disable-shared \
    --enable-rttopo=no \
    --enable-static=yes \
    --disable-dependency-tracking
  
  try $MAKESMP
  try $MAKESMP install
  pop_arm
}

# function called after all the compile have been done
function postbuild_libspatialite() {
    if [ ! -f ${STAGE_PATH}/lib/libspatialite.a ]; then
        error "Library was not successfully build for ${ARCH}"
        exit 1;
    fi
}
