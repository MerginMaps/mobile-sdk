#!/bin/bash

# version of your package in ../../version.conf

# dependencies of this recipe
DEPS_gdal=(geos postgresql expat)

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

  try cp $ROOT_OUT_PATH/.packages/config.sub "$BUILD_gdal"
  try cp $ROOT_OUT_PATH/.packages/config.guess "$BUILD_gdal"

  touch .patched
}

function shouldbuild_gdal() {
  # If lib is newer than the sourcecode skip build
  if [ $STAGE_PATH/lib/libgdal.a -nt $BUILD_gdal/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_gdal() {
  try rsync -a $BUILD_gdal/ $BUILD_PATH/gdal/build-$ARCH/
  try cd $BUILD_PATH/gdal/build-$ARCH

  push_env

  GDAL_FLAGS="--disable-shared"
  if [ $DEBUG -eq 1 ]; then
    info "Building DEBUG version of GDAL!!"
    GDAL_FLAGS="$GDAL_FLAGS --enable-debug"
  fi

  try ./configure \
    --prefix=$STAGE_PATH \
    --with-sqlite3=$STAGE_PATH \
    --with-geos=$STAGE_PATH/bin/geos-config \
    --with-pg=no \
    --with-expat=$STAGE_PATH \
    --with-rename-internal-libtiff-symbols=yes \
    --with-rename-internal-libgeotiff-symbols=yes \
    --with-rename-internal-shapelib-symbols=yes \
    --with-poppler=no \
    --with-podofo=no \
    --with-pdfium=no \
    --disable-driver-mrf \
    --with-jpeg=no \
    --with-proj=$STAGE_PATH \
    --with-png=no \
    $GDAL_FLAGS

  try $MAKESMP
  try make install

  pop_env
}

# function called after all the compile have been done
function postbuild_gdal() {
    if [ ! -f ${STAGE_PATH}/lib/libgdal.a ]; then
        error "Library was not successfully build for ${ARCH}"
        exit 1;
    fi
}
