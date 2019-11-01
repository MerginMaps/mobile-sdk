@echo on

echo "install osgeo4w deps"
set SERVER="http://norbit.de/osgeo4w"
REM set SERVER="http://download.osgeo.org/osgeo4w"

curl -fsS --connect-timeout 180 -o osgeo4w-setup.exe http://download.osgeo.org/osgeo4w/osgeo4w-setup-x86_64.exe

REM todo remove local osgeo4w installer... the server timeouted
REM C:\projects\input-sdk\win\recipes\osgeo\osgeo4w-setup-x86_64.exe ^

@echo off
set OLD_PATH=%PATH%
set PATH="C:\Windows\system32;C:\Windows;C:\Windows\wbem"

osgeo4w-setup.exe ^
--advanced ^
--arch x86_64 ^
--quiet-mode ^
--upgrade-also ^
--site %SERVER% ^
--only-site ^
--root %STAGE_PATH% ^
--autoaccept ^
--no-shortcuts ^
--no-replaceonreboot ^
--packages exiv2,exiv2-devel,expat,freexl,hdf5,hdf4,gdal,geos,iconv,^
iconv-vc14,libjpeg,libkml,liblwgeom,^
libpng,libpq,libspatialindex,libtiff,libxml2,libzip-devel,^
libzip-libs,netcdf,openssl,openssl10,proj,qca-qt5-devel,qca-qt5-libs,^
qt5-devel,qt5-qml,qt5-libs,qt5-libs-debug,qtkeychain-qt5-devel,^
qtkeychain-qt5-libs,spatialite,sqlite3,zlib

set PATH=%OLD_PATH%
@echo on
