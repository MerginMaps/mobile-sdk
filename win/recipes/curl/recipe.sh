#!/bin/bash

# version of your package in ../../../versions.conf

# dependencies of this recipe
DEPS_curl=(openssl)

# default build path
BUILD_curl=$BUILD_PATH/curl/$(get_directory $URL_curl)

# default recipe path
RECIPE_curl=$RECIPES_PATH/curl

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_curl() {
  cd $BUILD_curl

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_curl() {
  # If lib is newer than the sourcecode skip build
  if [ $BUILD_PATH/curl/build-$ARCH/lib/libcurl.lib -nt $BUILD_curl/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_curl() {
  try mkdir -p $BUILD_PATH/curl/build-$ARCH
  try cd $BUILD_PATH/curl/build-$ARCH
  push_env
 
  # use Apple's SecureTransport, not OpenSSL
  try ${CMAKECMD} \
    -DBUILD_TESTING=OFF \
    -DBUILD_SHARED_LIBS=FALSE \
    -DBUILD_CURL_EXE=OFF \
    -DCURL_USE_LIBSSH2=OFF \
    -DCURL_USE_LIBSSH=OFF \
    -DCURL_ZSTD=OFF \
    -DCURL_BROTLI=OFF \
    -DCURL_DISABLE_LDAP=ON \
    -DCURL_USE_OPENLDAP=OFF \
    -DUSE_QUICHE=OFF \
    -DUSE_NGTCP2=OFF \
    -DUSE_NGHTTP2=OFF \
    -DCURL_ZLIB=OFF \
    -DCURL_USE_OPENSSL=ON \
    -DCURL_USE_SECTRANSP=OFF \
    $BUILD_curl
  
  check_file_configuration CMakeCache.txt
  
  try $MAKESMP
  try $MAKESMP install

  pop_env
}

# function called after all the compile have been done
function postbuild_curl() {
    if [ ! -f ${STAGE_PATH}/lib/libcurl.lib ]; then
        error "Library was not successfully build for ${ARCH}"
        exit 1;
    fi
}
