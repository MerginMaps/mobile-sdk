cmake_minimum_required(VERSION 3.16)

project(InputSdkTest LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(unofficial-sqlite3 CONFIG REQUIRED)
find_package(GEOS CONFIG REQUIRED)
find_package(Qt6 COMPONENTS Core REQUIRED)
find_package(GDAL REQUIRED)
find_package(PROJ CONFIG REQUIRED)
find_package(QGIS COMPONENTS Core REQUIRED)
find_package(GEODIFF REQUIRED)

add_executable(inputsdktest main.cpp)

target_link_libraries(inputsdktest PRIVATE unofficial::sqlite3::sqlite3)
target_link_libraries(inputsdktest PRIVATE Qt6::Core)
target_link_libraries(inputsdktest PRIVATE PROJ::proj)
target_link_libraries(inputsdktest PRIVATE GEOS::geos_c)
target_include_directories(inputsdktest PRIVATE ${GDAL_INCLUDE_DIRS})
target_link_libraries(inputsdktest PRIVATE ${GDAL_LIBRARIES})
target_include_directories(inputsdktest PRIVATE ${GEODIFF_INCLUDE_DIRS})
target_link_libraries(inputsdktest PRIVATE ${GEODIFF_LIBRARIES})
target_link_libraries(inputsdktest PRIVATE QGIS::Core)