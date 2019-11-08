@echo on

set VERSION_geodiff=0.7.5
set URL_geodiff=https://github.com/lutraconsulting/geodiff/archive/%VERSION_geodiff%.tar.gz
set BUILD_geodiff=%BUILD_PATH%\geodiff
mkdir %BUILD_geodiff%
cd %BUILD_geodiff%

curl -fsSL --connect-timeout 60 -o geodiff.tar.gz %URL_geodiff%
dir

7z x "geodiff.tar.gz" -so | 7z x -aoa -si -ttar -o"src"
cd src\geodiff-%VERSION_geodiff%
dir

mkdir %BUILD_geodiff%\build
cd %BUILD_geodiff%\build

cmake -G "Visual Studio 15 2017 Win64" ^
-DCMAKE_INSTALL_PREFIX:PATH=%STAGE_PATH% ^
-DENABLE_TESTS=OFF ^
-DBUILD_TOOLS=OFF ^
-DBUILD_STATIC_LIBS=OFF ^
%BUILD_geodiff%\src\geodiff-%VERSION_geodiff%\geodiff

cmake --build . --config Release --target install --parallel %NUMBER_OF_PROCESSORS%
