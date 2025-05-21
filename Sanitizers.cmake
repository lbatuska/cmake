function(enable_sanitizers_project target_name)
  if(NOT CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
    message(WARNING "Sanitizers are only supported on GCC and Clang")
    return()
  endif()

  # Default to enabled unless explicitly disabled
  option(ENABLE_SANITIZERS "Enable Address, Undefined, Leak sanitizers" ON)

  if(ENABLE_SANITIZERS AND CMAKE_BUILD_TYPE MATCHES "^(Debug|RelWithDebInfo)$")
    set(SANITIZERS "address,undefined,leak")
    target_compile_options(${target_name} PRIVATE -fsanitize=${SANITIZERS})
    target_link_options(${target_name} PRIVATE -fsanitize=${SANITIZERS})
    message(STATUS "Sanitizers enabled: ${SANITIZERS}")
  else()
    message(STATUS "Sanitizers disabled")
  endif()
endfunction()

function(enable_sanitizers_global)
  # Global sanitizer flags
  option(ENABLE_SANITIZERS "Enable Address, Undefined, Leak sanitizers" ON)

  if(ENABLE_SANITIZERS AND CMAKE_BUILD_TYPE MATCHES "^(Debug|RelWithDebInfo)$")
    if(CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
      set(SANITIZERS "address,undefined,leak")
      add_compile_options(-fsanitize=${SANITIZERS})
      add_link_options(-fsanitize=${SANITIZERS})
      message(STATUS "Sanitizers globally enabled: ${SANITIZERS}")
    else()
      message(WARNING "Sanitizers are only supported on GCC and Clang")
    endif()
  endif()
endfunction()
