#!/bin/bash

# version of your package in ../../../versions.conf

# dependencies of this recipe
DEPS_gdal=(geos postgresql jpeg expat proj exiv2 freexl libspatialite libspatialindex libtasn1 libzip sqlite3 webp curl libtiff)

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
  
  try patch -p1 < $RECIPE_gdal/patches/configure.patch
  
  patch_configure_file configure

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
  
  # so the configure script can check that proj library is ok
  export LDFLAGS="$LDFLAGS -lgeos -lproj -lsqlite3 -lcurl -ltiff -ljpeg -lwebp -lz -framework Security -framework CoreFoundation -framework SystemConfiguration -lc++"
  
  # We have external JPEG, but still with renamed symbols
  export CFLAGS="${CFLAGS} -DRENAME_INTERNAL_LIBJPEG_SYMBOLS"
  export CPPFLAGS="${CPPFLAGS} -DRENAME_INTERNAL_LIBJPEG_SYMBOLS"
  
  try ./configure \
    --prefix=$STAGE_PATH \
    --with-sqlite3=$STAGE_PATH \
    --with-geos=$STAGE_PATH/bin/geos-config \
    --with-pg=no \
    --with-expat=$STAGE_PATH \
    --with-libtiff=$STAGE_PATH \
    --with-geotiff=internal \
    --with-spatialite=yes \
    --with-poppler=no \
    --with-odbc=no \
    --with-openjpeg=no \
    --with-gif=no \
    --with-webp=$STAGE_PATH \
    --with-podofo=no \
    --with-pdfium=no \
    --with-curl=$STAGE_PATH \
    --with-libxml2=no \
    --with-zstd=no \
    --with-pcre=no \
    --with-proj=$STAGE_PATH \
    --with-png=internal \
    --with-rename-internal-libpng-symbols=yes \
    --with-lz4=no \
    --with-pcre2=no \
    --with-heif=no \
    --with-exr=no \
    --with-crypto=no \
    --with-jpeg=$STAGE_PATH \
    --disable-driver-mrf \
    $GDAL_FLAGS
  
  try $MAKESMP
  try $MAKESMP install

  $STAGE_PATH/bin/gdalinfo --formats | tee -a $STAGE_PATH/supported_formats.log
  $STAGE_PATH/bin/ogrinfo --formats | tee -a $STAGE_PATH/supported_formats.log
  
  pop_env
}

# function called after all the compile have been done
function postbuild_gdal() {
    if [ ! -f ${STAGE_PATH}/lib/libgdal.a ]; then
        error "Library was not successfully build for ${ARCH}"
        exit 1;
    fi
}
