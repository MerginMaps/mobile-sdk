#include "input-sdk-test.hpp"
#include "sqlite3.h"
#include <stdio.h>

int test_sqlite3()
{   
    printf("SQLITE3: %s\n", sqlite3_libversion());

    sqlite3 *db = nullptr;
    int rc1 = sqlite3_open(":memory:", &db);
    int rc2 = sqlite3_enable_load_extension( db, 1 );
    sqlite3_close( db );
    return rc1 + rc2;
}