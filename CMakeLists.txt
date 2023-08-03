cmake_minimum_required(VERSION 3.19)

macro(unset_pc_spatialite)
  # clean broken PC_SPATIALITE variables causing
  # clang: error: no such file or directory: 'Security'
  # clang: error: no such file or directory: 'CoreFoundation'
  unset(PC_SPATIALITE_LDFLAGS_OTHER CACHE)
  unset(PC_SPATIALITE_STATIC_LDFLAGS CACHE)
  unset(PC_SPATIALITE_STATIC_LDFLAGS_OTHER CACHE)
  unset(PC_SPATIALITE_LDFLAGS CACHE)
  unset(PC_SPATIALITE_LIBRARY_DIRS CACHE)
  unset(SPATIALITE_LIBRARY CACHE)
endmacro()

unset_pc_spatialite()

project(MerginMapsInputSdk LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 COMPONENTS 
    Qml
    Xml
    Concurrent
    Positioning
    Sensors
    Network
    Svg
    Sql
    Core
    Gui
    Core5Compat
    Multimedia 
    Widgets
    REQUIRED
)
find_package(Geodiff CONFIG REQUIRED)
find_package(PROJ CONFIG REQUIRED)
find_package(GEOS CONFIG REQUIRED)
find_package(GDAL CONFIG REQUIRED)
find_package(ZXing CONFIG REQUIRED)
find_package(libzip REQUIRED)
find_package(unofficial-minizip CONFIG)
find_package(unofficial-sqlite3 CONFIG REQUIRED)
find_package(Protobuf REQUIRED)
find_package(Qca CONFIG REQUIRED)
find_package(Qt6Keychain CONFIG REQUIRED)
find_package(PostgreSQL REQUIRED)
find_package(Exiv2 REQUIRED)
find_package(expat CONFIG REQUIRED)
find_package(CURL CONFIG REQUIRED)
find_package(Iconv)
find_package(WebP CONFIG REQUIRED)
find_package(PNG REQUIRED)

unset_pc_spatialite()
find_library(SPATIALINDEX_LIBRARY spatialindex_i spatialindex spatialindex-64 PATHS ${VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}/lib NO_DEFAULT_PATH REQUIRED)
find_library(SPATIALITE_LIBRARY spatialite PATHS ${VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}/lib NO_DEFAULT_PATH REQUIRED)
find_library(ZLIB_LIBRARY z PATHS ${VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}/lib NO_DEFAULT_PATH REQUIRED)
find_library(FREEXL_LIBRARY freexl PATHS ${VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}/lib NO_DEFAULT_PATH REQUIRED)
if(APPLE)
    find_library(LIBTASN1_LIBRARY
            NAMES tasn1
            PATHS
            /usr/local/lib
            /usr/lib
        )
endif()

add_executable(merginmapsinputsdk main.cpp)

target_link_libraries(merginmapsinputsdk PRIVATE
    Qt6::Qml
    Qt6::Xml
    Qt6::Concurrent
    Qt6::Positioning
    Qt6::Sensors
    Qt6::Network
    Qt6::Svg
    Qt6::Sql
    Qt6::Core
    Qt6::Gui
    Qt6::Core5Compat
    Qt6::Multimedia 
    Qt6::Widgets
)
if(NOT CMAKE_SYSTEM_NAME STREQUAL "iOS")
  find_package(Qt6 COMPONENTS PrintSupport)
  target_link_libraries(merginmapsinputsdk PRIVATE
    Qt6::PrintSupport
  )
endif()

if(APPLE)
    target_link_libraries(merginmapsinputsdk PRIVATE ${LIBTASN1_LIBRARY})
endif()
target_link_libraries(merginmapsinputsdk PRIVATE unofficial::sqlite3::sqlite3)
target_link_libraries(merginmapsinputsdk PRIVATE ZXing::Core ZXing::ZXing)
target_link_libraries(merginmapsinputsdk PRIVATE PROJ::proj)
target_link_libraries(merginmapsinputsdk PRIVATE GEOS::geos_c)
target_link_libraries(merginmapsinputsdk PRIVATE Geodiff::Geodiff)
target_link_libraries(merginmapsinputsdk PRIVATE unofficial::minizip::minizip)
target_link_libraries(merginmapsinputsdk PRIVATE libzip::zip)
target_link_libraries(merginmapsinputsdk PRIVATE libzip::zip)
target_link_libraries(merginmapsinputsdk PRIVATE protobuf::libprotobuf-lite)
target_link_libraries(merginmapsinputsdk PRIVATE qca) 
target_link_libraries(merginmapsinputsdk PRIVATE exiv2lib exiv2-xmp)
target_link_libraries(merginmapsinputsdk PRIVATE PostgreSQL::PostgreSQL)
target_link_libraries(merginmapsinputsdk PRIVATE Qt6Keychain::Qt6Keychain)
target_link_libraries(merginmapsinputsdk PRIVATE CURL::libcurl)
target_link_libraries(merginmapsinputsdk PRIVATE expat::expat)
target_link_libraries(merginmapsinputsdk PRIVATE Iconv::Iconv)
target_link_libraries(merginmapsinputsdk PRIVATE WebP::webp WebP::webpdemux WebP::libwebpmux WebP::webpdecoder)
target_link_libraries(merginmapsinputsdk PRIVATE PNG::PNG)
target_link_libraries(merginmapsinputsdk PRIVATE ${FREEXL_LIBRARY})
target_link_libraries(merginmapsinputsdk PRIVATE ${ZLIB_LIBRARY})
target_link_libraries(merginmapsinputsdk PRIVATE ${SPATIALINDEX_LIBRARY})
target_link_libraries(merginmapsinputsdk PRIVATE ${SPATIALITE_LIBRARY})
target_link_libraries(merginmapsinputsdk PRIVATE GDAL::GDAL)


# QGIS
find_path(QGIS_INCLUDE_DIR 
    NAMES qgis.h 
    PATHS "${_VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}/include"
    PATH_SUFFIXES qgis
    NO_DEFAULT_PATH
)

find_library(
  QGIS_LIBRARY
  NAMES qgis_core
  PATHS "${_VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}/lib"
  PATH_SUFFIXES qgis
  NO_DEFAULT_PATH
)

target_include_directories(merginmapsinputsdk PRIVATE ${QGIS_INCLUDE_DIR})
target_link_libraries(merginmapsinputsdk PRIVATE ${QGIS_LIBRARY})

set(QGIS_PROVIDERS_LIST
    authmethod_basic
    authmethod_esritoken
    authmethod_identcert
    authmethod_oauth2
    authmethod_pkcs12
    authmethod_pkipaths
    provider_arcgisfeatureserver
    provider_arcgismapserver
    provider_delimitedtext
    provider_spatialite
    provider_virtuallayer
    provider_wcs
    provider_wfs
    provider_wms
    provider_postgres
)

foreach (provider ${QGIS_PROVIDERS_LIST})
  find_library(
    QGIS_${provider}_LIBRARY
    NAMES ${provider}_a
    PATHS "${_VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}/lib"
    PATH_SUFFIXES qgis
    NO_DEFAULT_PATH
  )
  target_link_libraries(merginmapsinputsdk PRIVATE ${QGIS_${provider}_LIBRARY}
  )
endforeach ()

target_link_libraries(merginmapsinputsdk PRIVATE ${QGIS_LIBRARY})
