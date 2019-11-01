@echo on

set VERSION_qgis=31192093340f800d06d9ee67e1c3d46988520dd8
set URL_qgis=https://github.com/qgis/QGIS/archive/%VERSION_qgis%.tar.gz
set BUILD_qgis=%BUILD_PATH%\qgis
mkdir %BUILD_qgis%
cd %BUILD_qgis%

curl -fsSL --connect-timeout 60  -o qgis.tar.gz %URL_qgis%

7z x "qgis.tar.gz" -so | 7z x -aoa -si -ttar -o"src"

mkdir %BUILD_qgis%\build
cd %BUILD_qgis%\build

set OLD_PATH=%PATH%

set PATH=%STAGE_PATH%\apps\Qt5\bin;%PATH%
set PATH=C:\Python36-x64;%PATH%
set Qt5_DIR=%STAGE_PATH%\apps\qt5\lib\cmake\Qt5

cmake -G "Visual Studio 15 2017 Win64" ^
-DCMAKE_INSTALL_PREFIX:PATH=%STAGE_PATH% ^
-DWITH_DESKTOP=OFF ^
-DDISABLE_DEPRECATED=ON ^
-DWITH_QTWEBKIT=OFF ^
-DWITH_QT5SERIALPORT=OFF ^
-DWITH_BINDINGS=OFF ^
-DWITH_INTERNAL_SPATIALITE=OFF ^
-DWITH_ANALYSIS=OFF ^
-DWITH_GRASS=OFF ^
-DCMAKE_DISABLE_FIND_PACKAGE_QtQmlTools=TRUE ^
-DWITH_QTMOBILITY=OFF ^
-DWITH_QUICK=ON ^
-DENABLE_QT5=ON ^
-DENABLE_TESTS=OFF ^
-DWITH_INTERNAL_QWTPOLAR=OFF ^
-DWITH_QWTPOLAR=OFF ^
-DWITH_GUI=OFF ^
-DWITH_APIDOC=OFF ^
-DWITH_ASTYLE=OFF ^
-DWITH_GRASS7:BOOL=OFF ^
-DFORCE_STATIC_PROVIDERS=TRUE ^
-DSETUPAPI_LIBRARY:PATH="C:/Program Files (x86)/Microsoft SDKs/Windows/v7.1A/Lib/x64/SetupAPI.Lib" ^
-DVERSION_LIBRARY:PATH="C:/Program Files (x86)/Microsoft SDKs/Windows/v7.1A/Lib/x64/Version.Lib" ^
-DFLEX_EXECUTABLE:PATH="C:/ProgramData/chocolatey/lib/winflexbison3/tools/win_flex.exe" ^
-DBISON_EXECUTABLE:PATH="C:/ProgramData/chocolatey/lib/winflexbison3/tools/win_bison.exe" ^
-DCMAKE_PREFIX_PATH=%STAGE_PATH%;%STAGE_PATH%/apps/Qt5/lib/cmake ^
%BUILD_qgis%\src\QGIS-%VERSION_qgis%

cmake --build . --config Release --target install --parallel %NUMBER_OF_PROCESSORS%

REM -DCMAKE_PREFIX_PATH:PATH="C:/OSGeo4W64;C:/OSGeo4W64/apps/qt5/lib/cmake/QtCore;C:/OSGeo4W64/apps/qt5/lib/cmake/QtGui;C:/OSGeo4W64/apps/qt5/lib/cmake/Qt5WebKit;C:/OSGeo4W64/apps/qt5/lib/cmake/Qca-qt5;C:/OSGeo4W64/apps/qt5/lib/cmake/Qt5;C:/OSGeo4W64/apps/qt5/lib/cmake/Qt5Location;C:/OSGeo4W64/apps/qt5/lib/cmake/Qt5Positioning;C:/OSGeo4W64/apps/qt5/lib/cmake/Qt5Qml;C:/OSGeo4W64/apps/qt5/lib/cmake/Qt5Quick;C:/OSGeo4W64/apps/qt5/lib/cmake/Qt5QuickCompiler;C:/OSGeo4W64/apps/qt5/lib/cmake/Qt5Quick;C:/OSGeo4W64/apps/qt5/lib/cmake/Qt5Xml;C:/OSGeo4W64/apps/qt5/lib/cmake/Qt5Sql;C:/OSGeo4W64/apps/qt5/lib/cmake/Qt5PrintSupport;C:/OSGeo4W64/apps/qt5/lib/cmake/Qt5Multimedia;C:/OSGeo4W64/apps/qt5/lib/cmake/QtQml;C:/OSGeo4W64/apps/qt5/lib/cmake/Qt5Keychain" ^

REM  cp $BUILD_PATH/qgis/build-$ARCH/src/core/qgis_core.h ${STAGE_PATH}/QGIS.app/Contents/Frameworks/qgis_core.framework/Headers/
REM  cp $BUILD_PATH/qgis/build-$ARCH/src/quickgui/qgis_quick.h ${STAGE_PATH}/QGIS.app/Contents/MacOS/lib/qgis_quick.framework/Headers/
REM  cp $BUILD_qgis/src/quickgui/plugin/qgsquickplugin.h ${STAGE_PATH}/QGIS.app/Contents/MacOS/lib/qgis_quick.framework/Headers/

REM cp -R $BUILD_qgis/src/quickgui/images ${STAGE_PATH}/QGIS.app/Contents/Resources/images/QgsQuick

set PATH=%OLD_PATH%

