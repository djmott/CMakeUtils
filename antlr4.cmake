include_guard(GLOBAL)
find_package(Java COMPONENTS Runtime REQUIRED)

set(CMAKE_UTILS_DIR ${CMAKE_CURRENT_LIST_DIR})

if(NOT ANTLR4_INSTALL_DIR)
  set(ANTLR4_INSTALL_DIR "${CMAKE_CURRENT_BINARY_DIR}/antlr4")
endif()

if(NOT ANTLR4_BUILD_DIR)
  set(ANTLR4_BUILD_DIR "${CMAKE_CURRENT_BINARY_DIR}/.antlr4")
endif()

if(NOT ANTLR_JAR)
  set(ANTLR_JAR http://www.antlr.org/download/antlr-4.7.1-complete.jar)
endif()

function(build_antlr4)
  set(_config_stamp "${ANTLR4_BUILD_DIR}/.config.stamp")
  set(_build_stamp "${ANTLR4_BUILD_DIR}/.build.stamp")
  
  if(NOT EXISTS ${_config_stamp})
    configure_file(${CMAKE_UTILS_DIR}/CMakeLists.antlr4 "${ANTLR4_BUILD_DIR}/CMakeLists.txt" @ONLY)
    execute_process(WORKING_DIRECTORY "${ANTLR4_BUILD_DIR}"
      COMMAND ${CMAKE_COMMAND} -G "${CMAKE_GENERATOR}" .
      )
    execute_process(WORKING_DIRECTORY "${ANTLR4_BUILD_DIR}" 
      COMMAND ${CMAKE_COMMAND} -E touch ${_config_stamp}
      )
  endif()
  if(NOT EXISTS ${_build_stamp})
    execute_process(WORKING_DIRECTORY "${ANTLR4_BUILD_DIR}" 
      COMMAND ${CMAKE_COMMAND} --build .
      COMMAND ${CMAKE_COMMAND} -E touch ${_build_stamp}
      )
    execute_process(WORKING_DIRECTORY "${ANTLR4_BUILD_DIR}" 
      COMMAND ${CMAKE_COMMAND} -E touch ${_build_stamp}
      )
  endif()
  if(NOT "" STREQUAL "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")
    if(MSVC)
      file(COPY ${ANTLR4_INSTALL_DIR}/lib/antlr4-runtime.dll DESTINATION ${CMAKE_RUNTIME_OUTPUT_DIRECTORY})
    else()
      file(COPY ${ANTLR4_INSTALL_DIR}/lib/libantlr4-runtime.dll DESTINATION ${CMAKE_RUNTIME_OUTPUT_DIRECTORY})
    endif()
  endif()
  include_directories(${ANTLR4_INSTALL_DIR}/include/antlr4-runtime)
  link_directories(${ANTLR4_INSTALL_DIR}/lib)
endfunction()


#[[
antlr_gen - Generates antlr stubs
Arguments:
_target     - cmake target name (for adding include directories and link libs)
_input      - path to grammar.g4
_namespace  - generated classes will be nested in _namespace
_visitor    - TRUE/FALSE to generate visitors
_listener   - TRUE/FALSE to generate listeners
]]

function(antlr_gen _target _input _namespace _visitor _listener)

  if(NOT EXISTS ${ANTLR4_BUILD_DIR}/antlr4.jar)
    file(DOWNLOAD ${ANTLR_JAR} ${ANTLR4_BUILD_DIR}/antlr4.jar)
  endif()

  get_filename_component(_input "${_input}" ABSOLUTE)
  get_filename_component(_output "${_input}" NAME_WE)

  set(_output ${CMAKE_CURRENT_BINARY_DIR}/generated/${_output})

  set(_outputs 
    ${_output}Lexer.cpp
    ${_output}Lexer.h
    ${_output}Parser.cpp
    ${_output}Parser.h
  )

  set(_visitor_arg "-no-visitor")
  if(${_visitor})
    set(_visitor_arg "-visitor")
    set(_output
      ${_output}
      ${_output}BaseVisitor.cpp
      ${_output}BaseVisitor.h
      ${_output}Visitor.cpp
      ${_output}Visitor.h
    )
  endif()

  set(_listener_arg "-no-listener")
  if(${_listener})
    set(_listener_arg "-listener")
    set(_output 
      ${_output}
      ${_output}BaseListener.cpp
      ${_output}BaseListener.h
      ${_output}Listener.cpp
      ${_output}Listener.h
    )
  endif()

  add_custom_command(OUTPUT ${_outputs}
    DEPENDS ${_input}
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/generated VERBATIM
    COMMAND ${Java_JAVA_EXECUTABLE} -Xmx500M -cp ${ANTLR4_BUILD_DIR}/antlr4.jar org.antlr.v4.Tool ${_visitor_arg} ${_listener_arg} -package ${_namespace} -Dlanguage=Cpp ${_input}
  )
  
  target_sources(${_target} PRIVATE ${_outputs})

  target_include_directories(${_target} PRIVATE 
    ${CMAKE_CURRENT_BINARY_DIR}/generated
  )

  target_link_libraries(${_target} PRIVATE antlr4-runtime)


endfunction()
