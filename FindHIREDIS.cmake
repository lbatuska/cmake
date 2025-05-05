find_path(HIREDIS_INCLUDE_DIR hiredis/hiredis.h)
find_library(HIREDIS_LIBRARY NAMES hiredis)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(HIREDIS DEFAULT_MSG HIREDIS_LIBRARY
                                  HIREDIS_INCLUDE_DIR)

if(HIREDIS_FOUND)
  set(HIREDIS_INCLUDE_DIRS ${HIREDIS_INCLUDE_DIR})
  set(HIREDIS_LIBRARIES ${HIREDIS_LIBRARY})
endif()
