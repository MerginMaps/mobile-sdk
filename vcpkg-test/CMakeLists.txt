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
find_package(libspatialindex REQUIRED)
find_package(Exiv2 REQUIRED)


add_executable(inputsdktest main.cpp)

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
target_link_libraries(inputsdktest PRIVATE Spatialindex::Spatialindex)
target_link_libraries(inputsdktest PRIVATE ZXing::Core ZXing::ZXing)
target_link_libraries(inputsdktest PRIVATE PostgreSQL::PostgreSQL)
target_link_libraries(inputsdktest PRIVATE Qt6Keychain::Qt6Keychain)
target_link_libraries(inputsdktest PRIVATE PROJ::proj)
target_link_libraries(inputsdktest PRIVATE GEOS::geos_c)
target_include_directories(inputsdktest PRIVATE ${GDAL_INCLUDE_DIRS})
target_link_libraries(inputsdktest PRIVATE ${GDAL_LIBRARIES})
target_include_directories(inputsdktest PRIVATE ${GEODIFF_INCLUDE_DIRS})
target_link_libraries(inputsdktest PRIVATE ${GEODIFF_LIBRARIES})
target_link_libraries(inputsdktest PRIVATE QGIS::Core)
