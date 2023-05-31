#!/bin/bash

# version of your package in ../../../versions.conf

# dependencies of this recipe
DEPS_openssl=()

# default build path
BUILD_openssl=$BUILD_PATH/openssl/$(get_directory $URL_openssl)

# function called for preparing source code if needed
function prebuild_openssl() {
  touch .patched
}

function shouldbuild_openssl() {
  # If lib is newer than the sourcecode skip build
  if [ $STAGE_PATH/lib/libssl_3.so -nt $BUILD_openssl/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_openssl() {
    cd $BUILD_openssl
    try mkdir -p ${STAGE_PATH}/include/openssl
    try mkdir -p ${STAGE_PATH}/lib
        
    try cp ssl_3/include/openssl/* ${STAGE_PATH}/include/openssl/
    try cp ssl_3/${ARCH}/libssl_3.so ${STAGE_PATH}/lib/
    try cp ssl_3/${ARCH}/libcrypto_3.so ${STAGE_PATH}/lib/
}

# function called after all the compile have been done
function postbuild_openssl() {
    if [ ! -f ${STAGE_PATH}/lib/libssl_3.so ]; then
        error "Library was not successfully build for ${ARCH}"
        exit 1;
    fi
}
