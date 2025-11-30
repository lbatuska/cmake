cmake_minimum_required(VERSION 3.11)

set(DEPS_FOLDER "${CMAKE_BINARY_DIR}/deps")

include(FetchContent)
FetchContent_Declare(
  libsodium
  GIT_REPOSITORY "https://github.com/jedisct1/libsodium.git"
  GIT_TAG 0a9450c679480a187e7f9e77d55b76fad92991ea
  SOURCE_DIR ${DEPS_FOLDER}/libsodium)
FetchContent_MakeAvailable(libsodium)

project("sodium" LANGUAGES C)

set(SODIUM_STATIC ON)

set(LIBSODIUM_SOURCE_DIR ${DEPS_FOLDER}/libsodium)
set(LIBSODIUM_SOURCE_INNER_DIR ${LIBSODIUM_SOURCE_DIR}/src/libsodium)

set(LIB_OUTPUT_DIR "${CMAKE_BINARY_DIR}/_deps/libsodium-build")

file(GLOB_RECURSE LIBSODIUM_SOURCES ${LIBSODIUM_SOURCE_INNER_DIR}/*.c)

add_library(sodium STATIC ${LIBSODIUM_SOURCES})

set_target_properties(
  sodium PROPERTIES ARCHIVE_OUTPUT_DIRECTORY "${LIB_OUTPUT_DIR}"
                    LIBRARY_OUTPUT_DIRECTORY "${LIB_OUTPUT_DIR}")

target_sources(sodium PRIVATE ${LIBSODIUM_SOURCES})

target_compile_features(sodium PRIVATE c_std_99)

target_include_directories(
  sodium
  PUBLIC ${LIBSODIUM_SOURCE_INNER_DIR}/include
  PRIVATE ${LIBSODIUM_SOURCE_INNER_DIR}/include/sodium)

set(VERSION 1.0.20)
set(SODIUM_LIBRARY_VERSION_MAJOR 26)
set(SODIUM_LIBRARY_VERSION_MINOR 2)

configure_file(${LIBSODIUM_SOURCE_INNER_DIR}/include/sodium/version.h.in
               ${LIBSODIUM_SOURCE_INNER_DIR}/include/sodium/version.h)

target_compile_options(sodium PRIVATE -w)
