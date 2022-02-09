#!/bin/bash

# version of your package in ../../../versions.conf

# dependencies of this recipe
DEPS_gdal=(iconv sqlite3 geos postgresql expat proj webp libpng)

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
  
  # this is backporting https://github.com/OSGeo/gdal/commit/f3090267d5c30e4560df5cde7ee3c805a8a2ddab
  # to released 3.4.1
  try patch -p1 < $RECIPE_gdal/patches/jpeg_rename.patch
  
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
  # configure: error: 64-bit file I/O missing. Build will not support files larger than 4 GB.  
  if [ "X${ARCH}" == "Xarmeabi-v7a" ]; then
      GDAL_FLAGS="$GDAL_FLAGS --with-unix-stdio-64=no"
  fi
  
  export CFLAGS="${CFLAGS} -Wno-error=implicit-function-declaration"
  
  # this is backporting https://github.com/OSGeo/gdal/commit/f3090267d5c30e4560df5cde7ee3c805a8a2ddab
  # to released 3.4.1
  export CFLAGS="${CFLAGS} -DRENAME_INTERNAL_LIBJPEG_SYMBOLS"
  export CPPFLAGS="${CPPFLAGS} -DRENAME_INTERNAL_LIBJPEG_SYMBOLS"
  
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
    --with-rename-internal-libjpeg-symbols=yes \
    --with-poppler=no \
    --with-libxml2=no \
    --with-podofo=no \
    --with-pdfium=no \
    --with-jpeg=internal \
    --with-proj=$STAGE_PATH \
    --with-png=no \
    $GDAL_FLAGS

  try $MAKESMP lib-target
  try $MAKESMP install-lib

  pop_arm
}

# function called after all the compile have been done
function postbuild_gdal() {
    if [ ! -f ${STAGE_PATH}/lib/libgdal.a ]; then
        error "Library was not successfully build for ${ARCH}"
        exit 1;
    fi
}
