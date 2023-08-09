# on iOS (static) Qt ships Poly2Tri ( but without headers :( )
if(NOT VCPKG_TARGET_IS_IOS)
    message(FATAL_ERROR "qt poly2tri only needed on iOS")
else()
    vcpkg_download_distfile(ARCHIVE
        URLS "https://download.qt.io/archive/qt/6.5/${VERSION}/submodules/qtpositioning-everywhere-src-${VERSION}.zip"
        FILENAME "qtpositioning-${VERSION}.zip"
        SHA512 aaf4bb45e7b3317af29d1a62f66f72c015243f7b7aa7ea472377e33e7ab808e4f9663271b687f9e94371d6ed95b72e7876bc086fe6826a5540fc7f7e8332c026
    )
    
    vcpkg_extract_source_archive(
        SOURCE_PATH
        ARCHIVE "${ARCHIVE}"
        SOURCE_BASE "v${VERSION}"
    )
    
    file(INSTALL ${SOURCE_PATH}/src/3rdparty/poly2tri DESTINATION ${CURRENT_PACKAGES_DIR}/include FILES_MATCHING PATTERN "*.h")
endif()
