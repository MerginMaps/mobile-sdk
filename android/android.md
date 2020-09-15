# Android 

To publish new image of lutraconsulting/input-sdk on docker-hub, run
(make sure you replace X with the first untaken tag)

```
export TAG=android-X
docker login
docker build . -t lutraconsulting/input-sdk:${TAG}
docker push lutraconsulting/input-sdk:${TAG}
git tag ${TAG} && git push --tag
```

The resulting image contains SDK for building Input app for armeabi-v7a and arm64-v8a architectures.

Tagging: android-X, X is incremental number, e.g. android-1

Contains:
  - Android-NDK
  - Android-SDK
  - Qt libraries
  - OSGeo & GNU libraries (GDAL, geos, ...)
  - QGIS core
  - QgsQuick

[used versions](Dockerfile) - MAKE SURE YOU HAVE correct QT version (openssl) and NDK
