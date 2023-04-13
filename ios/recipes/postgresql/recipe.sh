#!/bin/bash

# version of your package in ../../../versions.conf

# dependencies of this recipe
DEPS_postgresql=()

# default build path
BUILD_postgresql=$BUILD_PATH/postgresql/$(get_directory $URL_postgresql)

# default recipe path
RECIPE_postgresql=$RECIPES_PATH/postgresql

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_postgresql() {
  cd $BUILD_postgresql

  # check marker
  if [ -f .patched ]; then
    return
  fi

  try cp $ROOT_OUT_PATH/.packages/config.sub $BUILD_postgresql/conftools
  try cp $ROOT_OUT_PATH/.packages/config.guess $BUILD_postgresql/conftools
  touch .patched
}

function shouldbuild_postgresql() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/libpq.a -nt $BUILD_postgresql/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_postgresql() {
  try mkdir -p $BUILD_PATH/postgresql/build-$ARCH
  try cd $BUILD_PATH/postgresql/build-$ARCH

  push_arm

  USE_DEV_URANDOM=1 \
  try $BUILD_postgresql/configure --prefix=$STAGE_PATH --host=${TOOLCHAIN_PREFIX} --without-readline --disable-shared
  try $MAKESMP -C src/interfaces/libpq

  #simulate make install
  echo "installing libpq"
  try cp -v $BUILD_postgresql/src/include/postgres_ext.h $STAGE_PATH/include
  try cp -v $BUILD_postgresql/src/interfaces/libpq/libpq-fe.h $STAGE_PATH/include
  try cp -v $BUILD_PATH/postgresql/build-$ARCH/src/include/pg_config_ext.h $STAGE_PATH/include/
  try cp -v $BUILD_PATH/postgresql/build-$ARCH/src/interfaces/libpq/libpq.a $STAGE_PATH/lib/
  try cp -v $BUILD_PATH/postgresql/build-$ARCH/src/common/libpgcommon.a $STAGE_PATH/lib/
  try cp -v $BUILD_PATH/postgresql/build-$ARCH/src/port/libpgport.a $STAGE_PATH/lib/
  
  pop_arm
}

# function called after all the compile have been done
function postbuild_postgresql() {
  LIB_ARCHS=`lipo -archs ${STAGE_PATH}/lib/libpq.a`
  if [[ $LIB_ARCHS != *"$ARCH"* ]]; then
    error "Library was not successfully build for ${ARCH}"
    exit 1;
  fi
}
