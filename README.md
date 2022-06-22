[![Build macOS](https://github.com/merginmaps/input-sdk/actions/workflows/mac.yml/badge.svg)](https://github.com/merginmaps/input-sdk/actions/workflows/mac.yml)
[![Build iOS](https://github.com/merginmaps/input-sdk/actions/workflows/ios.yml/badge.svg)](https://github.com/merginmaps/input-sdk/actions/workflows/ios.yml)
[![Build android (on MacOS)](https://github.com/merginmaps/input-sdk/actions/workflows/android.yml/badge.svg)](https://github.com/merginmaps/input-sdk/actions/workflows/android.yml)
[![Build Linux](https://github.com/merginmaps/input-sdk/actions/workflows/linux.yml/badge.svg)](https://github.com/merginmaps/input-sdk/actions/workflows/linux.yml)
[![Build win64](https://github.com/MerginMaps/input-sdk/actions/workflows/win.yml/badge.svg)](https://github.com/MerginMaps/input-sdk/actions/workflows/win.yml)

# input-sdk

SDK for building [Mergin Maps Input app](https://github.com/merginmaps/input) for mobile devices

Mergin Maps Input app makes surveying of geospatial data easy. You can design your survey project in QGIS with custom forms.

Click here to download the app on your Android or iOS devices [merginmaps.com](http://merginmaps.com)

<div><img align="left" width="45" height="45" src="https://raw.githubusercontent.com/MerginMaps/docs/main/src/.vuepress/public/slack.svg"><a href="https://merginmaps.com/community/join">Join our community chat</a><br/>and ask questions!</div><br />

# Tips

how to do diff `diff -rupN file.orig file`

# Android 

Download prebuild android SDKs from the GitHub Artifacts

# Windows

Download prebuild win64 SDKs from the GitHub Artifacts

- you need to install python and visual studio
- start cmd console
- add Python 3.x to PATH (e.g. `set PATH=C:\Users\Peter\AppData\Local\Programs\Python\Python310;%PATH%`)
- `"C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\VsDevCmd.bat" -arch=x86`
- create `config.py`
- run `python3 distribute.py win64`

## tips
- to find library on disk: `where -F -R \ xyz.Lib`


# iOS

Download prebuild iOS SDKs from the GitHub Artifacts

[iOS notes](ios/ios.md)

# MacOS

Download prebuild mac SDKs from the GitHub Artifacts

## Manual Build
1. you need to have Qt installed
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
