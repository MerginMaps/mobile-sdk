#!/bin/bash

# version of your package in ../../version.conf

# dependencies of this recipe
DEPS_qtlocation=()

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_qtlocation() {
  cd $BUILD_qtlocation

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_qtlocation() {
 if [ $STAGE_PATH/include/poly2tri/poly2tri.h -nt $BUILD_qtlocation/.patched ]; then
  DO_BUILD=0
 fi
}

# function called to build the source code
function build_qtlocation() {
  # library is already build in Qt distribution, we just need include files for QGIS
  try mkdir -p $STAGE_PATH/include/poly2tri
  rsync -zarv --include="*/" --include="*.h*" --exclude="*" \
    $BUILD_qtlocation/src/3rdparty/poly2tri/ \
    $STAGE_PATH/include/poly2tri/
}

# function called after all the compile have been done
function postbuild_qtlocation() {
  :
}