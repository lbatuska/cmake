# add_deps_to(x ALL) add_deps_to(x LINK_ONLY ALL) add_deps_to(x pk1 pkg2 ...)
# add_deps_to(x LINK_ONLY pk1 pkg2 ...)
function(add_deps_to name)
  set(options LINK_ONLY) # Add LINK_ONLY to the call if only linking is needed

  cmake_parse_arguments(ADD_DEPS "${options}" "" "" ${ARGN})
  set(packages ${ADD_DEPS_UNPARSED_ARGUMENTS})

  foreach(pkg IN LISTS packages)

    if(pkg STREQUAL "ALL" OR pkg STREQUAL "redis-plus-plus")
      message(STATUS "Adding ${pkg} !")
      if(NOT ADD_DEPS_LINK_ONLY)
        list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")
        find_package(Hiredis REQUIRED)
        # target_link_libraries(${name} PRIVATE ${HIREDIS_LIBRARIES})

        cpmaddpackage(
          NAME
          redis-plus-plus
          GIT_TAG
          e30d4c4c557568b01d5adce9df2714de8d3921c2
          # 75a75ec305b2c1786e022e6e130b4e03e0659ade
          GITHUB_REPOSITORY
          sewenew/redis-plus-plus
          OPTIONS
          "REDIS_PLUS_PLUS_BUILD_STATIC ON"
          "REDIS_PLUS_PLUS_BUILD_SHARED OFF"
          "REDIS_PLUS_PLUS_BUILD_TEST OFF")

        # link a target from another directory scope >= cmake 3.13
        cmake_policy(SET CMP0079 NEW)
        target_link_libraries(redis++_static INTERFACE ${HIREDIS_LIBRARIES})
      endif()
      target_link_libraries(${name} PRIVATE redis++_static)
    endif()

  endforeach()
endfunction()
