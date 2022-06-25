#include <iostream>
#include "input-sdk-test.hpp"

int main(int argc, char** argv){
	std::cout << "Test Input-SDK" << std::endl;
    int res = 0;
    std::cout << "Test sqlite3" << std::endl;
    res += test_sqlite3();
    
	return res;
}