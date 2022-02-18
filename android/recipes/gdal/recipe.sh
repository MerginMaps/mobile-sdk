#!/bin/bash

# version of your package in ../../../versions.conf

# dependencies of this recipe
DEPS_gdal=(iconv sqlite3 geos postgresql expat proj webp curl)

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

  try cp $ROOT_OUT_PATH/.packages/config.sub $BUILD_gdal
  try cp $ROOT_OUT_PATH/.packages/config.guess $BUILD_gdal
  
  try patch -p1 < $RECIPE_gdal/patches/configure.patch
  
  # this is backporting https://github.com/OSGeo/gdal/commit/f3090267d5c30e4560df5cde7ee3c805a8a2ddab to released 3.1.3
  try patch -p1 < $RECIPE_gdal/patches/jpeg_rename.patch
  try patch -p1 < $RECIPE_gdal/patches/png_rename.patch
   
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

  push_arm

  GDAL_FLAGS="--disable-shared"
  if [ $DEBUG -eq 1 ]; then
    info "Building DEBUG version of GDAL!!"
    GDAL_FLAGS="$GDAL_FLAGS --enable-debug"
  fi
  
  export CFLAGS="${CFLAGS} -Wno-error=implicit-function-declaration"
  
  # so the configure script can check that static libraries linkage is ok
  export LDFLAGS="$LDFLAGS -lgeos_c -lgeos -lcurl -lssl -lcrypto"
  
  # this is backporting https://github.com/OSGeo/gdal/commit/f3090267d5c30e4560df5cde7ee3c805a8a2ddab to released 3.1.3
  export CFLAGS="${CFLAGS} -DRENAME_INTERNAL_LIBJPEG_SYMBOLS"
  export CPPFLAGS="${CPPFLAGS} -DRENAME_INTERNAL_LIBJPEG_SYMBOLS"
  
  # Undefined symbols for architecture arm64: "_png_do_expand_palette_rgb8_neon"
  export CFLAGS="${CFLAGS} -DPNG_ARM_NEON_OPT=0"
  export CPPFLAGS="${CPPFLAGS} -DPNG_ARM_NEON_OPT=0"
  
  try ./configure \
    --host=$TOOLCHAIN_PREFIX \
    --build=x86_64 \
    --prefix=$STAGE_PATH \
    --with-sqlite3=$STAGE_PATH \
    --with-geos=$STAGE_PATH/bin/geos-config \
    --with-pg=no \
    --with-expat=$STAGE_PATH \
    --with-rename-internal-libtiff-symbols=yes \
    --with-rename-internal-libgeotiff-symbols=yes \
    --with-rename-internal-shapelib-symbols=yes \
    --with-poppler=no \
    --with-libxml2=no \
    --with-podofo=no \
    --with-pdfium=no \
    --with-proj=$STAGE_PATH \
    --with-png=internal \
    --disable-driver-mrf \
    $GDAL_FLAGS

  try $MAKESMP
  try $MAKESMP install

  pop_arm
}

# function called after all the compile have been done
function postbuild_gdal() {
    if [ ! -f ${STAGE_PATH}/lib/libgdal.a ]; then
        error "Library was not successfully build for ${ARCH}"
        exit 1;
    fi
}
