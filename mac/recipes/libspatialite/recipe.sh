#!/bin/bash

# version of your package in ../../version.conf

# dependencies of this recipe
DEPS_libspatialite=(proj freexl geos)

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

  try cp $ROOT_OUT_PATH/.packages/config.sub "$BUILD_libspatialite"
  try cp $ROOT_OUT_PATH/.packages/config.guess "$BUILD_libspatialite"
  
  patch_configure_file configure
  
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
  try mkdir -p $BUILD_PATH/libspatialite/build-$ARCH
  try cd $BUILD_PATH/libspatialite/build-$ARCH

  push_env

  # Use Proj 6.0.0 compatibility headers.
  # Remove in libspatialite 5.0.0
  export CFLAGS="$CFLAGS -DACCEPT_USE_OF_DEPRECATED_PROJ_API_H=1"
  # so the configure script can check that proj library contains pj_init_plus
  export LDFLAGS="$LDFLAGS -lc++ -lgeos"
  # so the configure script can check that geos library is ok
  export LDFLAGS="$LDFLAGS -lgeos"
  
  try $BUILD_libspatialite/configure \
    --prefix=$STAGE_PATH \
    --with-geosconfig=$STAGE_PATH/bin/geos-config \
    --enable-libxml2=no \
    --disable-shared \
    --disable-examples \
    --enable-proj=yes \
    --enable-static=yes


  try $MAKESMP
  try make install &> install.log

  pop_env
}

# function called after all the compile have been done
function postbuild_libspatialite() {
    if [ ! -f ${STAGE_PATH}/lib/libspatialite.a ]; then
        error "Library was not successfully build for ${ARCH}"
        exit 1;
    fi
}
