# input-sdk
SDK for building [Input](https://github.com/lutraconsulting/input) for mobile devices

Input makes surveying of geospatial data easy. You can design your survey project in QGIS with custom forms.

Click here to download the app on your Android device:

<a href='https://play.google.com/store/apps/details?id=uk.co.lutraconsulting&ah=GSqwibzO2n63iMlCjHmMuBk89t4&pcampaignid=MKT-Other-global-all-co-prtnr-py-PartBadge-Mar2515-1&pcampaignid=MKT-Other-global-all-co-prtnr-py-PartBadge-Mar2515-1'><img alt='Get it on Google Play' src='https://play.google.com/intl/en_us/badges/images/generic/en_badge_web_generic.png' width="170" /></a>

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
