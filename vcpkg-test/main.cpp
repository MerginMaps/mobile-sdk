#include <iostream>
#include <stdio.h> 
#include <stdarg.h>

#include "geodiff.h"
#include "sqlite3.h"
#include "geos_c.h"
#include "proj.h"

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

int main(int argc, char** argv){
	std::cout << "Test Input-SDK" << std::endl;
    int res = 0;
    
    res += test_sqlite3();
    res += test_geodiff();
    res += test_geos();
    res += test_proj();
    
	return res;
}