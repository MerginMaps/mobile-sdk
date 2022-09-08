#!/bin/bash

# version of your package in ../../../versions.conf

# dependencies of this recipe
DEPS_gdal=(proj libspatialite)

# default build path
BUILD_gdal=$BUILD_PATH/gdal/$(get_directory $URL_gdal)

# default recipe path
RECIPE_gdal=$RECIPES_PATH/gdal

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_gdal() {
  cd $BUILD_gdal

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_gdal() {
  # If lib is newer than the sourcecode skip build
  if [ $STAGE_PATH/lib/libgdal.so -nt $BUILD_gdal/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_gdal() {
  try rsync -a $BUILD_gdal/ $BUILD_PATH/gdal/build-$ARCH/
  try cd $BUILD_PATH/gdal/build-$ARCH

  push_env
  
  try ./configure \
    --prefix=$STAGE_PATH \
    --with-sqlite3=yes \
    --with-geos=yes \
    --with-pg=no \
    --with-expat=yes \
    --with-libtiff=yes \
    --with-geotiff=internal \
    --with-spatialite=$STAGE_PATH \
    --with-poppler=no \
    --with-odbc=no \
    --with-openjpeg=no \
    --with-gif=no \
    --with-webp=yes \
    --with-podofo=no \
    --with-pdfium=no \
    --with-curl=yes \
    --with-libxml2=no \
    --with-zstd=no \
    --with-pcre=no \
    --with-proj=$STAGE_PATH \
    --with-png=internal \
    --with-rename-internal-libpng-symbols=yes \
    --with-jpeg=internal \
    --with-rename-internal-libjpeg-symbols=yes \
    --with-lz4=no \
    --with-pcre2=no \
    --disable-driver-mrf \
    $GDAL_FLAGS
  
  try $MAKESMP
  try $MAKE install

  pop_env
}

# function called after all the compile have been done
function postbuild_gdal() {
    if [ ! -f ${STAGE_PATH}/lib/libgdal.so ]; then
        error "Library was not successfully build for ${ARCH}"
        exit 1;
    fi
}
