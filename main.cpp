#include <iostream>
#include <stdio.h> 
#include <stdarg.h>

#include "geodiff.h"
#include "sqlite3.h"
#include "geos_c.h"
#include "proj.h"
#include "gdal.h"
#include <QtGlobal>
#include "qgis.h"
#include "ZXing/ZXVersion.h"

int test_sqlite3()
{   
    printf("SQLITE3: %s\n", sqlite3_libversion());

    sqlite3 *db = nullptr;
    int rc1 = sqlite3_open(":memory:", &db);
    int rc2 = sqlite3_enable_load_extension( db, 1 );
    sqlite3_close( db );
    return rc1 + rc2;
}

int test_geodiff()
{   
    printf("GEODIFF: %s\n", GEODIFF_version());
    return 0;
}

int test_geos()
{   
    printf("GEOS: %s\n", GEOSversion());
    return 0;
}

int test_proj()
{   
    PJ_INFO info = proj_info();
    printf("PROJ: %s\n", info.release);
    return 0;
}

int test_gdal()
{   
    printf("GDAL: %s\n", GDALVersionInfo("RELEASE_NAME"));
    return 0;
}

int test_zxing()
{   
    printf("ZXING: %d.%d.%d\n", ZXING_VERSION_MAJOR, ZXING_VERSION_MINOR, ZXING_VERSION_PATCH);
    return 0;
}

int test_qt()
{
    printf("QT: %s\n", qVersion());
    return 0;
}

int test_qgis()
{
    printf("QGIS: %d\n", Qgis::versionInt());
    return 0;
}

int main(int argc, char** argv){
	std::cout << "Mergin Maps Mobile-SDK" << std::endl;
    int res = 0;
    
    res += test_sqlite3();
    res += test_geodiff();
    res += test_geos();
    res += test_gdal();
    res += test_proj();
    res += test_qt();
    res += test_qgis();
    res += test_zxing();
    
	return res;
}