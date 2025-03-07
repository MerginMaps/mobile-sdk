# on iOS (static) Qt ships Poly2Tri ( but without headers :( )
if(NOT VCPKG_TARGET_IS_IOS)
    message(FATAL_ERROR "qt poly2tri only needed on iOS")
else()
    vcpkg_download_distfile(ARCHIVE
        URLS "https://download.qt.io/archive/qt/6.8/${VERSION}/submodules/qtpositioning-everywhere-src-${VERSION}.zip"
        FILENAME "qtpositioning-${VERSION}.zip"
        SHA512 647484035722ed015a6ec92a6d2ca966d507dd5e63c29676b36d6250611f7c228907e0acb5d1c195f7e1164d4092c1536c98c073cc81d28c3b868b1383defd4d 
    )
    
    vcpkg_extract_source_archive(
        SOURCE_PATH
        ARCHIVE "${ARCHIVE}"
        SOURCE_BASE "v${VERSION}"
    )
    
    file(INSTALL ${SOURCE_PATH}/src/3rdparty/poly2tri DESTINATION ${CURRENT_PACKAGES_DIR}/include FILES_MATCHING PATTERN "*.h")
endif()
