@echo on

set OLD_PATH=%PATH%
set ROOT_DIR=%ROOT_OUT_PATH%\%ARCH%
set STAGE_PATH=%ROOT_DIR%\stage
set BUILD_PATH=%ROOT_DIR%\build
set REPO_PATH=%ROOT_DIR%\repo
set DOWNLOAD_PATH=%ROOT_DIR%\.packages

rem check the required tools
where cmake 
where cl

rem setup folders
if not exist %ROOT_DIR% mkdir %ROOT_DIR%
if not exist %BUILD_PATH% mkdir %BUILD_PATH%
if not exist %REPO_PATH% mkdir %REPO_PATH%
if not exist %DOWNLOAD_PATH% mkdir %DOWNLOAD_PATH%

rem BUILD ENV
set Qt5_DIR=%STAGE_PATH%\apps\qt5\lib\cmake\Qt5
set LIB=%STAGE_PATH%\apps\Qt5\lib;%STAGE_PATH%\lib
set LIB=%LIB%;C:\Program Files (x86)\Windows Kits\8.1\Lib\winv6.3\um\x64\
set INCLUDE=%STAGE_PATH%\apps\Qt5\include;%STAGE_PATH%\include

rem SQLITE3
IF NOT EXIST "%STAGE_PATH%\lib\sqlite3.lib" call %~dp0\recipes\sqlite3\recipe.bat
IF NOT EXIST "%STAGE_PATH%\lib\sqlite3.lib" goto error

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