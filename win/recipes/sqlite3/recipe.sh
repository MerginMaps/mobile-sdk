#!/bin/bash

# version of your package in ../../../versions.conf

# dependencies of this recipe
DEPS_sqlite3=()

# default build path
BUILD_sqlite3=$BUILD_PATH/sqlite3/$(get_directory $URL_sqlite3)

# default recipe path
RECIPE_sqlite3=$RECIPES_PATH/sqlite3

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_sqlite3() {
  cd $BUILD_sqlite3

  # check marker
  if [ -f .patched ]; then
    return
  fi

  try cp $ROOT_OUT_PATH/.packages/config.sub $BUILD_sqlite3
  try cp $ROOT_OUT_PATH/.packages/config.guess $BUILD_sqlite3
  
  patch_configure_file configure
  
  touch .patched
}

function shouldbuild_sqlite3() {
  # If lib is newer than the sourcecode skip build
  if [ $STAGE_PATH/lib/libsqlite3.a -nt $BUILD_sqlite3/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_sqlite3() {
  try mkdir -p $BUILD_PATH/sqlite3/build-$ARCH
  try cd $BUILD_PATH/sqlite3/build-$ARCH

  push_env

  export CFLAGS="${CFLAGS} -DSQLITE_ENABLE_RTREE -DSQLITE_ENABLE_SESSION -DSQLITE_ENABLE_PREUPDATE_HOOK"
  export CFLAGS="${CFLAGS} -DSQLITE_ENABLE_COLUMN_METADATA=1 -DSQLITE_MAX_VARIABLE_NUMBER=250000 -DSQLITE_ENABLE_FTS3=1"
  export CFLAGS="${CFLAGS} -DSQLITE_ENABLE_FTS3_PARENTHESIS=1 -DSQLITE_ENABLE_JSON1=1"

  try $BUILD_sqlite3/configure \
    --prefix=$STAGE_PATH \
    --host=$TOOLCHAIN_PREFIX \
    --disable-shared \
    --enable-static

  # manual install
  try $MAKESMP install-libLTLIBRARIES
  try $MAKESMP install-includeHEADERS

  pop_env
}

# function called after all the compile have been done
function postbuild_sqlite3() {
    if [ ! -f ${STAGE_PATH}/lib/libsqlite3.a ]; then
        error "Library was not successfully build for ${ARCH}"
        exit 1;
    fi
}
