#!/bin/bash


# dependencies of this recipe
DEPS_libtiff=(webp libzip)


# default build path
BUILD_libtiff=$BUILD_PATH/libtiff/$(get_directory $URL_libtiff)

# default recipe path
RECIPE_libtiff=$RECIPES_PATH/libtiff


# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_libtiff() {
  cd $BUILD_libtiff

  # check marker
  if [ -f .patched ]; then
    return
  fi
  
  try patch -p1 < $RECIPE_libtiff/patches/notools.patch
  
  touch .patched
}

# function called before build_libtiff
# set DO_BUILD=0 if you know that it does not require a rebuild
function shouldbuild_libtiff() {
# If lib is newer than the sourcecode skip build
  if [ "${STAGE_PATH}/lib/libtiff.a" -nt $BUILD_libtiff/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_libtiff() {
  try mkdir -p $BUILD_PATH/libtiff/build-$ARCH
  try cd $BUILD_PATH/libtiff/build-$ARCH

  push_arm

  try $CMAKECMD \
   -DCMAKE_INSTALL_PREFIX:PATH=$STAGE_PATH \
   -DBUILD_SHARED_LIBS=OFF \
   -DWEBP_SUPPORT=BOOL:ON \
   -DLZMA_SUPPORT=BOOL:OFF \
   -DZSTD_SUPPORT=BOOL:OFF \
   -DZSTD_FOUND=OFF \
   -DLERC_SUPPORT=BOOL:OFF \
   -DJPEG_SUPPORT=BOOL:OFF \
   -DZIP_SUPPORT=BOOL:ON \
  -DBUILD_DOCS=OFF \
  -DBUILD_CONTRIB=OFF \
  -DBUILD_TESTS=OFF \
  -DCMAKE_DISABLE_FIND_PACKAGE_ZSTD=ON \
  -DCMAKE_DISABLE_FIND_PACKAGE_JPEG=ON \
  -DIOS=TRUE \
  $BUILD_libtiff
    
  try $MAKESMP install

  pop_arm
}

# function called after all the compile have been done
function postbuild_libtiff() {
    LIB_ARCHS=`lipo -archs ${STAGE_PATH}/lib/libtiff.a`
    if [[ $LIB_ARCHS != *"$ARCH"* ]]; then
      error "Library was not successfully build for ${ARCH}"
      exit 1;
    fi
}
