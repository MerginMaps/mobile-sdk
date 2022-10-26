[![Build win64](https://github.com/MerginMaps/input-sdk/actions/workflows/win.yml/badge.svg)](https://github.com/MerginMaps/input-sdk/actions/workflows/win.yml)
[![Build macOS](https://github.com/merginmaps/input-sdk/actions/workflows/mac.yml/badge.svg)](https://github.com/merginmaps/input-sdk/actions/workflows/mac.yml)
[![Build iOS](https://github.com/merginmaps/input-sdk/actions/workflows/ios.yml/badge.svg)](https://github.com/merginmaps/input-sdk/actions/workflows/ios.yml)
[![Build android (on MacOS)](https://github.com/merginmaps/input-sdk/actions/workflows/android.yml/badge.svg)](https://github.com/merginmaps/input-sdk/actions/workflows/android.yml)
[![Build Linux](https://github.com/merginmaps/input-sdk/actions/workflows/linux.yml/badge.svg)](https://github.com/merginmaps/input-sdk/actions/workflows/linux.yml)

# input-sdk

SDK for building [Mergin Maps Input app](https://github.com/merginmaps/input) for mobile devices

Mergin Maps Input app makes surveying of geospatial data easy. You can design your survey project in QGIS with custom forms.

Click here to download the app on your Android or iOS devices [merginmaps.com](http://merginmaps.com)

<div><img align="left" width="45" height="45" src="https://raw.githubusercontent.com/MerginMaps/docs/main/src/.vuepress/public/slack.svg"><a href="https://merginmaps.com/community/join">Join our community chat</a><br/>and ask questions!</div><br />

# Tips

- how to do diff `diff -rupN file.orig file`
- find SHA512 hash (vcpkg): `shasum -a 512 myfile.tar.gz`

# Android 

Download prebuild android SDKs from the GitHub Artifacts

# Windows

You can download prebuild android SDKs from the GitHub Artifacts. If you want local build, you should:

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

# iOS

Download prebuild iOS SDKs from the GitHub Artifacts

## Manual Build
1. you need to have Qt installed
2. copy and modify config.conf.default to config.conf with your setup
3. run `distribute.sh -mqgis`

- if you want armv7 and different SDK, you may try to build QT yourself (not tested)
- all libraries are STATIC, due to some limitation for iOS platform (distribution on AppStore, Qt
distribution for iOS, etc.)
- sometimes you need to debug from XCode (generated project); use RelWithDb, not full debug build

# MacOS

Download prebuild mac SDKs from the GitHub Artifacts

## Manual Build
1. you need to have Qt installed (with Qt Connectivity, Qt Multimedia, Qt Positioning, Qt Sensort, Qt5 Compatibility Module)
2. copy and modify config.conf.default to config.conf with your setup
3. run `distribute.sh -mqgis`

# Linux 

We use Ubuntu LTS for building. Download prebuild ubuntu SDKs from the GitHub Artifacts

## Manual Build
1. you need to have Qt installed (with Qt Connectivity, Qt Multimedia, Qt Positioning, Qt Sensort, Qt5 Compatibility Module)
2. Check `.github/workflows/linux.yml` for list of apt packages to install
2. copy and modify config.conf.default to config.conf with your setup
3. run `distribute.sh -mqgis`

## CI

the release is automatically created from each build on master. See tagged releases which have the SDK as artefact

# License & Acknowledgement

The project is originally based on https://github.com/opengisch/OSGeo4A
and https://github.com/rabits/dockerfiles

- [Dockerfiles](https://github.com/rabits/dockerfiles) Apache-2.0, rabits.org
- [distribute.sh](https://github.com/opengisch/OSGeo4A/blob/master/LICENSE-for-distribute-sh) MIT license, Copyright (c) 2010-2013 Kivy Team and other contributors
- [Dockerfiles & recipes](https://github.com/opengisch/OSGeo4A) MIT license
- [iOS toolchain](https://github.com/leetal/ios-cmake/blob/)
- [vcpkg](https://github.com/microsoft/vcpkg/blob/master/LICENSE.txt) MIT License
