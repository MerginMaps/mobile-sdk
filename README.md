[![Build win64](https://github.com/MerginMaps/input-sdk/actions/workflows/win.yml/badge.svg)](https://github.com/MerginMaps/input-sdk/actions/workflows/win.yml)
[![Build macOS](https://github.com/merginmaps/input-sdk/actions/workflows/mac.yml/badge.svg)](https://github.com/merginmaps/input-sdk/actions/workflows/mac.yml)
[![Build iOS](https://github.com/merginmaps/input-sdk/actions/workflows/ios.yml/badge.svg)](https://github.com/merginmaps/input-sdk/actions/workflows/ios.yml)
[![Build android (on MacOS)](https://github.com/merginmaps/input-sdk/actions/workflows/android.yml/badge.svg)](https://github.com/merginmaps/input-sdk/actions/workflows/android.yml)
[![Build Linux](https://github.com/merginmaps/input-sdk/actions/workflows/linux.yml/badge.svg)](https://github.com/merginmaps/input-sdk/actions/workflows/linux.yml)

# input-sdk

SDK for building [Mergin Maps Input app](https://github.com/merginmaps/input) for mobile devices based on VCPG ecosystem

[Mergin Maps](http://merginmaps.com) makes surveying of geospatial data easy and it is powered by QGIS.

<div><img align="left" width="45" height="45" src="https://raw.githubusercontent.com/MerginMaps/docs/main/src/.vuepress/public/slack.svg"><a href="https://merginmaps.com/community/join">Join our community chat</a><br/>and ask questions!</div><br />

# Usage

Download, extract and use prebuild SDKs for various arch/platforms from Github Releases/Artefacts. 

# Release 
The release is automatically created from each build on master.

# Development

## Tips & Tricks

- look at `.github/workflows/<platform>.yml` to see how it is done in CI
- how to do diff `diff -rupN file.orig file`
- how to do diff from GIT `git diff master`
- find SHA512 hash for vcpkg: `shasum -a 512 myfile.tar.gz`
- list QT install options: `aqt list $QT_VERSION windows desktop`

## Android (on MacOS)

To build on Linux/Windows, adjust setup of deps from Linux build.

- Install SDK and NDK, Build Tools (version from `.github/workflows/android.yml`)
- Install XCode, Cmake, bison, flex, ...
```
  brew install cmake automake bison flex gnu-sed autoconf-archive libtool
```
- Qt (version from `.github/workflows/android.yml`); you need BOTH desktop (macos) and android installation!
- Install Vcpkg (git commit from `.github/workflows/android.yml`)
```
  mkdir -p build
  cd build
  git clone https://github.com/microsoft/vcpkg.git
  cd vcpkg 
  git checkout <git_commit>
  ./vcpkg/bootstrap-vcpkg.sh
  cd ..
  ```
- Download and prepare input-sdk
```
  git clone git@github.com:MerginMaps/input-sdk.git
```
- Configure input-sdk test app (this runs VCPKG install - can take few hours)
```
  mkdir -p build/arm64-android
  cd build/arm64-android
  
  export PATH=$(brew --prefix flex):$(brew --prefix bison)/bin:$(brew --prefix gettext)/bin:$PATH;\
  export PATH=`pwd`/../vcpkg:$PATH;\
  export Qt6_DIR=/opt/Qt/6.5.2/android_arm64_v8a;export QT_HOST_PATH=/opt/Qt/6.5.2/macos;\
  export ANDROIDAPI=21;\
  export NDK_VERSION='25.1.8937393';\
  export ANDROID_BUILD_TOOLS_VERSION='33.0.1';\
  export ANDROID_HOME='/opt/Android/android-sdk/'
  export ANDROID_NDK_HOME='/opt/Android/android-sdk/25.1.8937393/'
  
  cmake -B . -S ../../input-sdk/ \
    -DCMAKE_TOOLCHAIN_FILE=../vcpkg/scripts/buildsystems/vcpkg.cmake \
    -G Ninja \
    -DVCPKG_TARGET_TRIPLET=arm64-android \
    -DVCPKG_OVERLAY_TRIPLETS=../../input-sdk/vcpkg-overlay/triplets \
    -DVCPKG_OVERLAY_PORTS=../../input-sdk/vcpkg-overlay/ports \
    -DCMAKE_BUILD_TYPE=Release \
    -D ANDROID_SDK=${ANDROID_HOME} \
    -D ANDROID_SDK_ROOT=${ANDROID_HOME} \
    -D ANDROID_NDK_VERSION="${ANDROID_BUILD_TOOLS_VERSION}" \
    -D ANDROID_BUILD_TOOLS_VERSION="${ANDROID_BUILD_TOOLS_VERSION}" \
    -DCMAKE_MAKE_PROGRAM=ninja
```

- Build 
```
  cmake --build . --config Release
```

- Repeat with other android triplet (`arm-android.cmake` and QT installation `android_armv7`)

```
  mkdir -p build/arm-android
  cd build/arm-android
  
  export PATH=$(brew --prefix flex):$(brew --prefix bison)/bin:$(brew --prefix gettext)/bin:$PATH;\
  export PATH=`pwd`/../vcpkg:$PATH;\
  export Qt6_DIR=/opt/Qt/6.5.2/android_armv7;export QT_HOST_PATH=/opt/Qt/6.5.2/macos;\
  export ANDROIDAPI=21;\
  export NDK_VERSION='25.1.8937393';\
  export ANDROID_BUILD_TOOLS_VERSION='33.0.1';\
  export ANDROID_HOME='/opt/Android/android-sdk/';\
  export ANDROID_NDK_HOME='/opt/Android/android-sdk/ndk/25.1.8937393/'
  
  cmake -B . -S ../../input-sdk/ \
    -DCMAKE_TOOLCHAIN_FILE=../vcpkg/scripts/buildsystems/vcpkg.cmake \
    -G Ninja \
    -DVCPKG_TARGET_TRIPLET=arm-android \
    -DVCPKG_OVERLAY_TRIPLETS=../../input-sdk/vcpkg-overlay/triplets \
    -DVCPKG_OVERLAY_PORTS=../../input-sdk/vcpkg-overlay/ports \
    -DCMAKE_BUILD_TYPE=Release \
    -D ANDROID_SDK=${ANDROID_HOME} \
    -D ANDROID_SDK_ROOT=${ANDROID_HOME} \
    -D ANDROID_NDK_VERSION="${ANDROID_BUILD_TOOLS_VERSION}" \
    -D ANDROID_BUILD_TOOLS_VERSION="${ANDROID_BUILD_TOOLS_VERSION}" \
    -D ANDROID_NDK_HOME="${ANDROID_NDK_HOME}" \
    -D CMAKE_MAKE_PROGRAM=ninja
```

##  iOS

- Install XCode, Cmake, bison, flex, ...
```
  brew install cmake automake bison flex gnu-sed autoconf-archive libtool
```
- Qt (version from `.github/workflows/ios.yml`); you need BOTH desktop (macos) and ios installation!
- Install Vcpkg (git commit from `.github/workflows/ios.yml`)
```
  mkdir -p build
  cd build
  git clone https://github.com/microsoft/vcpkg.git
  cd vcpkg 
  git checkout <git_commit>
  ./vcpkg/bootstrap-vcpkg.sh
  cd ..
  ```
- Download and prepare input-sdk
```
  git clone git@github.com:MerginMaps/input-sdk.git
```
- Configure input-sdk test app (this runs VCPKG install - can take few hours) for particular triplet (`arm64-ios.cmake`)
```
  mkdir -p build/arm64-ios
  cd build/arm64-ios
  
  export PATH=$(brew --prefix flex)/bin:$(brew --prefix bison)/bin:$(brew --prefix gettext)/bin:$PATH;\
  export PATH=${PWD}/../vcpkg:$PATH;\
  export Qt6_DIR=/opt/Qt/6.5.2/ios;\
  export QT_HOST_PATH=/opt/Qt/6.5.2/macos;\
  export DEPLOYMENT_TARGET=14.0;

  cmake -B . -S ../../input-sdk/ \
    -DCMAKE_TOOLCHAIN_FILE=../vcpkg/scripts/buildsystems/vcpkg.cmake \
    -G "Xcode" \
    -DVCPKG_OVERLAY_TRIPLETS=../../input-sdk/vcpkg-overlay/triplets \
    -DVCPKG_OVERLAY_PORTS=../../input-sdk/vcpkg-overlay/ports \
    -DVCPKG_TARGET_TRIPLET=arm64-ios \
    -DCMAKE_BUILD_TYPE=Release \
    -D ENABLE_BITCODE=OFF \
    -D ENABLE_ARC=ON \
    -D CMAKE_SYSTEM_NAME=iOS \
    -D CMAKE_SYSTEM_PROCESSOR=aarch64 \
    -D CMAKE_CXX_VISIBILITY_PRESET=hidden \
    -DCMAKE_OSX_DEPLOYMENT_TARGET=${DEPLOYMENT_TARGET}
```

- Build 
```
  cmake --build . --config Release
```

## Windows

- install cmake, vcpkg, Visual Studio and Qt and add to PATH
```
set ROOT_DIR=C:\Users\Peter\repo
set BUILD_DIR=%ROOT_DIR%\build-sdk\win64
set SOURCE_DIR=%ROOT_DIR%\input-sdk
set VCPKG_ROOT=%ROOT_DIR%\vcpkg
set Qt6_DIR=C:\Qt\6.3.2\msvc2019_64
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
%BUILD_DIR%\Release\inputsdktest.exe
```

- the resulting build tree is then located at `%BUILD_DIR%\vcpkg_installed`

## MacOS

- Install XCode, Cmake, bison, flex, ...
```
  brew install cmake automake bison flex gnu-sed autoconf-archive libtool
```
- Qt (version from `.github/workflows/mac.yml`) 
- Install Vcpkg (git commit from `.github/workflows/mac.yml`)
```
  mkdir -p build
  cd build
  git clone https://github.com/microsoft/vcpkg.git
  cd vcpkg 
  git checkout <git_commit>
  ./vcpkg/bootstrap-vcpkg.sh
  cd ..
  ```
- Download and prepare input-sdk
```
  git clone git@github.com:MerginMaps/input-sdk.git
```
- Configure input-sdk test app (this runs VCPKG install - can take few hours) (for arm64 arch builds use `arm64-osx` TRIPLET)
```
  mkdir -p build/x64-osx
  cd build/x64-osx
  
  export PATH=$(brew --prefix flex)/bin:$(brew --prefix bison)/bin:$(brew --prefix gettext)/bin:$PATH;\
  export PATH=${PWD}/../vcpkg:$PATH;\
  export Qt6_DIR=/opt/Qt/6.5.2/macos;\
  export DEPLOYMENT_TARGET=10.15.0
  
  cmake -B . -S ../../input-sdk/ \
    -DCMAKE_TOOLCHAIN_FILE=../vcpkg/scripts/buildsystems/vcpkg.cmake \
    -G Ninja \
    -DVCPKG_TARGET_TRIPLET=x64-osx \
    -DVCPKG_OVERLAY_TRIPLETS=../../input-sdk/vcpkg-overlay/triplets \
    -DVCPKG_OVERLAY_PORTS=../../input-sdk/vcpkg-overlay/ports \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_MAKE_PROGRAM=ninja \
    -DCMAKE_OSX_DEPLOYMENT_TARGET=${DEPLOYMENT_TARGET}
```

- Build and run test app to verify your build
```
  cmake --build . --config Release
  ./merginmapsinputsdk
```

## Linux 

- Install ninja, cmake, bison, flex, ...
- Qt (version from `.github/workflows/linux.yml`) 
- Install Vcpkg (git commit from `.github/workflows/linux.yml`)
```
  mkdir -p build
  cd build
  git clone https://github.com/microsoft/vcpkg.git
  cd vcpkg 
  git checkout <git_commit>
  ./vcpkg/bootstrap-vcpkg.sh
  cd ..
  ```
- Download and prepare input-sdk
```
  git clone git@github.com:MerginMaps/input-sdk.git
```
- Configure input-sdk test app (this runs VCPKG install - can take few hours)
```
  mkdir -p build/x64-linux
  cd build/x64-linux
  
  export PATH=$(brew --prefix flex)/bin:$(brew --prefix bison)/bin:$(brew --prefix gettext)/bin:$PATH;\
  export PATH=${PWD}/../vcpkg:$PATH;\
  export Qt6_DIR=/opt/Qt/6.5.2/macos
  
  cmake -B . -S ../../input-sdk/ \
    -DCMAKE_TOOLCHAIN_FILE=../vcpkg/scripts/buildsystems/vcpkg.cmake \
    -G Ninja \
    -DVCPKG_TARGET_TRIPLET=x64-linux \
    -DVCPKG_OVERLAY_TRIPLETS=../../input-sdk/vcpkg-overlay/triplets \
    -DVCPKG_OVERLAY_PORTS=../../input-sdk/vcpkg-overlay/ports \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_MAKE_PROGRAM=ninja
```

- Build and run test app to verify your build
```
  cmake --build . --config Release
  ./merginmapsinputsdk
``` 

# License & Acknowledgement

The project use [vcpkg](https://github.com/microsoft/vcpkg/blob/master/LICENSE.txt) framework and build various open-source libraries to SDK as dependencies, 
including QGIS core library, GDAL, proj, geos and others.
