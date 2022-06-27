cmake_minimum_required(VERSION 3.10)

project(InputSdkTest LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_executable(inputsdktest main.cpp)

find_package(unofficial-sqlite3 CONFIG REQUIRED)
find_package(geos CONFIG REQUIRED)
find_package(Qt5 COMPONENTS Core REQUIRED)
find_package(gdal)

target_link_libraries(inputsdktest PRIVATE unofficial::sqlite3::sqlite3)
target_link_libraries(inputsdktest PRIVATE geodiff)
target_link_libraries(inputsdktest PRIVATE GEOS::geos_c)
target_link_libraries(inputsdktest PRIVATE proj)
target_link_libraries(inputsdktest PRIVATE Qt5::Core)
target_link_libraries(inputsdktest PRIVATE gdal)
target_link_libraries(inputsdktest PRIVATE qgis-core)