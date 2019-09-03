#!/bin/bash

# Well, build tools are available only on MacOS
if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "Building iOSGeo for iOS"
else
  echo "Unable to build iOS binaries on $OSTYPE"
  exit 1;
fi

XCODE_DEVELOPER="$(xcode-select -print-path)"
CORES=$(sysctl -n hw.ncpu)

# Load configuration
if [ "X$IOS_CONFIG" == "X" ]; then
    source `dirname $0`/config.conf
else
    source `dirname $0`/$IOS_CONFIG
fi

# Paths
ROOT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_OUT_PATH="${ROOT_PATH}/../build-ios"
STAGE_PATH="${ROOT_OUT_PATH}/stage/$ARCH"
RECIPES_PATH="$ROOT_PATH/recipes"
BUILD_PATH="${ROOT_OUT_PATH}/build"
LIBS_PATH="${ROOT_OUT_PATH}/build/libs"
PACKAGES_PATH="${PACKAGES_PATH:-$ROOT_OUT_PATH/.packages}"


MD5SUM=$(which md5sum)
if [ "X$MD5SUM" == "X" ]; then
  MD5SUM=$(which md5)
  if [ "X$MD5SUM" == "X" ]; then
    echo "Error: you need at least md5sum or md5 installed."
    exit 1
  else
    MD5SUM="$MD5SUM -r"
  fi
fi

WGET=$(which wget)
if [ "X$WGET" == "X" ]; then
  WGET=$(which curl)
  if [ "X$WGET" == "X" ]; then
    echo "Error: you need at least wget or curl installed."
    exit 1
  else
    WGET="$WGET -L -o"
  fi
  WHEAD="curl -L -I"
else
  WGET="$WGET -O"
  WHEAD="wget --spider -q -S"
fi

SED="sed -i ''"

AUTORECONF=$(which autoreconf)
if [ "X$AUTORECONF" == "X" ]; then
  echo "Error: you need autoreconf installed (brew install automake)."
  exit 1
fi

# Internals
CRED="\x1b[31;01m"
CBLUE="\x1b[34;01m"
CGRAY="\x1b[30;01m"
CRESET="\x1b[39;49;00m"
DO_CLEAN_BUILD=0
DO_SET_X=0
DEBUG=0

function try () {
    "$@" || exit -1
}

function info() {
  echo -e "$CBLUE"$@"$CRESET";
}

function error() {
  echo -e "$CRED"$@"$CRESET";
}

function debug() {
  echo -e "$CGRAY"$@"$CRESET";
}

function get_directory() {
  case $1 in
    *.tar.gz) directory=$(basename $1 .tar.gz) ;;
    *.tgz)    directory=$(basename $1 .tgz) ;;
    *.tar.bz2)  directory=$(basename $1 .tar.bz2) ;;
    *.tbz2)   directory=$(basename $1 .tbz2) ;;
    *.zip)    directory=$(basename $1 .zip) ;;
    *)
      error "Unknown file extension $1"
      exit -1
      ;;
  esac
  echo $directory
}

