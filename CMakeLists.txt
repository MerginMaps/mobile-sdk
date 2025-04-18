cmake_minimum_required(VERSION 3.21)

macro(unset_pc LIBNAME)
  # clean broken PC_SPATIALITE variables causing
  # clang: error: no such file or directory: 'Security'
  # clang: error: no such file or directory: 'CoreFoundation'
  unset(PC_${LIBNAME}_LDFLAGS_OTHER CACHE)
  unset(PC_${LIBNAME}_STATIC_LDFLAGS CACHE)
  unset(PC_${LIBNAME}_STATIC_LDFLAGS_OTHER CACHE)
  unset(PC_${LIBNAME}_LDFLAGS CACHE)
  unset(PC_${LIBNAME}_LIBRARY_DIRS CACHE)
  unset(${LIBNAME}_LIBRARY CACHE)
endmacro()

unset_pc(SPATIALITE)
unset_pc(FREEXL)

#######################################

project(MerginMapsMobileSdk LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

message("CMAKE_SYSTEM_PROCESSOR: ${CMAKE_SYSTEM_PROCESSOR}")
message("CMAKE_SYSTEM_NAME: ${CMAKE_SYSTEM_NAME}")

find_package(Qt6
    COMPONENTS
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
find_package(unofficial-minizip CONFIG REQUIRED)
find_package(PROJ CONFIG REQUIRED)
find_package(GEOS CONFIG REQUIRED)
find_package(GDAL CONFIG REQUIRED)
find_package(ZXing CONFIG REQUIRED)
find_package(libzip REQUIRED)
find_package(unofficial-sqlite3 CONFIG REQUIRED)
find_package(Protobuf REQUIRED)
find_package(Qca CONFIG REQUIRED)
find_package(Qt6Keychain CONFIG REQUIRED)
find_package(PostgreSQL REQUIRED)
find_package(exiv2 CONFIG REQUIRED)
find_package(expat CONFIG REQUIRED)
find_package(CURL CONFIG REQUIRED)
find_package(Iconv)
find_package(WebP CONFIG REQUIRED)

unset_pc(SPATIALITE)
unset_pc(FREEXL)

find_library(SPATIALINDEX_LIBRARY spatialindex_i spatialindex spatialindex-64 PATHS ${VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}/lib NO_DEFAULT_PATH REQUIRED)
find_library(SPATIALITE_LIBRARY spatialite PATHS ${VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}/lib NO_DEFAULT_PATH REQUIRED)
find_library(ZLIB_LIBRARY z PATHS ${VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}/lib NO_DEFAULT_PATH REQUIRED)
find_library(FREEXL_LIBRARY freexl PATHS ${VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}/lib NO_DEFAULT_PATH REQUIRED)
if(APPLE)
    find_library(LIBTASN1_LIBRARY tasn1 PATHS ${VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}/lib NO_DEFAULT_PATH REQUIRED)
endif()

#######################################

add_executable(merginmapsmobilesdk main.cpp)

if(CMAKE_SYSTEM_NAME STREQUAL "iOS")
  set_target_properties(
    merginmapsmobilesdk
    PROPERTIES MACOSX_BUNDLE TRUE
               XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY "" # disable signing
               MACOSX_BUNDLE_GUI_IDENTIFIER MerginMaps.SDK
               XCODE_ATTRIBUTE_ENABLE_HARDENED_RUNTIME TRUE
  )
endif ()

#######################################
# 
# Linking order matters!
#
# 1/ QGIS
# at least on Linux qgis_core needs to be linked before Qt lib
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

target_include_directories(merginmapsmobilesdk PRIVATE ${QGIS_INCLUDE_DIR})
target_link_libraries(merginmapsmobilesdk PRIVATE ${QGIS_LIBRARY})

# 2/ Qt
target_link_libraries(merginmapsmobilesdk PRIVATE
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
  target_link_libraries(merginmapsmobilesdk PRIVATE
    Qt6::PrintSupport
  )
endif()

if (CMAKE_SYSTEM_NAME STREQUAL "iOS")
  qt_add_ios_ffmpeg_libraries(merginmapsmobilesdk)
endif()

# 3/ next libs 
target_link_libraries(merginmapsmobilesdk PRIVATE Geodiff::Geodiff)
target_link_libraries(merginmapsmobilesdk PRIVATE PROJ::proj)
target_link_libraries(merginmapsmobilesdk PRIVATE ZXing::Core ZXing::ZXing)

# 4/ QGIS providers
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
  target_link_libraries(merginmapsmobilesdk PRIVATE ${QGIS_${provider}_LIBRARY}
  )
endforeach ()

# fix cycling dependencies between qgis_core and providers
target_link_libraries(merginmapsmobilesdk PRIVATE ${QGIS_LIBRARY})

# 5/ GDAL
target_link_libraries(merginmapsmobilesdk PRIVATE GDAL::GDAL)

# 6/ rest
target_link_libraries(merginmapsmobilesdk PRIVATE PostgreSQL::PostgreSQL)
target_link_libraries(merginmapsmobilesdk PRIVATE Qt6Keychain::Qt6Keychain)
target_link_libraries(merginmapsmobilesdk PRIVATE qca) 

if(APPLE)
    target_link_libraries(merginmapsmobilesdk PRIVATE ${LIBTASN1_LIBRARY})
endif()

target_link_libraries(merginmapsmobilesdk PRIVATE libzip::zip)
target_link_libraries(merginmapsmobilesdk PRIVATE protobuf::libprotobuf-lite)
target_link_libraries(merginmapsmobilesdk PRIVATE Exiv2::exiv2lib)
target_link_libraries(merginmapsmobilesdk PRIVATE CURL::libcurl)
target_link_libraries(merginmapsmobilesdk PRIVATE expat::expat)
target_link_libraries(merginmapsmobilesdk PRIVATE WebP::webp WebP::webpdemux WebP::libwebpmux WebP::webpdecoder)
target_link_libraries(merginmapsmobilesdk PRIVATE ${FREEXL_LIBRARY})
target_link_libraries(merginmapsmobilesdk PRIVATE unofficial::minizip::minizip)
target_link_libraries(merginmapsmobilesdk PRIVATE ${ZLIB_LIBRARY})
target_link_libraries(merginmapsmobilesdk PRIVATE ${SPATIALINDEX_LIBRARY})
target_link_libraries(merginmapsmobilesdk PRIVATE ${SPATIALITE_LIBRARY})
target_link_libraries(merginmapsmobilesdk PRIVATE GEOS::geos_c)
target_link_libraries(merginmapsmobilesdk PRIVATE Iconv::Iconv)
target_link_libraries(merginmapsmobilesdk PRIVATE unofficial::sqlite3::sqlite3)
