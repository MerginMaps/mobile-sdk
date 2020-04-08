# input-sdk
[![Build status](https://ci.appveyor.com/api/projects/status/76nx3nvjo3phwjcu/branch/master?svg=true)](https://ci.appveyor.com/project/PeterPetrik/input-sdk/branch/master)

SDK for building [Input](https://github.com/lutraconsulting/input) for mobile devices

Input makes surveying of geospatial data easy. You can design your survey project in QGIS with custom forms.

Click here to download the app on your Android/iOS device [inputapp.io](http://inputapp.io)

# Android 

![Docker Pulls](https://img.shields.io/docker/pulls/lutraconsulting/input-sdk)

To publish new image of lutraconsulting/input-sdk on docker-hub, run build&publish script.
The resulting image contains SDK for building Input app for armeabi-v7a and arm64-v8a architectures.

Tagging: android-X, X is incremental number, e.g. android-1

Contains:
  - Android-NDK
  - Android-SDK
  - Qt libraries
  - OSGeo & GNU libraries (zlib, GDAL, geos, ...)
  - QGIS core
  - QgsQuick

[used versions](android/Dockerfile) - MAKE SURE YOU HAVE correct QT version (openssl) and NDK

# Windows

SDK for builing on [WIN](https://www.dropbox.com/sh/k263vsl78k1t6fp/AAB28Demr_ZicsgP7G_BcGsUa?dl=0)

it is building automatically on appveyor.com 
for local developement do:

- install Visual Studio (Community) 2015 (14)
- install Microsoft SDK 8.1
- install Microsoft Universal CRT SDK (not required on win 10)
- install dependency walker if you need to debug linkage
- install python 36 to path C:\Python36-x64
- open visual studio IDE and compile any example project (you need to additionally download some packages)
- make sure you have file Microsoft Visual Studio 14.0\VC\vcvarsall.bat present on the installation!
- install OSGeo4W 64 bit to C:\projects\input-sdk\x86_64\repo\OSGeo4W64
- install bison and flex and cmake and 7zip (through `choco`)
- get geodiff, qgis, input-sdk repos to C:\input-sdk\x86_64\repo\
- `cd input-sdk\win`
- run `distibute.cmd`
- optionally upload resulting sdk to common public place

## Hints

- to find library on disk: `where -F -R \ xyz.Lib`

# iOS

This provides a set of scripts to build opensource geo tools for iOS (iPhone and iPad)
Only works on MacOS systems, since you need XCode to compile binaries for iOS. The build system is maintained for QGIS 3.x 
releases.

Tested with iPhoneOS12.0.sdk, Qt 5.11.3 and arm64, min SDK 12.0 on iPad running iOS 12.x
Due to the [Qt bug](https://bugreports.qt.io/browse/QTBUG-77031), use Qt 5.11.x or 5.12.5+ or 5.13.1+

Dependencies instructions
-------------------------
- [Qt5 5.11.3] Install iOS arch support (if you want SDK 10.0 + and arm64 only)
- Install XCode 10.3 and accept ToC
```
$ xcrun --sdk iphoneos --show-sdk-path
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS12.4.sdk
```

If you want armv7 and different SDK, you may try to build QT yourself (not tested)

To build QGIS, you need relatively new version of bison (3.x). MacOS ships with bison 2.x
so it is required to install one newer and add to PATH
- `brew install bison`

detto for flex. You may need to add them to PATH so cmake can pick them

Build instructions
-----------
Create a file config.conf in the root folder by copying the config.conf.default
file and edit it accordingly to your needs.

You may want to clone qgis/QGIS locally and point the config.conf file to your local 
repository, if you are working on qgis/QGIS development. 

```sh
cd ios 
cp config.conf.default config.conf
# nano config.conf
./distribute.sh -dqgis
```

Now all libraries should be in stage/<architecture> folder for linking.

If you work with your local QGIS repository, you need to apply c++11 patch manually,
but do not push that upstream!


Application distribution instructions
-------------------------------------

You need to package the stage libraries to the device and modify rpath to point 
to the base

MUST READ: http://doc.qt.io/qt-5/platform-notes-ios.html

all libraries are STATIC, due to some limitation for iOS platform (distribution on AppStore, Qt
distribution for iOS, etc.)

Debugging
---------

debugging from XCode, since from QtCreator now working
https://bugreports.qt.io/browse/QTCREATORBUG-15812

Interesting reading
-------------------

https://forum.qt.io/topic/75452/problem-with-custom-plugin-for-qtquick-on-ios

https://github.com/benlau/quickios

# License & Acknowledgement

The project is originally based on https://github.com/opengisch/OSGeo4A
and https://github.com/rabits/dockerfiles

- [Dockerfiles](https://github.com/rabits/dockerfiles) Apache-2.0, rabits.org
- [distribute.sh](https://github.com/opengisch/OSGeo4A/blob/master/LICENSE-for-distribute-sh) MIT license, Copyright (c) 2010-2013 Kivy Team and other contributors
- [Dockerfiles & recipes](https://github.com/opengisch/OSGeo4A) MIT license
- [iOS toolchain](https://github.com/cristeab/ios-cmake.git)
