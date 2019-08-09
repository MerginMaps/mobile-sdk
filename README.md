# input-sdk
SDK for building Input for mobile devices

# Android 

To publish new image of lutraconsulting/input-sdk on docker-hub, run build&publish script.
The resulting image contains SDK for building Input app for armeabi-v7a and arm64-v8a architectures.

Tagging: qt-X-Y, where X is QT's version and Y is incremental number for that QT version, e.g. qt-5.13.0-1

Contains:
  - Android-NDK
  - Android-SDK
  - Qt libraries
  - OSGeo & GNU libraries (zlib, GDAL, geos, ...)
  - QGIS core
  - QgsQuick


# License & Acknowledgement

The project is originally based on https://github.com/opengisch/OSGeo4A
and https://github.com/rabits/dockerfiles

- [Dockerfiles](https://github.com/rabits/dockerfiles) Apache-2.0, rabits.org
- [extract-qt-installer.sh](https://github.com/benlau/qtci) Apache-2.0, QT-CI Project
- [distribute.sh](https://github.com/opengisch/OSGeo4A/blob/master/LICENSE-for-distribute-sh) MIT license, Copyright (c) 2010-2013 Kivy Team and other contributors
- [Dockerfiles & recipes](https://github.com/opengisch/OSGeo4A) MIT license
