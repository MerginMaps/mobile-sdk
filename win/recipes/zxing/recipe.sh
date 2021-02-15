#!/bin/bash

@echo on

set VERSION_zxing=1.1.1
set URL_zxing=https://github.com/nu-book/zxing-cpp/archive/v%VERSION_zxing%.tar.gz
set BUILD_zxing=%BUILD_PATH%\zxing
set REPO_zxing=%REPO_PATH%\zxing
if not exist %BUILD_zxing% mkdir %BUILD_zxing%

IF NOT EXIST %REPO_zxing% (
  cd %DOWNLOAD_PATH%
  curl -fsSL --connect-timeout 60 -o zxing.tar.gz %URL_zxing%

  7z x "zxing.tar.gz" -so | 7z x -aoa -si -ttar -o"src"
  move src\zxing-%VERSION_zxing% %REPO_zxing%
)

cd %BUILD_zxing%
cmake -G %CMAKE_GENERATOR% ^
-DCMAKE_INSTALL_PREFIX:PATH=%STAGE_PATH% ^
-DBUILD_EXAMPLES=OFF ^
-DBUILD_BLACKBOX_TESTS=OFF ^
-DBUILD_UNIT_TESTS=OFF ^
-DBUILD_SHARED_LIBS=ON ^
%REPO_zxing%\zxing

cmake --build . --config Release --target install --parallel %NUMBER_OF_PROCESSORS%
