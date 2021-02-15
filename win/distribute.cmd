@echo on

set OLD_PATH=%PATH%
set ROOT_DIR=C:\projects\input-sdk\x86_64
set PY36=C:\Python36-x64
set STAGE_PATH=%ROOT_DIR%\stage
set BUILD_PATH=%ROOT_DIR%\build
set REPO_PATH=%ROOT_DIR%\repo
set DOWNLOAD_PATH=%ROOT_DIR%\download
set RESULT_FILE=%ROOT_DIR%\input-sdk-win-x86_64.zip
set OSGEO4W_ROOT=%REPO_PATH%\OSGeo4W64
set CMAKE=C:\Program Files\CMake\bin
set CMAKE_GENERATOR="Visual Studio 14 2015 Win64"

if not exist %ROOT_DIR% mkdir %ROOT_DIR%
if not exist %BUILD_PATH% mkdir %BUILD_PATH%
if not exist %REPO_PATH% mkdir %REPO_PATH%
if not exist %DOWNLOAD_PATH% mkdir %DOWNLOAD_PATH%

rem OSGEO
if not exist %OSGEO4W_ROOT% call %~dp0\recipes\osgeo\recipe.bat
if not exist %STAGE_PATH% robocopy %OSGEO4W_ROOT% %STAGE_PATH% /E /NFL /NDL
if exist %STAGE_PATH%\apps\grass RMDIR /S /Q %STAGE_PATH%\apps\grass
if exist %STAGE_PATH%\apps\proj-dev RMDIR /S /Q %STAGE_PATH%\apps\proj-dev
if exist %STAGE_PATH%\apps\gdal-dev RMDIR /S /Q %STAGE_PATH%\apps\gdal-dev 
if exist %STAGE_PATH%\apps\Python37 RMDIR /S /Q %STAGE_PATH%\apps\Python37

rem BUILD ENV
if not "%PROGRAMFILES(X86)%"=="" set PF86=%PROGRAMFILES(X86)%
if "%PF86%"=="" set PF86=%PROGRAMFILES%
if "%PF86%"=="" (echo PROGRAMFILES not set & goto error)
set VS140COMNTOOLS=%PF86%\Microsoft Visual Studio 14.0\Common7\Tools\
call "%PF86%\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" amd64
path %path%;%PF86%\Microsoft Visual Studio 14.0\VC\bin
path %path%;%CMAKE%
path %path%;%STAGE_PATH%\apps\Qt5\bin;%PATH%
path %path%;%PY36%;%PATH%
set PYTHONPATH="%PY36%\DLLs;%PY36%\Lib;%PY36%\Lib\site-packages"
set Qt5_DIR=%STAGE_PATH%\apps\qt5\lib\cmake\Qt5
set LIB=%STAGE_PATH%\apps\Qt5\lib;%STAGE_PATH%\lib
set LIB=%LIB%;C:\Program Files (x86)\Windows Kits\8.1\Lib\winv6.3\um\x64\
set INCLUDE=%STAGE_PATH%\apps\Qt5\include;%STAGE_PATH%\include

rem GEODIFF
IF NOT EXIST "%STAGE_PATH%\lib\geodiff.lib" call %~dp0\recipes\geodiff\recipe.bat
IF NOT EXIST "%STAGE_PATH%\bin\geodiff.dll" goto error
IF NOT EXIST "%STAGE_PATH%\lib\geodiff.lib" goto error

rem zxing
IF NOT EXIST "%STAGE_PATH%\lib\libZXing.lib" call %~dp0\recipes\zxing\recipe.bat
IF NOT EXIST "%STAGE_PATH%\bin\libZXing.dll" goto error
IF NOT EXIST "%STAGE_PATH%\lib\libZXing.lib" goto error

rem QGIS
call %~dp0\recipes\qgis\recipe.bat
IF NOT EXIST "%STAGE_PATH%\bin\qgis_core.dll" goto error

IF NOT EXIST %RESULT_FILE% 7z a %RESULT_FILE% %STAGE_PATH%\*
dir %RESULT_FILE%

set PATH=%OLD_PATH%
cd %~dp0
echo "all done!"
goto end

:error
echo ENV ERROR %ERRORLEVEL%: %DATE% %TIME%
path %OLD_PATH%
cd %~dp0
echo "error!"
exit /b 1

:end