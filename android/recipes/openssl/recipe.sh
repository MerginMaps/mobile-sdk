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
  
  DO_BUILD=1
}

# function called to build the source code
function build_openssl() {

  # Setup compiler toolchain based on CPU architecture
  if [ "X${ARCH}" == "Xarmeabi-v7a" ]; then
      export SSL_ARCH=android-arm
  elif [ "X${ARCH}" == "Xarm64-v8a" ]; then
      export SSL_ARCH=android-arm64
  elif [ "X${ARCH}" == "Xx86" ]; then
      export SSL_ARCH=android-x86
  elif [ "X${ARCH}" == "Xx86_64" ]; then
      export SSL_ARCH=android-x86_64
  else
      echo "Error: Please report issue to enable support for arch (${ARCH})."
      exit 1
  fi

  push_arm
  export CC=$TOOLCHAIN_FULL_PREFIX-clang
  export CFLAGS=""
  export ANDROID_NDK_HOME="$ANDROIDNDK"
  
  try $BUILD_openssl/Configure shared ${SSL_ARCH} -D__ANDROID_API__=$ANDROIDAPI --prefix=/
  ${MAKE} depend
  ${MAKE} DESTDIR=${STAGE_PATH} SHLIB_VERSION_NUMBER= build_libs

  # install
  try ${MAKE} SHLIB_VERSION_NUMBER= DESTDIR=$STAGE_PATH install_dev
  
  cd $STAGE_PATH/lib
  rm libcrypto.a
  rm libssl.a
  
  
  mv libcrypto.so libcrypto_3.so
  try patchelf --set-soname libcrypto_3.so libcrypto_3.so
  
  mv libssl.so libssl_3.so
  try patchelf --set-soname libssl_3.so libssl_3.so
  
  try patchelf --replace-needed libcrypto.so libcrypto_3.so libssl_3.so

  pop_arm
}

# function called after all the compile have been done
function postbuild_openssl() {
    if [ ! -f ${STAGE_PATH}/lib/libssl_3.so ]; then
        error "Library was not successfully build for ${ARCH}"
        exit 1;
    fi
}
