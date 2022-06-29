vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO nu-book/zxing-cpp
    REF v1.1.1
    SHA512 c7d97df147602e31e58eede54413814378895e9710cf266de984b22965a9a3f4c67648a0bf936a8bc8b213b45def59d1e5b34d6ce516265333dd2c0430554dc7
    HEAD_REF master
)

if (VCPKG_TARGET_IS_UWP)
   set(ENV{CL} "$ENV{CL} -wd4996")
endif()
vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_BLACKBOX_TESTS=OFF
        -DBUILD_EXAMPLES=OFF
        -DBUILD_SYSTEM_DEPS=ALWAYS
    MAYBE_UNUSED_VARIABLES
        # Currently no dependencies, but this defends against future additions
        BUILD_SYSTEM_DEPS
)

vcpkg_cmake_install()
vcpkg_fixup_pkgconfig()
vcpkg_copy_pdbs()

vcpkg_cmake_config_fixup(
    CONFIG_PATH lib/cmake/ZXing
    PACKAGE_NAME ZXing
)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/nu-book-zxing-cpp" RENAME copyright)
