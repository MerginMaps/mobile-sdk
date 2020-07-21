# Android 

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

[used versions](Dockerfile) - MAKE SURE YOU HAVE correct QT version (openssl) and NDK

