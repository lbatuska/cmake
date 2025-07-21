# add_deps_to(x ALL) add_deps_to(x LINK_ONLY ALL) add_deps_to(x pk1 pkg2 ...)
# add_deps_to(x LINK_ONLY pk1 pkg2 ...)
function(add_deps_to name)
  set(options LINK_ONLY) # Add LINK_ONLY to the call if only linking is needed

  cmake_parse_arguments(ADD_DEPS "${options}" "" "" ${ARGN})
  set(packages ${ADD_DEPS_UNPARSED_ARGUMENTS})

  foreach(pkg IN LISTS packages)

    message(STATUS "Adding ${pkg} !")

    if(pkg STREQUAL "ALL" OR pkg STREQUAL "openssl")
      if(NOT ADD_DEPS_LINK_ONLY)
        if(NOT TARGET OpenSSL::Crypto)
          set(OPENSSL_USE_STATIC_LIBS TRUE)
          find_package(OpenSSL REQUIRED)
          if(NOT OpenSSL_FOUND)
            message(
              FATAL_ERROR
                "OpenSSL not found. Please install OpenSSL development libraries."
            )
          endif()
        else()
          message(STATUS "OpenSSL is already available, only linking it!")
        endif()
        target_link_libraries(${name} PRIVATE OpenSSL::Crypto)
      endif()
    endif()

    if(pkg STREQUAL "ALL" OR pkg STREQUAL "curl")
      if(NOT ADD_DEPS_LINK_ONLY)
        if(NOT TARGET CURL::libcurl)
          find_package(CURL REQUIRED)
          if(NOT CURL_FOUND)
            message(
              FATAL_ERROR
                "Curl not found. Please install libcurl development libraries.")
          endif()
        else()
          message(STATUS "Curl is already available, only linking it!")
        endif()
        target_link_libraries(${name} PRIVATE CURL::libcurl)
      endif()
    endif()

    if(pkg STREQUAL "ALL" OR pkg STREQUAL "googletest")
      if(NOT ADD_DEPS_LINK_ONLY)
        if(NOT TARGET gtest)
          cpmaddpackage(
            NAME
            googletest
            GITHUB_REPOSITORY
            google/googletest
            GIT_TAG
            v1.17.0
            VERSION
            1.17.0
            OPTIONS
            "INSTALL_GTEST OFF"
            "gtest_force_shared_crt")
        else()
          message(STATUS "googletest is already available, only linking it!")
        endif()
      endif()
      target_link_libraries(${name} PRIVATE gtest gtest_main gmock)
    endif()

    # NOTE: redis-plus-plus requires hiredis to be installed
    if(pkg STREQUAL "ALL" OR pkg STREQUAL "redis-plus-plus")
      if(NOT ADD_DEPS_LINK_ONLY)
        if(NOT TARGET redis-plus-plus::redis-plus-plus)
          cpmaddpackage(
            NAME
            redis-plus-plus
            GIT_TAG
            # should be swapped to version once commit "update
            # cmake_minimum_required to 3.5" is included in a named version
            ffba366c9a08be4714b0ddcf272c34eef15ceb83
            GITHUB_REPOSITORY
            sewenew/redis-plus-plus
            OPTIONS
            "REDIS_PLUS_PLUS_BUILD_STATIC ON"
            "REDIS_PLUS_PLUS_BUILD_SHARED OFF"
            "REDIS_PLUS_PLUS_BUILD_TEST OFF")

          # link a target from another directory scope >= cmake 3.13
          cmake_policy(SET CMP0079 NEW)
          target_link_libraries(redis++_static INTERFACE ${HIREDIS_LIBRARIES})
        else()
          message(
            STATUS "redis-plus-plus is already available, only linking it!")
        endif()
      endif()
      target_link_libraries(${name} PRIVATE redis++_static)
    endif()

    if(pkg STREQUAL "ALL" OR pkg STREQUAL "fmt")
      if(NOT ADD_DEPS_LINK_ONLY)
        if(NOT TARGET fmtlib::fmtlib
           AND NOT TARGET fmt::fmt
           AND NOT TARGET fmt::fmt-header-only)
          cpmaddpackage("gh:fmtlib/fmt#11.2.0")
        else()
          message(STATUS "fmt is already available, only linking it!")
        endif()
      endif()
      target_link_libraries(${name} PRIVATE fmt::fmt)
    endif()

    # NOTE: spdlog requires fmt to be added
    if(pkg STREQUAL "ALL" OR pkg STREQUAL "spdlog")
      if(NOT ADD_DEPS_LINK_ONLY)
        if(NOT TARGET spdlog::spdlog)
          cpmaddpackage(
            NAME
            spdlog
            VERSION
            1.15.3
            GITHUB_REPOSITORY
            "gabime/spdlog"
            OPTIONS
            "SPDLOG_FMT_EXTERNAL ON")
        else()
          message(STATUS "spdlog is already available, only linking it!")
        endif()
      endif()
      target_link_libraries(${name} PRIVATE spdlog::spdlog)
    endif()

    if(pkg STREQUAL "ALL" OR pkg STREQUAL "dotenv")
      if(NOT ADD_DEPS_LINK_ONLY)
        if(NOT TARGET dotenv)
          cpmaddpackage(NAME dotenv-cpp GIT_TAG master GITHUB_REPOSITORY
                        "laserpants/dotenv-cpp")
          # cache the variable so it's available 2nd time when target exists
          set(DOTENV_CPP_DIR
              ${dotenv-cpp_SOURCE_DIR}
              CACHE INTERNAL "")
        else()
          message(STATUS "dotenv is already available, only linking it!")
        endif()
      endif()
      target_include_directories(${name} SYSTEM
                                 PRIVATE ${DOTENV_CPP_DIR}/include/laserpants)
    endif()

    if(pkg STREQUAL "ALL" OR pkg STREQUAL "websocketpp")
      if(NOT ADD_DEPS_LINK_ONLY)
        if(NOT TARGET websocketpp)
          cpmaddpackage(
            NAME
            websocketpp
            GIT_TAG
            0.8.2
            GITHUB_REPOSITORY
            "zaphoyd/websocketpp"
            OPTIONS
            "CMAKE_POLICY_VERSION_MINIMUM 3.5")
          set(WEBSOCKET_CPP_DIR
              ${websocketpp_SOURCE_DIR}
              CACHE INTERNAL "")
        else()
          message(STATUS "websocketpp is already available, only linking it!")
        endif()
        target_include_directories(${name} PRIVATE ${WEBSOCKET_CPP_DIR})
      endif()
    endif()

    # https://github.com/uNetworking/uWebSockets
    if(pkg STREQUAL "ALL" OR pkg STREQUAL "ixwebsocket")
      if(NOT ADD_DEPS_LINK_ONLY)
        if(NOT TARGET ixwebsocket)
          cpmaddpackage(NAME ixwebsocket VERSION 11.4.6 GITHUB_REPOSITORY
                        "machinezone/IXWebSocket")
        else()
          message(STATUS "IXWebSocket is already available, only linking it!")
        endif()
        target_link_libraries(${name} PRIVATE ixwebsocket)
      endif()
    endif()

    if(pkg STREQUAL "ALL" OR pkg STREQUAL "nlohmann_json")
      if(NOT ADD_DEPS_LINK_ONLY)
        if(NOT TARGET nlohmann_json::nlohmann_json)
          cpmaddpackage(
            NAME
            nlohmann_json
            VERSION
            3.12.0
            GITHUB_REPOSITORY
            nlohmann/json
            OPTIONS
            "JSON_BuildTests OFF")
        else()
          message(STATUS "nlohmann_json is already available, only linking it!")
        endif()
        target_link_libraries(${name} PRIVATE nlohmann_json::nlohmann_json)
      endif()
    endif()

    if(pkg STREQUAL "ALL" OR pkg STREQUAL "inja")
      if(NOT ADD_DEPS_LINK_ONLY)
        if(NOT TARGET inja)
          cpmaddpackage(
            NAME
            inja
            GITHUB_REPOSITORY
            pantor/inja
            # VERSION 3.4.0
            GIT_TAG
            main
            OPTIONS
            "BUILD_STATIC_LIBS ON"
            "INJA_USE_EMBEDDED_JSON OFF"
            "INJA_BUILD_TESTS OFF")
          set(inja_CPP_DIR
              ${inja_SOURCE_DIR}
              CACHE INTERNAL "")
        else()
          message(STATUS "inja is already available, only linking it!")
        endif()
        target_include_directories(${name} SYSTEM
                                   PRIVATE ${inja_CPP_DIR}/include)
      endif()
    endif()

    if(pkg STREQUAL "ALL" OR pkg STREQUAL "jwt-cpp")
      if(NOT ADD_DEPS_LINK_ONLY)
        if(NOT TARGET jwt-cpp)
          cpmaddpackage(NAME jwt-cpp GITHUB_REPOSITORY Thalhammer/jwt-cpp
                        VERSION 0.7.1)
          set(jwt-cpp_CPP_DIR
              ${jwt-cpp_SOURCE_DIR}
              CACHE INTERNAL "")
        else()
          message(STATUS "jwt-cpp is already available, only linking it!")
        endif()
        target_include_directories(${name} SYSTEM
                                   PRIVATE ${jwt-cpp_CPP_DIR}/include)
      endif()
    endif()

    if(pkg STREQUAL "ALL" OR pkg STREQUAL "cpr")
      if(NOT ADD_DEPS_LINK_ONLY)
        if(NOT TARGET cpr::cpr)
          cpmaddpackage(
            NAME
            cpr
            GIT_TAG
            1.12.0
            GITHUB_REPOSITORY
            libcpr/cpr
            OPTIONS
            "CPR_BUILD_TESTS OFF"
            "BUILD_SHARED_LIBS OFF"
            "CPR_ENABLE_SSL ON")
        else()
          message(STATUS "cpr is already available, only linking it!")
        endif()
        target_link_libraries(${name} PRIVATE cpr::cpr)
      endif()
    endif()

    # used to include Abseil without compiler warnings
    function(make_interface_includes_system target dep)
      get_target_property(raw_includes ${dep} INTERFACE_INCLUDE_DIRECTORIES)

      message(STATUS "[${dep}] Raw includes:")
      foreach(raw ${raw_includes})
        message(STATUS "  - ${raw}")
      endforeach()

      if(NOT raw_includes)
        message(WARNING "[${dep}] No INTERFACE_INCLUDE_DIRECTORIES found.")
        return()
      endif()

      set(evaluated_includes "")
      foreach(path ${raw_includes})
        if(path MATCHES "^\\$<BUILD_INTERFACE:(.*)>$")
          set(actual_path "${CMAKE_MATCH_1}")
          message(STATUS "[${dep}] BUILD_INTERFACE -> ${actual_path}")
          list(APPEND evaluated_includes "${actual_path}")
        elseif(path MATCHES "^\\$<INSTALL_INTERFACE:(.*)>$")
          set(actual_path "${CMAKE_MATCH_1}")
          message(
            STATUS "[${dep}] INSTALL_INTERFACE -> ${actual_path} (ignored)")
          # Optionally add it: list(APPEND evaluated_includes "${actual_path}")
        else()
          message(STATUS "[${dep}] Literal include -> ${path}")
          list(APPEND evaluated_includes "${path}")
        endif()
      endforeach()

      if(evaluated_includes)
        message(STATUS "[${target}] Adding SYSTEM includes from ${dep}:")
        foreach(inc ${evaluated_includes})
          message(STATUS "  -> ${inc}")
        endforeach()
        target_include_directories(${target} SYSTEM
                                   PRIVATE ${evaluated_includes})
      else()
        message(
          WARNING "[${dep}] No usable include paths found to mark as SYSTEM.")
      endif()
    endfunction()

    # NOTE: set an ABSL_LIBS variable to link targets
    if(pkg STREQUAL "ALL" OR pkg STREQUAL "abseil")
      if(NOT ADD_DEPS_LINK_ONLY)
        if(NOT TARGET absl::base)
          cpmaddpackage(NAME abseil GIT_TAG 20250512.1 GITHUB_REPOSITORY
                        abseil/abseil-cpp)

        else()
          message(STATUS "abseil is already available, only linking it!")
        endif()
        if(NOT DEFINED ABSL_LIBS)
          message(
            FATAL_ERROR
              "\nMissing required variable: ABSL_LIBS\n"
              "Abseil does not provide a single 'absl' target."
              " You must manually list the required targets.\n"
              "Example:\n"
              "set(ABSL_LIBS\n"
              "  absl::base\n"
              "  absl::flat_hash_map\n"
              "  absl::strings\n"
              ")\n"
              "before calling add_deps_to(...).")
        else()
          message(STATUS "Linking Abseil libraries: ${ABSL_LIBS} to ${name}")
          # mark include dirs system to prevent inheritance of compile options
          foreach(lib ${ABSL_LIBS})
            make_interface_includes_system(${name} ${lib})
          endforeach()
          target_link_libraries(${name} PRIVATE ${ABSL_LIBS})
        endif()
      endif()
    endif()

    if(pkg STREQUAL "ALL" OR pkg STREQUAL "cpputils")
      if(NOT ADD_DEPS_LINK_ONLY)
        if(NOT TARGET cpputils)

          if(IS_DIRECTORY "${CMAKE_SOURCE_DIR}/cpputils")
            if(EXISTS "${CMAKE_SOURCE_DIR}/cpputils/CMakeLists.txt")
              add_subdirectory(cpputils)
            endif()
          endif()

          if(NOT TARGET cpputils)
            cpmaddpackage("gh:lbatuska/cpputils#master")
          endif()

        else()
          message(STATUS "cpputils is already available, only linking it!")
        endif()
        target_link_libraries(${name} PRIVATE cpputils)
      endif()
    endif()

    if(pkg STREQUAL "ALL" OR pkg STREQUAL "pqxx")
      if(NOT ADD_DEPS_LINK_ONLY)
        if(NOT TARGET pqxx)
          cpmaddpackage(
            NAME
            pqxx
            GIT_TAG
            7.10.1
            GITHUB_REPOSITORY
            jtv/libpqxx
            OPTIONS
            "BUILD_SHARED_LIBS OFF"
            "SKIP_BUILD_TEST ON"
            "BUILD_DOC OFF"
            "INSTALL_TEST OFF")
        else()
          message(STATUS "pqxx is already available, only linking it!")
        endif()
        make_interface_includes_system(${name} pqxx)
        target_link_libraries(${name} PRIVATE pqxx)
      endif()
    endif()

  endforeach()
endfunction()
