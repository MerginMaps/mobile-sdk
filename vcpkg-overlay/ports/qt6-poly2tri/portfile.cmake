# on iOS (static) Qt ships Poly2Tri ( but without headers :( )
if(NOT VCPKG_TARGET_IS_IOS)
    message(FATAL_ERROR "qt poly2tri only needed on iOS")
else()
    vcpkg_download_distfile(ARCHIVE
        URLS "https://download.qt.io/archive/qt/6.6/${VERSION}/submodules/qtpositioning-everywhere-src-${VERSION}.zip"
        FILENAME "qtpositioning-${VERSION}.zip"
        SHA512 927926c2efbc2f0fa94a4a33174a88c2c121f4e7ffa1f67370a9b88f4d0e1f22932c9c416cacd10562713daba8f1530688b81697bedebae84d727e0657dc052d
    )
    
    vcpkg_extract_source_archive(
        SOURCE_PATH
        ARCHIVE "${ARCHIVE}"
        SOURCE_BASE "v${VERSION}"
    )
    
    file(INSTALL ${SOURCE_PATH}/src/3rdparty/poly2tri DESTINATION ${CURRENT_PACKAGES_DIR}/include FILES_MATCHING PATTERN "*.h")
endif()
