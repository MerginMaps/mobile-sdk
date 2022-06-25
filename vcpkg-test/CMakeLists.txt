project(InputSdkTest)
cmake_minimum_required(VERSION 3.10)
set(CMAKE_CXX_STANDARD 17)

add_executable(inputsdktest main.cpp)

find_package(unofficial-sqlite3 CONFIG REQUIRED)
find_package(CURL CONFIG REQUIRED)  
find_package(expat CONFIG REQUIRED)
find_package(exiv2 CONFIG REQUIRED)

target_link_libraries(inputsdktest PRIVATE unofficial::sqlite3::sqlite3)
target_link_libraries(inputsdktest PRIVATE CURL::libcurl)
target_link_libraries(inputsdktest PRIVATE expat::expat)
target_link_libraries(inputsdktest PRIVATE exiv2lib exiv2-xmp)
target_link_libraries(inputsdktest PRIVATE geodiff)
