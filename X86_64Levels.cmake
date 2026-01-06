include_guard(GLOBAL)

set(X86_64_LEVEL
    "v2"
    CACHE STRING "x86-64 ISA level (v1, v2, v3, v4)")

set_property(CACHE X86_64_LEVEL PROPERTY STRINGS v1 v2 v3 v4)

if(NOT X86_64_LEVEL MATCHES "^v[1-4]$")
  message(FATAL_ERROR "Invalid X86_64_LEVEL: ${X86_64_LEVEL}")
endif()

if(NOT CMAKE_SYSTEM_PROCESSOR MATCHES "x86_64|AMD64")
  message(STATUS "x86-64 ISA levels ignored (non-x86_64)")
  return()
endif()

if(NOT (CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang"))
  message(WARNING "x86-64 ISA levels only tested with GCC/Clang")
endif()

set(_X86_64_MARCH "-march=x86-64-${X86_64_LEVEL}")

add_compile_options("$<$<COMPILE_LANGUAGE:C>:${_X86_64_MARCH}>"
                    "$<$<COMPILE_LANGUAGE:CXX>:${_X86_64_MARCH}>")

message(STATUS "x86-64 ISA level set to ${X86_64_LEVEL}")
message(STATUS "Using compiler flag: ${_X86_64_MARCH}")
