# on iOS (static) Qt ships Poly2Tri ( but without headers :( )
if(NOT VCPKG_TARGET_IS_IOS)
    message(FATAL_ERROR "qt poly2tri only needed on iOS")
else()
    vcpkg_download_distfile(ARCHIVE
        URLS "https://download.qt.io/archive/qt/6.6/${VERSION}/submodules/qtpositioning-everywhere-src-${VERSION}.zip"
        FILENAME "qtpositioning-${VERSION}.zip"
        SHA512 4ad169157f8e8c8f232644b3267b3cee6dc91fd31e4352a16b77292a243bfc1b3be163a456f9d882a6a208fee9ffdcb9b237c29d01cb0e3c49a45cccc6e3a68b
    )
    
    vcpkg_extract_source_archive(
        SOURCE_PATH
        ARCHIVE "${ARCHIVE}"
        SOURCE_BASE "v${VERSION}"
    )
    
    file(INSTALL ${SOURCE_PATH}/src/3rdparty/poly2tri DESTINATION ${CURRENT_PACKAGES_DIR}/include FILES_MATCHING PATTERN "*.h")
endif()
