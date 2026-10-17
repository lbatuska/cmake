include_guard(GLOBAL)

function(_compile_warning_flags output)
  if(CMAKE_CXX_COMPILER_ID MATCHES "^(GNU|Clang|AppleClang)$")
    set(flags
        -Wall
        -Wextra
        -Wpedantic
        -Wshadow
        -Wconversion
        -Wsign-conversion
        -Wnull-dereference
        -Wdouble-promotion
        -Wunused-variable
        "$<$<COMPILE_LANGUAGE:CXX>:-Woverloaded-virtual>"
        "$<$<COMPILE_LANGUAGE:CXX>:-Wnon-virtual-dtor>")
    if(CMAKE_CXX_COMPILER_ID MATCHES "^(Clang|AppleClang)$")
      list(APPEND flags "$<$<COMPILE_LANGUAGE:CXX>:-Wdocumentation>")
    elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
      list(APPEND flags -Wmisleading-indentation)
    endif()
  else()
    set(flags "")
    message(WARNING "Compile warnings are only configured for GCC and Clang")
  endif()

  set(${output}
      "${flags}"
      PARENT_SCOPE)
endfunction()

function(enable_compile_warnings target_name)
  _compile_warning_flags(flags)
  if(flags)
    target_compile_options(${target_name} PRIVATE ${flags})
  endif()
endfunction()

function(enable_compile_warnings_public target_name)
  _compile_warning_flags(flags)
  if(flags)
    target_compile_options(${target_name} PUBLIC ${flags})
  endif()
endfunction()

function(enable_compile_warnings_global)
  _compile_warning_flags(flags)
  if(flags)
    add_compile_options(${flags})
  endif()
endfunction()
