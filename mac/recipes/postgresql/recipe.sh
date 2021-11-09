#!/bin/bash

# version of your package in ../../version.conf

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

  push_env

  patch_configure_file $BUILD_postgresql/configure
  
  USE_DEV_URANDOM=1 \
  try $BUILD_postgresql/configure --prefix=$STAGE_PATH --without-readline --disable-shared
  try $MAKESMP -C src/interfaces/libpq

  #simulate make install
  echo "installing libpq"
  try cp -v $BUILD_postgresql/src/include/postgres_ext.h $STAGE_PATH/include
  try cp -v $BUILD_postgresql/src/interfaces/libpq/libpq-fe.h $STAGE_PATH/include
  try cp -v $BUILD_PATH/postgresql/build-$ARCH/src/include/pg_config_ext.h $STAGE_PATH/include/
  try cp -v $BUILD_PATH/postgresql/build-$ARCH/src/interfaces/libpq/libpq.a $STAGE_PATH/lib/

  pop_env
}

# function called after all the compile have been done
function postbuild_postgresql() {
    if [ ! -f ${STAGE_PATH}/lib/libpq.a ]; then
        error "Library was not successfully build for ${ARCH}"
        exit 1;
    fi
}
