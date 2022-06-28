include(SelectLibraryConfigurations)
select_library_configurations(GEODIFF)

find_path(GEODIFF_INCLUDE_DIRS NAMES geodiff.h HINTS ${CURRENT_INSTALLED_DIR})
get_filename_component(_prefix_path ${GEODIFF_INCLUDE_DIRS} PATH)

find_library(GEODIFF_LIBRARIES 
  NAMES geodiff
  PATHS "${_prefix_path}/lib" 
  NO_DEFAULT_PATH)

unset(_prefix_path)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
    GEODIFF
    REQUIRED_VARS GEODIFF_LIBRARIES GEODIFF_INCLUDE_DIRS
)
