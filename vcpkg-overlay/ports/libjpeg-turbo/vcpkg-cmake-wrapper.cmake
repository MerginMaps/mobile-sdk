find_path(JPEG_INCLUDE_DIRS NAMES jpeglib.h PATHS "${_VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}/include" NO_DEFAULT_PATH)
find_library(JPEG_LIBRARY NAMES jpeg PATHS "${_VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}/lib" NO_DEFAULT_PATH)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
    JPEG
    REQUIRED_VARS JPEG_LIBRARY JPEG_INCLUDE_DIRS
)

if(JPEG_FOUND AND NOT TARGET JPEG::JPEG)
    add_library(JPEG::JPEG UNKNOWN IMPORTED)
    set_target_properties(JPEG::JPEG PROPERTIES
            INTERFACE_INCLUDE_DIRECTORIES "${JPEG_INCLUDE_DIRS}")
    set_target_properties(JPEG::JPEG PROPERTIES
            IMPORTED_LINK_INTERFACE_LANGUAGES "C"
            IMPORTED_LOCATION "${JPEG_LIBRARY}")

    set_target_properties(JPEG::JPEG PROPERTIES INTERFACE_COMPILE_OPTIONS "-DRENAME_INTERNAL_LIBJPEG_SYMBOLS")
endif()