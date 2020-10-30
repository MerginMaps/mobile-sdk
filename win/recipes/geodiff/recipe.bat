@echo on

set VERSION_geodiff=0.8.6
set URL_geodiff=https://github.com/lutraconsulting/geodiff/archive/%VERSION_geodiff%.tar.gz
set BUILD_geodiff=%BUILD_PATH%\geodiff
set REPO_geodiff=%REPO_PATH%\geodiff
if not exist %BUILD_geodiff% mkdir %BUILD_geodiff%

IF NOT EXIST %REPO_geodiff% (
  cd %DOWNLOAD_PATH%
  curl -fsSL --connect-timeout 60 -o geodiff.tar.gz %URL_geodiff%

  7z x "geodiff.tar.gz" -so | 7z x -aoa -si -ttar -o"src"
  move src\geodiff-%VERSION_geodiff% %REPO_geodiff%
)

cd %BUILD_geodiff%
cmake -G %CMAKE_GENERATOR% ^
-DCMAKE_INSTALL_PREFIX:PATH=%STAGE_PATH% ^
-DENABLE_TESTS=OFF ^
-DBUILD_TOOLS=OFF ^
-DBUILD_STATIC_LIBS=OFF ^
%REPO_geodiff%\geodiff

cmake --build . --config Release --target install --parallel %NUMBER_OF_PROCESSORS%
