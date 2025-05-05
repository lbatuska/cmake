function(enable_sanitizers_project proj_name)
  if(NOT CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
    message(WARNING "Sanitizers are only supported on GCC and Clang")
    return()
  endif()

  # Default to enabled unless explicitly disabled
  option(ENABLE_SANITIZERS "Enable Address, Undefined, Leak sanitizers" ON)

  if(ENABLE_SANITIZERS AND CMAKE_BUILD_TYPE MATCHES "^(Debug|RelWithDebInfo)$")
    set(SANITIZERS "address,undefined,leak,thread")
    target_compile_options(${proj_name} INTERFACE -fsanitize=${SANITIZERS})
    target_link_options(${proj_name} INTERFACE -fsanitize=${SANITIZERS})
    message(STATUS "Sanitizers enabled: ${SANITIZERS}")
  else()
    message(STATUS "Sanitizers disabled")
  endif()
endfunction()
