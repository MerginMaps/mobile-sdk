[![Build win64](https://github.com/MerginMaps/mobile-sdk/actions/workflows/win.yml/badge.svg)](https://github.com/MerginMaps/mobile-sdk/actions/workflows/win.yml)
[![Build macOS](https://github.com/merginmaps/mobile-sdk/actions/workflows/mac.yml/badge.svg)](https://github.com/merginmaps/mobile-sdk/actions/workflows/mac.yml)
[![Build macOS arm64](https://github.com/merginmaps/mobile-sdk/actions/workflows/mac_arm64.yml/badge.svg)](https://github.com/merginmaps/mobile-sdk/actions/workflows/mac_arm64.yml)
[![Build iOS](https://github.com/merginmaps/mobile-sdk/actions/workflows/ios.yml/badge.svg)](https://github.com/merginmaps/mobile-sdk/actions/workflows/ios.yml)
[![Build android (on MacOS)](https://github.com/merginmaps/mobile-sdk/actions/workflows/android.yml/badge.svg)](https://github.com/merginmaps/mobile-sdk/actions/workflows/android.yml)
[![Build Linux](https://github.com/merginmaps/mobile-sdk/actions/workflows/linux.yml/badge.svg)](https://github.com/merginmaps/mobile-sdk/actions/workflows/linux.yml)

# Mergin Maps mobile app SDK

SDK for building [Mergin Maps mobile app](https://github.com/merginmaps/mobile) for mobile devices based on VCPGK ecosystem

[Mergin Maps](http://merginmaps.com) makes surveying of geospatial data easy and it is powered by QGIS.

<div><img align="left" width="45" height="45" src="https://raw.githubusercontent.com/MerginMaps/docs/main/src/.vuepress/public/slack.svg"><a href="https://merginmaps.com/community/join">Join our community chat</a><br/>and ask questions!</div><br />

If you are up to building Mergin Maps mobile app, just download, extract and use prebuild SDKs for various arch/platforms from Github Releases/Artefacts.
The steps below are for development, debugging of the SDK itself or when you need to compile architecture not supported by current CI setup.

The release is automatically created for each commit on master for each triplet separately.

# Development Tips

- look at `.github/workflows/<platform>.yml` to see how it is done in CI
- how to do diff `diff -rupN file.orig file`
- how to do diff from GIT `git diff master`
- find SHA512 hash for vcpkg: `shasum -a 512 myfile.tar.gz`
- list QT install options: `aqt list $QT_VERSION windows desktop`

## clean local build (vcpkg)

- remove vcpkg and download from scratch
- clean/remove binary archive `$HOME/.cache/vcpkg/archives`

# how to update vcpkg baseline

- find a git commit hash you want to use on https://github.com/microsoft/vcpkg
- edit VCPKG_BASELINE file with the hash 

# how to update qt version

- run `scripts/update_qt_version.bash`

# Install

## Common steps (all platforms)

- Install bison, flex, cmake and add to PATH
- Install compiler setup for your platform (VS on win, gcc on lnx, XCode on macos) 
- Install Qt (version from `.github/workflows/ios.yml`). For iOS and Android you need BOTH host (e.g. macos) and target (e.g. ios) installation!
- Download and prepare mobile-sdk
```
  mkdir -p build
  cd build
  git clone git@github.com:MerginMaps/mobile-sdk.git
```
- Install vcpkg and checkout specific commit from VCPKG_BASELINE file
```
  mkdir -p build
  cd build
  git clone https://github.com/microsoft/vcpkg.git
  cd vcpkg
  VCPKG_TAG=`cat ../../mobile-sdk/VCPKG_BASELINE`
  git checkout ${VCPKG_TAG}
  ./bootstrap-vcpkg.sh
  cd ..
  ```

- continue with platform/target specific steps

## Android

- Install SDK and NDK, Build Tools (version from `.github/workflows/android.yml`)
- To build on Linux/Windows, adjust setup of deps from Linux build.

### android_arm64_v8a

- Configure mobile-sdk test app (this runs VCPKG install - can take few hours)
```
  mkdir -p build/arm64-android
  cd build/arm64-android
  
  brew install cmake automake bison flex gnu-sed autoconf-archive libtool
   
  export PATH=$(brew --prefix flex):$(brew --prefix bison)/bin:$(brew --prefix gettext)/bin:$PATH;\
  export PATH=`pwd`/../vcpkg:$PATH;\
  export Qt6_DIR=/opt/Qt/6.6.3/android_arm64_v8a;export QT_HOST_PATH=/opt/Qt/6.6.3/macos;\
  export ANDROIDAPI=24;\
  export ANDROID_NDK_HOME='/opt/Android/android-sdk/ndk/25.1.8937393';\
  export ANDROID_NDK_ROOT='/opt/Android/android-sdk/ndk/25.1.8937393';\
  export ANDROID_HOME='/opt/Android/android-sdk/';\
  export ANDROID_ABI='arm64-v8a'

  cmake -B . -S ../../mobile-sdk/ \
    -DCMAKE_TOOLCHAIN_FILE=../vcpkg/scripts/buildsystems/vcpkg.cmake \
    -DVCPKG_CHAINLOAD_TOOLCHAIN_FILE=${Qt6_DIR}/lib/cmake/Qt6/qt.toolchain.cmake \
    -G Ninja \
    -DVCPKG_TARGET_TRIPLET=arm64-android \
    -DVCPKG_OVERLAY_TRIPLETS=../../mobile-sdk/vcpkg-overlay/triplets \
    -DVCPKG_OVERLAY_PORTS=../../mobile-sdk/vcpkg-overlay/ports \
    -DCMAKE_BUILD_TYPE=Release \
    -D ANDROID_SDK_ROOT=${ANDROID_HOME} \
    -DCMAKE_MAKE_PROGRAM=ninja \
    -DANDROID_ARM_NEON=ON \
    -DANDROID_ABI=${ANDROID_ABI} \
    -DQT_ANDROID_ABIS=$ANDROID_ABI \
    -DANDROIDAPI=${ANDROIDAPI} \
    -DANDROID_PLATFORM=android-${ANDROIDAPI} \
    -DANDROID_NDK_PLATFORM=android-${ANDROIDAPI} \
    -DANDROID_STL="c++_shared"
```

- Build to verify your build
```
  cmake --build . --config Release
```

Note that this sdk application is dummy on this target and cannot be executed on any device.

### android_armv7

- Configure mobile-sdk test app (this runs VCPKG install - can take few hours)
```
  mkdir -p build/arm-android
  cd build/arm-android
  
  brew install cmake automake bison flex gnu-sed autoconf-archive libtool
  
  export PATH=$(brew --prefix flex):$(brew --prefix bison)/bin:$(brew --prefix gettext)/bin:$PATH;\
  export PATH=`pwd`/../vcpkg:$PATH;\
  export Qt6_DIR=/opt/Qt/6.6.3/android_armv7;\
  export QT_HOST_PATH=/opt/Qt/6.6.3/macos;\
  export ANDROIDAPI=24;\
  export ANDROID_NDK_HOME='/opt/Android/android-sdk/ndk/25.1.8937393';\
  export ANDROID_NDK_ROOT='/opt/Android/android-sdk/ndk/25.1.8937393';\
  export ANDROID_HOME='/opt/Android/android-sdk/';\
  export ANDROID_ABI=armeabi-v7a
  
  cmake -B . -S ../../mobile-sdk/ \
    -DCMAKE_TOOLCHAIN_FILE=../vcpkg/scripts/buildsystems/vcpkg.cmake \
    -DVCPKG_CHAINLOAD_TOOLCHAIN_FILE=${Qt6_DIR}/lib/cmake/Qt6/qt.toolchain.cmake \
    -G Ninja \
    -DVCPKG_TARGET_TRIPLET=arm-android \
    -DVCPKG_OVERLAY_TRIPLETS=../../mobile-sdk/vcpkg-overlay/triplets \
    -DVCPKG_OVERLAY_PORTS=../../mobile-sdk/vcpkg-overlay/ports \
    -DCMAKE_BUILD_TYPE=Release \
    -D ANDROID_SDK_ROOT=${ANDROID_HOME} \
    -D CMAKE_MAKE_PROGRAM=ninja \
    -DANDROID_ARM_NEON=ON \
    -DANDROID_ABI=${ANDROID_ABI} \
    -DQT_ANDROID_ABIS=${ANDROID_ABI} \
    -DANDROIDAPI=${ANDROIDAPI} \
    -DANDROID_PLATFORM=android-${ANDROIDAPI} \
    -DANDROID_NDK_PLATFORM=android-${ANDROIDAPI} \
    -DANDROID_STL="c++_shared"
```

- Build to verify your build
```
  cmake --build . --config Release --verbose
```

Note that this sdk application is dummy on this target and cannot be executed on any device.

##  iOS

- Configure mobile-sdk test app (this runs VCPKG install - can take few hours)
```
  mkdir -p build/arm64-ios
  cd build/arm64-ios
  
  brew install cmake automake bison flex gnu-sed autoconf-archive libtool
  
  export PATH=$(brew --prefix flex)/bin:$(brew --prefix bison)/bin:$(brew --prefix gettext)/bin:$PATH;\
  export PATH=${PWD}/../vcpkg:$PATH;\
  export Qt6_DIR=/opt/Qt/6.6.3/ios;\
  export QT_HOST_PATH=/opt/Qt/6.6.3/macos;\
  export DEPLOYMENT_TARGET=14.0;

  cmake -B . -S ../../mobile-sdk/ \
    -DCMAKE_TOOLCHAIN_FILE=../vcpkg/scripts/buildsystems/vcpkg.cmake \
    -G "Xcode" \
    -DVCPKG_OVERLAY_TRIPLETS=../../mobile-sdk/vcpkg-overlay/triplets \
    -DVCPKG_OVERLAY_PORTS=../../mobile-sdk/vcpkg-overlay/ports \
    -DVCPKG_TARGET_TRIPLET=arm64-ios \
    -DCMAKE_BUILD_TYPE=Release \
    -D ENABLE_BITCODE=OFF \
    -D ENABLE_ARC=OFF \
    -D CMAKE_SYSTEM_NAME=iOS \
    -D CMAKE_SYSTEM_PROCESSOR=aarch64 \
    -D CMAKE_CXX_VISIBILITY_PRESET=hidden \
    -DCMAKE_OSX_DEPLOYMENT_TARGET=${DEPLOYMENT_TARGET}
```

- Build to verify your build
```
  cmake --build . --config Release
```

Note that this sdk application is dummy on this target and cannot be executed on any device.

## Windows

- install cmake, vcpkg, Visual Studio and Qt and add to PATH
```
set ROOT_DIR=C:\Users\Peter\repo
set BUILD_DIR=%ROOT_DIR%\build-sdk\win64
set SOURCE_DIR=%ROOT_DIR%\mobile-sdk
set VCPKG_ROOT=%ROOT_DIR%\vcpkg
set Qt6_DIR=C:\Qt\6.6.3\msvc2019_64
set PATH=%VCPKG_ROOT%;%QT_ROOT%\bin;C:\Program Files\CMake\bin\;%PATH%
"C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\Tools\VsDevCmd.bat" -arch=x64
```

- run CMake to build deps (this runs VCPKG install - can take few hours)
```
cmake -B %BUILD_DIR% -S %SOURCE_DIR%\vcpkg-test `
"-DCMAKE_MODULE_PATH:PATH=%SOURCE_DIR%\vcpkg-test\cmake" `
"-DCMAKE_TOOLCHAIN_FILE=%VCPKG_ROOT%\scripts\buildsystems\vcpkg.cmake" `
-G "Visual Studio 16 2019" -A x64 -DVCPKG_TARGET_TRIPLET=x64-windows `
-DVCPKG_OVERLAY_TRIPLETS=%SOURCE_DIR%\vcpkg-overlay\triplets `
-DVCPKG_OVERLAY_PORTS=%SOURCE_DIR%\vcpkg-overlay\ports
```

- build executable and run tests 
```
cmake --build %BUILD_DIR% --config Release --verbose
%BUILD_DIR%\Release\merginmapsmobilesdk.exe
```

- the resulting build tree is then located at `%BUILD_DIR%\vcpkg_installed`

## MacOS

- Configure mobile-sdk test app (this runs VCPKG install - can take few hours) (for arm64 arch builds use `arm64-osx` TRIPLET)
```
  mkdir -p build/x64-osx
  cd build/x64-osx
  
  export PATH=$(brew --prefix flex)/bin:$(brew --prefix bison)/bin:$(brew --prefix gettext)/bin:$PATH;\
  export PATH=${PWD}/../vcpkg:$PATH;\
  export Qt6_DIR=/opt/Qt/6.6.3/macos;\
  export DEPLOYMENT_TARGET=10.15.0
  
  cmake -B . -S ../../mobile-sdk/ \
    -DCMAKE_TOOLCHAIN_FILE=../vcpkg/scripts/buildsystems/vcpkg.cmake \
    -G Ninja \
    -DVCPKG_TARGET_TRIPLET=x64-osx \
    -DVCPKG_OVERLAY_TRIPLETS=../../mobile-sdk/vcpkg-overlay/triplets \
    -DVCPKG_OVERLAY_PORTS=../../mobile-sdk/vcpkg-overlay/ports \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_MAKE_PROGRAM=ninja \
    -DCMAKE_OSX_DEPLOYMENT_TARGET=${DEPLOYMENT_TARGET}
```

- Build and run test app to verify your build
```
  cmake --build . --config Release
  ./merginmapsmobilesdk
```

## Linux 
- Configure mobile-sdk test app (this runs VCPKG install - can take few hours)
```
  mkdir -p build/x64-linux
  cd build/x64-linux
  
  export PATH=${PWD}/../vcpkg:$PATH
  export Qt6_DIR=~/Qt/6.6.3/gcc_64
  
  cmake -B . -S ../../mobile-sdk/ \
    -DCMAKE_TOOLCHAIN_FILE=../vcpkg/scripts/buildsystems/vcpkg.cmake \
    -G Ninja \
    -DVCPKG_TARGET_TRIPLET=x64-linux \
    -DVCPKG_OVERLAY_TRIPLETS=../../mobile-sdk/vcpkg-overlay/triplets \
    -DVCPKG_OVERLAY_PORTS=../../mobile-sdk/vcpkg-overlay/ports \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_MAKE_PROGRAM=ninja
```

- Build and run test app to verify your build
```
  cmake --build . --config Release
  ./merginmapsmobilesdk
``` 