function push_arm() {
  info "Entering in ${ARCH} environment"

  # save for pop
  export OLD_PATH=$PATH
  export OLD_CFLAGS=$CFLAGS
  export OLD_CXXFLAGS=$CXXFLAGS
  export OLD_LDFLAGS=$LDFLAGS
  export OLD_CC=$CC
  export OLD_CXX=$CXX
  export OLD_MAKESMP=$MAKESMP
  export OLD_MAKE=$MAKE
  export OLD_LD=$LD
  export OLD_PLATFORM=$PLATFORM
  export OLD_SYSROOT=$SYSROOT
  export OLD_TOOLCHAIN_PREFIX=$TOOLCHAIN_PREFIX
  export OLD_CMAKECMD=$CMAKECMD

  if [ "$ARCH" == "i386" ] || [ "$ARCH" == "x86_64" ]; then
      SDK="iphonesimulator"
      if [ "$ARCH" == "x86_64" ]; then
          TARGET="darwin64-x86_64-cc"
          PLATFORM="SIMULATOR64"
      else
          TARGET="darwin-i386-cc"
          PLATFORM="SIMULATOR"
      fi
      VERSION_MIN="-mios-simulator-version-min=${IOS_MIN_SDK_VERSION}"
      echo "TODO: not tested!"
      exit 1
  else
      SDK="iphoneos"
      PLATFORM="OS"
      TARGET="iphoneos-cross"
      VERSION_MIN="-miphoneos-version-min=${IOS_MIN_SDK_VERSION}"
      VERSION_MIN="-miphoneos-version-min=${IOS_MIN_SDK_VERSION}"
  fi

  QT_PATH="$QT_BASE/ios"
  # Test QT libraries are compiled for this architecture
  QT_ARCHS=`lipo -archs ${QT_PATH}/lib/libQt5Core.a`
  if [[ $QT_ARCHS != *"$ARCH"* ]]; then
    error "${QT_PATH}/lib/libQt5Core.a is available only for $QT_ARCHS, not $ARCH"
    exit 1;
  fi

  export PLATFORM=${PLATFORM}
  export SYSROOT="$(xcrun --sdk $SDK --show-sdk-path)"
  if [ ! -d $SYSROOT ]; then
    error "unable to locate SDK $SDK"
    exit 1;
  fi

  # http://clang.llvm.org/docs/CrossCompilation.html#target-triple
  #  <arch><sub>-<vendor>-<sys>-<abi>
  if [ "${ARCH}" == "arm64" ];then
    export TOOLCHAIN_PREFIX=aarch64-apple-darwin
  else
    export TOOLCHAIN_PREFIX=$ARCH-apple-darwin
  fi

  CMAKE_TOOLCHAIN_FILE=$ROOT_PATH/tools/ios.toolchain.cmake
  export CFLAGS="-fobjc-nonfragile-abi -fobjc-legacy-dispatch -fPIC -arch ${ARCH} -isysroot $SYSROOT"
  # TODO QtCrypto to QGIS, libxml2 to ?
  export CFLAGS="${CFLAGS} -I$STAGE_PATH/include -I$SYSROOT/usr/include/libxml2 $VERSION_MIN"
  export LDFLAGS="-arch ${ARCH} -isysroot $SYSROOT -L$STAGE_PATH/lib $VERSION_MIN"
  export CXXFLAGS="${CFLAGS}"
  export PATH="$SYSROOT/usr/bin:${XCODE_DEVELOPER}/usr/bin:$QT_PATH/bin:${XCODE_DEVELOPER}/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin:$PATH"
  # search compiler in the path, to fail now instead of later.
  if hash ${XCODE_DEVELOPER}/usr/bin/gcc 2>/dev/null; then
    debug "Compiler found at $CC"
  else
    error "Unable to find compiler ${CC} !!"
    error "Ensure that XCode is installed"
    exit 1
  fi

  # make sure CFLAGS CPPFLAGS are in match with CMAKE settings from toolchain file
  CMAKECMD="cmake"
  if [ $DEBUG -eq 1 ]; then
    CMAKECMD="${CMAKECMD} -DCMAKE_BUILD_TYPE=Debug"
  else
    CMAKECMD="${CMAKECMD} -DCMAKE_BUILD_TYPE=RelWithDebInfo"
  fi
  CMAKECMD="${CMAKECMD} -DENABLE_VISIBILITY=1 -DIOS_ARCH=${ARCH} -IOS_PLATFORM=${PLATFORM}"
  CMAKECMD="${CMAKECMD} -DCMAKE_TOOLCHAIN_FILE=$CMAKE_TOOLCHAIN_FILE -DCMAKE_INSTALL_PREFIX:PATH=$STAGE_PATH"
  CMAKECMD="${CMAKECMD} -DIOS_SYSROOT=$SYSROOT -DIOS_DEPLOYMENT_TARGET=${IOS_MIN_SDK_VERSION} -DQT_PATH=$QT_PATH"
  CMAKECMD="$CMAKECMD -DCMAKE_PREFIX_PATH:PATH=$QT_PATH;$BUILD_PATH;$STAGE_PATH"

  if false; then
    CMAKECMD="${CMAKECMD} -DENABLE_BITCODE=1"
    CFLAGS="${CFLAGS} -fembed-bitcode"
  else
    CMAKECMD="${CMAKECMD} -DENABLE_BITCODE=0"
    CFLAGS="${CFLAGS} -headerpad_max_install_names"
  fi

  if true; then
    CMAKECMD="${CMAKECMD} -DENABLE_ARC=0"
    CFLAGS="${CFLAGS} -fno-objc-arc"
  else
    CMAKECMD="${CMAKECMD} -DENABLE_ARC=1"
    CFLAGS="${CFLAGS} -fobjc-arc"
  fi

  export CC="${XCODE_DEVELOPER}/usr/bin/gcc $CFLAGS"
  export CXX="${XCODE_DEVELOPER}/usr/bin/g++ $CXXFLAGS"
  export LD="${XCODE_DEVELOPER}/usr/bin/ld"
  export MAKESMP="${XCODE_DEVELOPER}/usr/bin/make -j$CORES"
  export MAKE="${XCODE_DEVELOPER}/usr/bin/make"
  export CFLAGS=$CFLAGS
  export CXXFLAGS="$CXXFLAGS"

  CMAKECMD="${CMAKECMD} -DCMAKE_C_COMPILER=${XCODE_DEVELOPER}/usr/bin/gcc"
  CMAKECMD="${CMAKECMD} -DCMAKE_CXX_COMPILER=${XCODE_DEVELOPER}/usr/bin/g++"

  export CMAKECMD=$CMAKECMD

}

