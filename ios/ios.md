# Build instruction for iOS

# How to release Qt for iOS 
QT in SDK is just downloaded and extracted
from dropbox archive. When updating QT version
1. download QT for iSO from the official downloader
2. compress the /opt/Qt/${QT_VERSION} folder and
3. upload compressed file qt-${QT_VERSION}-ios.tar.gz to dropbox

# How to release input-sdk for iOS 
bump version in config.pri
1. build locally ios/distribute.sh -mqgis
2. compress the `cd /opt/INPUT/input-sdk-ios-<version>/stage` with `tar -c -z -f ../input-sdk-ios-<version>.tar.gz ./ `
2. upload to dropbox "Lutra Consulting/_Support/input/input-sdks/ios-sdk" & share
4. tag the repo
5. update input to use new SDK version



# Building instructions

This provides a set of scripts to build opensource geo tools for iOS (iPhone and iPad)
Only works on MacOS systems, since you need XCode to compile binaries for iOS. The build system is maintained for QGIS 3.x 
releases.

Tested with iPhoneOS13.4.sdk, Qt 5.14.2 and arm64, min SDK 12.0 on iPad running iOS 12.x

Dependencies instructions
-------------------------
- Qt5 5.14.2 Install iOS arch support
- Install latet XCode, command line tools and accept ToC
- You should have SDK iPhoneOS13.4
- CMake >= 3.17.0 required

```
$ xcrun --sdk iphoneos --show-sdk-path
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS13.4.sdk
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
