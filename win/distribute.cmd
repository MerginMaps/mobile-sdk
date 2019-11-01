@echo on

set ROOT_DIR=C:\input-sdk\x86_64
set RESULT_FILE=C:\projects\input-sdk\input-sdk-win-x86_64.zip
mkdir %ROOT_DIR%
set STAGE_PATH=%ROOT_DIR%\stage
set BUILD_PATH=%ROOT_DIR%\build
mkdir %STAGE_PATH%
mkdir %BUILD_PATH%

echo "install flex-bison"
choco install winflexbison3

echo "download osgeo"
call %~dp0\recipes\osgeo\recipe.bat

echo "build geodiff"
call %~dp0\recipes\geodiff\recipe.bat

IF EXIST "C:\input-sdk\x86_64\stage\lib\geodiff.dll" (
    echo "geodiff is OK"
) ELSE (
    echo "missing geodiff.dll, exiting"
    exit /B 1
)

echo "build qgis"
call %~dp0\recipes\qgis\recipe.bat

IF EXIST "C:\input-sdk\x86_64\stage\lib\qgis_core.dll" (
    echo "qgis is OK"
) ELSE (
    echo "missing qgis dlls, exiting"
    exit /B 1
)

dir %STAGE_PATH%
7z a %RESULT_FILE% %STAGE_PATH%\*
dir %RESULT_FILE%

ECHO "done"