function pop_arm() {
  info "Leaving ${ARCH} environment"
  export PATH=$OLD_PATH
  export CFLAGS=$OLD_CFLAGS
  export CXXFLAGS=$OLD_CXXFLAGS
  export LDFLAGS=$OLD_LDFLAGS
  export CC=$OLD_CC
  export CXX=$OLD_CXX
  export MAKESMP=$OLD_MAKESMP
  export MAKE=$OLD_MAKE
  export LD=$OLD_LD
  export PLATFORM=$OLD_PLATFORM
  export SYSROOT=$OLD_SYSROOT
  export TOOLCHAIN_PREFIX=$OLD_TOOLCHAIN_PREFIX
  export CMAKECMD=$OLD_CMAKECMD
}

function usage() {
  echo "iOSGeo - distribute.sh"
  echo
  echo "Usage:   ./distribute.sh [options]"
  echo
  echo "  -h                     Show this help"
  echo "  -l                     Show a list of available modules"
  echo "  -m 'mod1 mod2'         Modules to include"
  echo "  -f                     Restart from scratch (remove the current build)"
  echo "  -x                     display expanded values (execute 'set -x')"
  echo
  echo "For developers:"
  echo "  -u 'mod1 mod2'         Modules to update (if already compiled)"
  echo
  exit 0
}

