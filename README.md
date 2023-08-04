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

## Tips

- look at `.github/workflows/<platform>.yml` to see how it is done in CI
- how to do diff `diff -rupN file.orig file`
- how to do diff from GIT `git diff master`
- find SHA512 hash for vcpkg: `shasum -a 512 myfile.tar.gz`
- vcpkg clean build - remove `rm -rf ./vcpkg/buildtrees/ ./vcpkg/packages/`

## Android 

TODO

# Windows

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

- run CMake to build deps and test project
```
cmake -B %BUILD_DIR% -S %SOURCE_DIR%\vcpkg-test "-DCMAKE_MODULE_PATH:PATH=%SOURCE_DIR%\vcpkg-test\cmake" "-DCMAKE_TOOLCHAIN_FILE=%VCPKG_ROOT%\scripts\buildsystems\vcpkg.cmake" -G "Visual Studio 16 2019" -A x64 -DVCPKG_TARGET_TRIPLET=x64-windows -DVCPKG_OVERLAY_TRIPLETS=%SOURCE_DIR%\vcpkg-overlay\triplets -DVCPKG_OVERLAY_PORTS=%SOURCE_DIR%\vcpkg-overlay\ports
cmake --build %BUILD_DIR% --config Release --verbose
```

- run tests 
```
%BUILD_DIR%\Release\inputsdktest.exe
```

- the resulting build tree is then located at `%BUILD_DIR%\vcpkg_installed`

##  iOS

TODO 

## MacOS

- Install Cmake, bison, flex, ...
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
  cd ..
  ```
- Download and prepare input-sdk
```
  git clone git@github.com:MerginMaps/input-sdk.git
```
- Configure input-sdk test app (this runs VCPKG install - can take few hours)
```
  mkdir -p build/x64
  cd build/x64
  export Qt6_DIR=/opt/Qt/6.5.2/macos;export PATH=$(brew --prefix flex):$(brew --prefix bison)/bin:$PATH
  
  cmake -B . -S ../../input-sdk/ \
    -DCMAKE_TOOLCHAIN_FILE=../vcpkg/scripts/buildsystems/vcpkg.cmake \
    -G Ninja \
    -DVCPKG_TARGET_TRIPLET=x64-osx \
    -DVCPK_OVERLAY_TRIPLETS=../../input-sdk/vcpkg-overlay/triplets \
    -DVCPKG_OVERLAY_PORTS=../../input-sdk/vcpkg-overlay/ports \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_MAKE_PROGRAM=ninja
```

- Build and run test app to verify your build
```
  cmake --build . --config Release
```

## Linux 

TODO 

# License & Acknowledgement

The project use [vcpkg](https://github.com/microsoft/vcpkg/blob/master/LICENSE.txt) framework and build various open-source libraries to SDK as dependencies, 
including QGIS core library, GDAL, proj, geos and others.
