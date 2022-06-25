project(InputSdkTest)
cmake_minimum_required(VERSION 3.10)
set(CMAKE_CXX_STANDARD 17)

set(sources
  src/input-sdk-main.cpp
  src/input-sdk-test.hpp
  src/input-sdk-sqlite3.cpp
)

add_executable(inputsdktest ${sources})

find_package(unofficial-sqlite3 CONFIG REQUIRED)
target_link_libraries(inputsdktest PRIVATE unofficial::sqlite3::sqlite3)