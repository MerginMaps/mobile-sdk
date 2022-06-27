project(InputSdkTest)
cmake_minimum_required(VERSION 3.10)
set(CMAKE_CXX_STANDARD 17)

add_executable(inputsdktest main.cpp)

find_package(unofficial-sqlite3 CONFIG REQUIRED)
find_package(geos CONFIG REQUIRED)

target_link_libraries(inputsdktest PRIVATE unofficial::sqlite3::sqlite3)
target_link_libraries(inputsdktest PRIVATE geodiff)
target_link_libraries(inputsdktest PRIVATE GEOS::geos_c)
target_link_libraries(inputsdktest PRIVATE proj)
