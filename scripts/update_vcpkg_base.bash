#!/usr/bin/env bash

set -e

echo "update_vcpkg_base.bash GIT_HASH"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
HASH=$1

echo "using git hash $GIT_HASH"

for FILENAME in \
    $DIR/../.github/workflows/android.yml \
    $DIR/../.github/workflows/ios.yml \
    $DIR/../.github/workflows/linux.yml \
    $DIR/../.github/workflows/android.yml \
    $DIR/../.github/workflows/win.yml
do
    # the line looks like 
    # VCPKG_BASELINE: "d765306b074717dea8dc1c4723e1b025acb61c2d" # use scripts/update_vcpkg_base.bash to change
    echo "patching $FILENAME"
    sed -i.orig -E "s|VCPKG_BASELINE: \"[0-9a-zA-Z]+\"|VCPKG_BASELINE: \"$GIT_HASH\"|g" $FILENAME
    rm -f $DIR/../.github/workflows/$FILENAME.orig
done



# vcpkg.json
VCPKG_FILE=$DIR/../vcpkg-test/vcpkg.json
echo "patching $VCPKG_FILE"
# the line looks like
#     "builtin-baseline": "d765306b074717dea8dc1c4723e1b025acb61c2d",
sed -i.orig -E "s|\"builtin-baseline\": \"[0-9a-zA-Z]+\"|\"builtin-baseline\": \"$GIT_HASH\"|g" $VCPKG_FILE
rm -f $DIR/../vcpkg-test/$VCPKG_FILE.orig

echo "patching done"
