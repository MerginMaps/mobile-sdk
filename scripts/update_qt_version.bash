#!/usr/bin/env bash

set -e

echo "update_qt_version.bash MAJOR.MINOR.BUILD"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
VERSION=$1
VER_PARTS=(${VERSION//./ })
MAJOR=${VER_PARTS[0]}
MINOR=${VER_PARTS[1]}
BUILD=${VER_PARTS[2]}

echo "using QT version $MAJOR.$MINOR.$BUILD"

############
# README
README_FILE=$DIR/../README.md
echo "patching $README_FILE"
# e.g. /Qt/6.5.2/ unix style
sed -i.orig -E "s|/Qt/[0-9]+.[0-9]+.[0-9]+/|/Qt/${VERSION}/|g" $README_FILE
# e.g. \Qt\6.5.2\ win style
sed -i.orig -E "s|\\\Qt\\\[0-9]+.[0-9]+.[0-9]+\\\|\\\Qt\\\\${VERSION}\\\|g" $README_FILE
rm -f $README_FILE.orig

############
# WORKFLOWS
for FNAME in \
    $DIR/../.github/workflows/android.yml \
    $DIR/../.github/workflows/ios.yml \
    $DIR/../.github/workflows/linux.yml \
    $DIR/../.github/workflows/mac.yml \
    $DIR/../.github/workflows/mac_arm64.yml \
    $DIR/../.github/workflows/win.yml
do
    echo "patching $FNAME"
    # e.g. QT_VERSION: '6.5.2'
    sed -i.orig -E "s|QT_VERSION: \'[0-9]+.[0-9]+.[0-9]+\'|QT_VERSION: \'${VERSION}\'|g" $FNAME
    rm -f $FNAME.orig
done

############
# qt6_poly2tri
VCPKG_FILE=$DIR/../vcpkg-overlay/ports/qt6-poly2tri/vcpkg.json
echo "patching $VCPKG_FILE"
# e.g. "version": "6.5.2",
sed -i.orig -E "s|\"version\": \"[0-9]+.[0-9]+.[0-9]+\"|\"version\": \"${VERSION}\"|g" $VCPKG_FILE
rm -f $VCPKG_FILE.orig

PORTFILE_FILE=$DIR/../vcpkg-overlay/ports/qt6-poly2tri/portfile.cmake
echo "patching $PORTFILE_FILE"
# e.g. qt/6.5/,
sed -i.orig -E "s|qt/[0-9]+.[0-9]+/|qt/${MAJOR}.${MINOR}/|g" $PORTFILE_FILE
rm -f $PORTFILE_FILE.orig

echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "!!!! You need to update SHA512 HASH in $PORTFILE_FILE. Download zip file, find SHA512 and update manually"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

############
# qt6 
QT6_FILE=$DIR/../vcpkg-overlay/ports/qt6/vcpkg.json
echo "patching $QT6_FILE"
# e.g. "version-string": "6.5.2",,
sed -i.orig -E "s|\"version-string\": \"[0-9]+.[0-9]+.[0-9]+\"|\"version-string\": \"${VERSION}\"|g" $QT6_FILE
rm -f $QT6_FILE.orig

# DONE
echo "patching done"
