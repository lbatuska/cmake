function(enable_compile_warnings target_name)

  set(WARNING_FLAGS
      "-Wall"
      "-Wextra"
      "-Wpedantic"
      # "-Werror"
      "-Wshadow"
      "-Wconversion"
      "-Wsign-conversion"
      "-Wnull-dereference"
      "-Wdouble-promotion"
      "-Woverloaded-virtual"
      "-Wnon-virtual-dtor"
      "-Wunused-variable")

  if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    list(APPEND WARNING_FLAGS "-Wdocumentation")
  elseif(CMAKE_CXX_COMPILER_ID MATCHES "GNU")
    list(APPEND WARNING_FLAGS "-Wmisleading-indentation")
  endif()

  # list(APPEND WARNING_FLAGS "-Wno-unused-parameter")

  target_compile_options(${target_name} PRIVATE ${WARNING_FLAGS})

  message(STATUS "Enabled warnings: ${WARNING_FLAGS}")
endfunction()