function run_prepare() {
  info "Check environment"
  if [ "X$QT_BASE" == "X" ]; then
    error "No QT_BASE environment set, abort"
    exit -1
  fi

  if [ "X$IOS_MIN_SDK_VERSION" == "X" ]; then
    error "No IOS_MIN_SDK_VERSION environment set, abort"
    exit -1
  fi

  if [ "X$MODULES" == "X" ]; then
    usage
    exit 0
  fi


  info "QT located at $QT_BASE"
  info "IOS MIN SDK version is $IOS_MIN_SDK_VERSION"
  if [ "X$ARCH" == "Xi386" ] || [ "X$ARCH" == "Xx86_64" ]; then
      info "Building for iOSSimulator"
  else
      info "Building for iOS"
  fi

  info "Check mandatory tools"
  # ensure that some tools are existing
  for tool in tar bzip2 unzip; do
    which $tool &>/dev/null
    if [ $? -ne 0 ]; then
      error "Tool $tool is missing"
      exit -1
    fi
  done

  if [ $DO_CLEAN_BUILD -eq 1 ]; then
    info "Cleaning build"
    try rm -rf $STAGE_PATH
    try rm -rf $BUILD_PATH
  fi

  info "Distribution will be located at $STAGE_PATH"
  if [ -e "$STAGE_PATH" ]; then
    info "The directory $STAGE_PATH already exist"
    info "Will continue using and possibly overwrite what is in there"
  fi
  try mkdir -p "$STAGE_PATH"

  # create build directory if not found
  test -d $PACKAGES_PATH || mkdir -p $PACKAGES_PATH
  test -d $BUILD_PATH || mkdir -p $BUILD_PATH
  test -d $LIBS_PATH || mkdir -p $LIBS_PATH

  # check arm env
  push_arm
  pop_arm
}

function in_array() {
  term="$1"
  shift
  i=0
  for key in $@; do
    if [ $term == $key ]; then
      return $i
    fi
    i=$(($i + 1))
  done
  return 255
}

