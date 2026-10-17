include_guard(GLOBAL)

function(_sanitizer_options compile_output link_output)
  option(ENABLE_SANITIZERS "Enable Address and UndefinedBehavior sanitizers" ON)

  if(NOT ENABLE_SANITIZERS)
    set(${compile_output}
        ""
        PARENT_SCOPE)
    set(${link_output}
        ""
        PARENT_SCOPE)
    return()
  endif()

  if(NOT CMAKE_CXX_COMPILER_ID MATCHES "^(GNU|Clang|AppleClang)$")
    message(WARNING "Sanitizers are only configured for GCC and Clang")
    set(${compile_output}
        ""
        PARENT_SCOPE)
    set(${link_output}
        ""
        PARENT_SCOPE)
    return()
  endif()

  set(config "$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>")
  set(flag "-fsanitize=address,undefined")
  set(compile_flags "$<$<AND:${config},$<COMPILE_LANGUAGE:CXX>>:${flag}>")
  if(CMAKE_C_COMPILER_LOADED AND CMAKE_C_COMPILER_ID MATCHES
                                 "^(GNU|Clang|AppleClang)$")
    list(APPEND compile_flags
         "$<$<AND:${config},$<COMPILE_LANGUAGE:C>>:${flag}>")
  endif()
  set(${compile_output}
      "${compile_flags}"
      PARENT_SCOPE)
  set(${link_output}
      "$<${config}:${flag}>"
      PARENT_SCOPE)
endfunction()

function(enable_sanitizers_target target_name)
  _sanitizer_options(compile_flag link_flag)
  if(compile_flag)
    target_compile_options(${target_name} PRIVATE ${compile_flag})
    target_link_options(${target_name} PRIVATE "${link_flag}")
    get_target_property(target_type ${target_name} TYPE)
    if(target_type STREQUAL "STATIC_LIBRARY")
      target_link_options(${target_name} INTERFACE "${link_flag}")
    endif()
  endif()
endfunction()

function(enable_sanitizers_target_public target_name)
  _sanitizer_options(compile_flag link_flag)
  if(compile_flag)
    target_compile_options(${target_name} PUBLIC ${compile_flag})
    target_link_options(${target_name} PUBLIC "${link_flag}")
  endif()
endfunction()

function(enable_sanitizers_project target_name)
  enable_sanitizers_target(${target_name})
endfunction()

function(enable_sanitizers_global)
  _sanitizer_options(compile_flag link_flag)
  if(compile_flag)
    add_compile_options(${compile_flag})
    add_link_options("${link_flag}")
  endif()
endfunction()
