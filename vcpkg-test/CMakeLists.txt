cmake_minimum_required(VERSION 3.16)

project(InputSdkTest LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(unofficial-sqlite3 CONFIG REQUIRED)
find_package(libzip CONFIG REQUIRED)
find_package(GEOS CONFIG REQUIRED)
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
    Core5Compat
    Multimedia 
    Widgets
    PrintSupport
    REQUIRED
)
find_package(GDAL REQUIRED)
find_package(PROJ CONFIG REQUIRED)
find_package(QGIS COMPONENTS Core REQUIRED)
find_package(GEODIFF REQUIRED)
find_package(Protobuf REQUIRED)
find_package(Qca CONFIG REQUIRED)
find_package(Qt6Keychain CONFIG REQUIRED)
find_package(ZXing CONFIG REQUIRED)
find_package(PostgreSQL REQUIRED)
find_package(Exiv2 REQUIRED)
find_package(expat CONFIG REQUIRED)
find_package(CURL CONFIG REQUIRED)
find_package(Iconv)
find_package(WebP CONFIG REQUIRED)
find_package(PNG REQUIRED)

find_path(SPATIALINDEX_INCLUDE_DIR spatialindex/RTree.h HINTS ${VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET})
find_library(SPATIALINDEX_LIBRARY spatialindex_i spatialindex spatialindex-64 HINTS ${VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET})

find_path(SPATIALITE_INCLUDE_DIR spatialite.h HINTS ${VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET})
find_library(SPATIALITE_LIBRARY spatialite HINTS ${VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET})

find_library(ZLIB_LIBRARY z HINTS ${VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET})

add_executable(inputsdktest main.cpp)

target_link_libraries(inputsdktest PRIVATE QGIS::Core)

target_link_libraries(inputsdktest PRIVATE libzip::zip)
target_link_libraries(inputsdktest PRIVATE protobuf::libprotobuf-lite)
target_link_libraries(inputsdktest PRIVATE unofficial::sqlite3::sqlite3)
target_link_libraries(inputsdktest PRIVATE
    Qt6::Qml
    Qt6::Xml
    Qt6::Concurrent
    Qt6::Positioning
    Qt6::Sensors
    Qt6::Network
    Qt6::Svg
    Qt6::Sql
    Qt6::Core
    Qt6::Core5Compat
    Qt6::Multimedia 
    Qt6::Widgets
    Qt6::PrintSupport
 )

target_link_libraries(inputsdktest PRIVATE qca) 
target_link_libraries(inputsdktest PRIVATE exiv2lib exiv2-xmp) 

target_link_libraries(inputsdktest PRIVATE ZXing::Core ZXing::ZXing)
target_link_libraries(inputsdktest PRIVATE PostgreSQL::PostgreSQL)
target_link_libraries(inputsdktest PRIVATE Qt6Keychain::Qt6Keychain)
target_link_libraries(inputsdktest PRIVATE PROJ::proj)
target_link_libraries(inputsdktest PRIVATE GEOS::geos_c)
target_link_libraries(inputsdktest PRIVATE CURL::libcurl)
target_link_libraries(inputsdktest PRIVATE expat::expat)
target_link_libraries(inputsdktest PRIVATE Iconv::Iconv)
target_link_libraries(inputsdktest PRIVATE WebP::webp WebP::webpdemux WebP::libwebpmux WebP::webpdecoder)
target_link_libraries(inputsdktest PRIVATE PNG::PNG)

target_link_libraries(inputsdktest PRIVATE ${ZLIB_LIBRARY})

target_include_directories(inputsdktest PRIVATE ${GDAL_INCLUDE_DIRS})
target_link_libraries(inputsdktest PRIVATE ${GDAL_LIBRARIES})
target_include_directories(inputsdktest PRIVATE ${GEODIFF_INCLUDE_DIRS})
target_link_libraries(inputsdktest PRIVATE ${GEODIFF_LIBRARIES})

target_include_directories(inputsdktest PRIVATE ${SPATIALINDEX_INCLUDE_DIR})
target_link_libraries(inputsdktest PRIVATE ${SPATIALINDEX_LIBRARY})

target_include_directories(inputsdktest PRIVATE ${SPATIALITE_INCLUDE_DIR})
target_link_libraries(inputsdktest PRIVATE ${SPATIALITE_LIBRARY})

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
    HINTS ${VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}
  )
  target_link_libraries(inputsdktest PRIVATE ${QGIS_${provider}_LIBRARY})

endforeach ()

target_link_libraries(inputsdktest PRIVATE QGIS::Core)