function run_source_modules() {
  # preprocess version modules
  needed=($MODULES)
  while [ ${#needed[*]} -ne 0 ]; do

    # pop module from the needed list
    module=${needed[0]}
    unset needed[0]
    needed=( ${needed[@]} )

    # is a version is specified ?
    items=( ${module//==/ } )
    module=${items[0]}
    version=${items[1]}
    if [ ! -z "$version" ]; then
      info "Specific version detected for $module: $version"
      eval "VERSION_$module=$version"
    fi
  done


  needed=($MODULES)
  declare -a processed
  declare -a pymodules
  processed=()

  fn_deps='.deps'
  fn_optional_deps='.optional-deps'

  > $fn_deps
  > $fn_optional_deps

  while [ ${#needed[*]} -ne 0 ]; do

    # pop module from the needed list
    module=${needed[0]}
    original_module=${needed[0]}
    unset needed[0]
    needed=( ${needed[@]} )

    # split the version if exist
    items=( ${module//==/ } )
    module=${items[0]}
    version=${items[1]}

    # check if the module have already been declared
    in_array $module "${processed[@]}"
    if [ $? -ne 255 ]; then
      debug "Ignored $module, already processed"
      continue;
    fi

    # add this module as done
    processed=( ${processed[@]} $module )

    # read recipe
    debug "Read $module recipe"
    recipe=$RECIPES_PATH/$module/recipe.sh
    if [ ! -f $recipe ]; then
      error "Recipe $module does not exist, adding the module as pure-python package"
      pymodules+=($original_module)
      continue;
    fi
    source $RECIPES_PATH/$module/recipe.sh

    # if a version has been specified by the user, the md5 will not
    # correspond at all. so deactivate it.
    if [ ! -z "$version" ]; then
      debug "Deactivate MD5 test for $module, due to specific version"
      eval "MD5_$module="
    fi

    # append current module deps to the needed
    deps=$(echo \$"{DEPS_$module[@]}")
    eval deps=($deps)
    optional_deps=$(echo \$"{DEPS_OPTIONAL_$module[@]}")
    eval optional_deps=($optional_deps)
    if [ ${#deps[*]} -gt 0 ]; then
      debug "Module $module depend on" ${deps[@]}
      needed=( ${needed[@]} ${deps[@]} )
      echo $module ${deps[@]} >> $fn_deps
    else
      echo $module >> $fn_deps
    fi
    if [ ${#optional_deps[*]} -gt 0 ]; then
      echo $module ${optional_deps[@]} >> $fn_optional_deps
    fi
  done

  info `pwd`
  MODULES="$($PYTHON tools/depsort.py --optional $fn_optional_deps < $fn_deps)"

  info "Modules changed to $MODULES"

  PYMODULES="${pymodules[@]}"

  info "Pure-Python modules changed to $PYMODULES"
}

function run_get_packages() {
  info "Run get packages"

  if [ ! -d "$ROOT_OUT_PATH/tmp" ]; then
    try mkdir $ROOT_OUT_PATH/tmp
    $WGET $ROOT_OUT_PATH/.packages/config.sub "http://git.savannah.gnu.org/cgit/config.git/plain/config.sub"
    $WGET $ROOT_OUT_PATH/.packages/config.guess "http://git.savannah.gnu.org/cgit/config.git/plain/config.guess"
  fi

  for module in $MODULES; do
    # download dependencies for this module
    # check if there is not an overload from environment
    module_dir=$(eval "echo \$O4iOS_${module}_DIR")
    if [ "$module_dir" ]
    then
      debug "\$O4iOS_${module}_DIR is not empty, linking $module_dir dir instead of downloading"
      directory=$(eval "echo \$BUILD_${module}")
      if [ -e $directory ]; then
        try rm -rf "$directory"
      fi
      try mkdir -p "$directory"
      try rmdir "$directory"
      try ln -s "$module_dir" "$directory"
      continue
    fi
    debug "Download package for $module"

    url="URL_$module"
    url=${!url}
    md5="MD5_$module"
    md5=${!md5}

    if [ ! -d "$BUILD_PATH/$module" ]; then
      try mkdir -p $BUILD_PATH/$module
    fi

    if [ ! -d "$PACKAGES_PATH/$module" ]; then
      try mkdir -p "$PACKAGES_PATH/$module"
    fi

    if [ "X$url" == "X" ]; then
      debug "No package for $module"
      continue
    fi

    filename=$(basename $url)
    marker_filename=".mark-$filename"
    do_download=1

    cd "$PACKAGES_PATH/$module"

    # check if the file is already present
    if [ -f $filename ]; then
      # if the marker has not been set, it might be cause of a invalid download.
      if [ ! -f $marker_filename ]; then
        rm $filename
      elif [ -n "$md5" ]; then
        # check if the md5 is correct
        current_md5=$($MD5SUM $filename | cut -d\  -f1)
        if [ "X$current_md5" == "X$md5" ]; then
          # correct, no need to download
          do_download=0
        else
          # invalid download, remove the file
          error "Module $module have invalid md5, redownload."
          rm $filename
        fi
      else
        do_download=0
      fi
    fi

    # check if the file HEAD in case of, only if there is no MD5 to check.
    check_headers=0
    if [ -z "$md5" ]; then
      if [ "X$DO_CLEAN_BUILD" == "X1" ]; then
        check_headers=1
      elif [ ! -f $filename ]; then
        check_headers=1
      fi
    fi

    if [ "X$check_headers" == "X1" ]; then
      debug "Checking if $url changed"
      $WHEAD $url &> .headers-$filename
      $PYTHON "$ROOT_PATH/tools/check_headers.py" .headers-$filename .sig-$filename
      if [ $? -ne 0 ]; then
        do_download=1
      fi
    fi

    # download if needed
    if [ $do_download -eq 1 ]; then
      info "Downloading $url"
      try rm -f $marker_filename
      try $WGET $filename $url
      touch $marker_filename
    else
      debug "Module $module already downloaded"
    fi

    # check md5
    if [ -n "$md5" ]; then
      current_md5=$($MD5SUM $filename | cut -d\  -f1)
      if [ "X$current_md5" != "X$md5" ]; then
        error "File $filename md5 check failed (got $current_md5 instead of $md5)."
        error "Ensure the file is correctly downloaded, and update MD5S_$module"
        exit -1
      fi
    fi

    # if already decompress, forget it
    cd $BUILD_PATH/$module
    directory=$(get_directory $filename)
    if [ -d "$directory" ]; then
      continue
    fi

    # decompress
    pfilename=$PACKAGES_PATH/$module/$filename
    info "Extract $pfilename"
    case $pfilename in
      *.tar.gz|*.tgz )
        try tar xzf $pfilename
        root_directory=$(basename $(try tar tzf $pfilename|head -n1))
        if [ "X$root_directory" != "X$directory" ]; then
          mv $root_directory $directory
        fi
        ;;
      *.tar.bz2|*.tbz2 )
        try tar xjf $pfilename
        root_directory=$(basename $(try tar tjf $pfilename|head -n1))
        if [ "X$root_directory" != "X$directory" ]; then
          mv $root_directory $directory
        fi
        ;;
      *.zip )
        try unzip $pfilename
        root_directory=$(basename $(try unzip -l $pfilename|sed -n 5p|awk '{print $4}'))
        if [ "X$root_directory" != "X$directory" ]; then
          mv $root_directory $directory
        fi
        ;;
    esac
  done
}

function run_prebuild() {
  info "Run prebuild"
  cd $BUILD_PATH
  for module in $MODULES; do
    fn=$(echo prebuild_$module)
    debug "Call $fn"
    $fn
  done
}

function run_build() {
  info "Run build"

  modules_update=($MODULES_UPDATE)

  cd $BUILD_PATH

  for module in $MODULES; do
    fn="build_$module"
    shouldbuildfn="shouldbuild_$module"
    MARKER_FN="$BUILD_PATH/.mark-$module"

    # if the module should be updated, then remove the marker.
    in_array $module "${modules_update[@]}"
    if [ $? -ne 255 ]; then
      debug "$module detected to be updated"
      rm -f "$MARKER_FN"
    fi

    # if shouldbuild_$module exist, call it to see if the module want to be
    # built again
    DO_BUILD=1
    if [ "$(type -t $shouldbuildfn)" == "function" ]; then
      $shouldbuildfn
    fi

    # if the module should be build, or if the marker is not present,
    # do the build
    if [ "X$DO_BUILD" == "X1" ] || [ ! -f "$MARKER_FN" ]; then
      debug "Call $fn"
      rm -f "$MARKER_FN"
      $fn
      touch "$MARKER_FN"
    else
      debug "Skipped $fn"
    fi
  done
}

function run_postbuild() {
  info "Run postbuild"
  cd $BUILD_PATH
  for module in $MODULES; do
    fn=$(echo postbuild_$module)
    debug "Call $fn"
    $fn
  done
}

function run() {
  for ARCH in ${ARCHES[@]}; do
    cd ${ROOT_PATH}
    STAGE_PATH="${ROOT_OUT_PATH}/stage/$ARCH"
    run_prepare
    run_source_modules
    run_get_packages
    run_prebuild
    run_build
    run_postbuild
  done
  info "All done !"
}

function list_modules() {
  modules=$(find recipes -iname 'recipe.sh' | cut -d/ -f2 | sort -u | xargs echo)
  echo "Available modules: $modules"
  exit 0
}

# Do the build
while getopts ":hvlfxim:u:s:g" opt; do
  case $opt in
    h)
      usage
      ;;
    l)
      list_modules
      ;;
    s)
      run_prepare
      run_source_modules
      push_arm
      bash
      pop_arm
      exit 0
      ;;
    i)
      INSTALL=1
      ;;
    g)
      DEBUG=1
      echo "Requesting debug binaries"
      ;;
    m)
      MODULES="$OPTARG"
      ;;
    u)
      MODULES_UPDATE="$OPTARG"
      ;;
    f)
      DO_CLEAN_BUILD=1
      ;;
    x)
      DO_SET_X=1
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;

    *)
      echo "=> $OPTARG"
      ;;
  esac
done

if [ $DO_SET_X -eq 1 ]; then
  info "Set -x for displaying expanded values"
  set -x
fi

run
