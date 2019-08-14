#!/bin/bash

# version of your package
# NOTE: if changed, update also qgis's recipe
VERSION_qca=2.1.0

# dependencies of this recipe
DEPS_qca=()

# url of the package
# URL_qca=http://delta.affinix.com/download/qca/2.0/qca-${VERSION_qca}.tar.gz
# URL_qca=http://quickgit.kde.org/?p=qca.git&a=snapshot&h=4f966b0217c10b6fd3c12caf7d2467759fbec7f7&fmt=tgz
URL_qca=https://github.com/KDE/qca/archive/v${VERSION_qca}.tar.gz

# md5 of the package
MD5_qca=b1b8ffad920c4cb3c286bcf34a83f76b

# default build path
BUILD_qca=$BUILD_PATH/qca/$(get_directory $URL_qca)

# default recipe path
RECIPE_qca=$RECIPES_PATH/qca

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_qca() {
  cd $BUILD_qca
  # check marker
  if [ -f .patched ]; then
    return
  fi

  try patch --verbose --forward -p1 < $RECIPE_qca/patches/qca_qio.patch
  try patch --verbose --forward -p1 < $RECIPE_qca/patches/qca_console.patch
  try patch -p1 < $RECIPE_qca/patches/cxx11.patch
  try patch -p1 < $RECIPE_qca/patches/src.patch

  touch .patched
}

function shouldbuild_qca() {
 # If lib is newer than the sourcecode skip build
 if [ $BUILD_qca/build-$ARCH/lib/libqca-qt5.a -nt $BUILD_qca/.patched ]; then
  DO_BUILD=0
 fi
}

# function called to build the source code
function build_qca() {
 try mkdir -p $BUILD_qca/build-$ARCH
 try cd $BUILD_qca/build-$ARCH

 push_arm

 # configure
 try ${CMAKECMD} \
  -DQT4_BUILD=OFF \
  -DQCA_SUFFIX=qt5 \
  -DBUILD_TESTS=OFF \
  -DBUILD_TOOLS=OFF \
  -DWITH_nss_PLUGIN=OFF \
  -DWITH_pkcs11_PLUGIN=OFF \
  -DWITH_gnupg_PLUGIN=OFF \
  -DOSX_FRAMEWORK=OFF \
  -DCMAKE_DISABLE_FIND_PACKAGE_Doxygen=TRUE \
  -DLIBRARY_TYPE=STATIC \
  $BUILD_qca
 try $MAKESMP install

 pop_arm
}

# function called after all the compile have been done
function postbuild_qca() {
  LIB_ARCHS=`lipo -archs ${STAGE_PATH}/lib/libqca-qt5.a`
  if [[ $LIB_ARCHS != *"$ARCH"* ]]; then
    error "Library was not successfully build for ${ARCH}"
    exit 1;
  fi
}
