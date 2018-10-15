
include(ExternalProject)

find_package(Java COMPONENTS Runtime REQUIRED)

set(ANTLR_JAR ${CMAKE_CURRENT_BINARY_DIR}/antlr-4.7.1-complete.jar)

file(DOWNLOAD http://www.antlr.org/download/antlr-4.7.1-complete.jar ${ANTLR_JAR} )

set(ANTLR4_RUNTIME_DIR ${CMAKE_CURRENT_BINARY_DIR}/antlr4)

ExternalProject_Add(antlr4
  PREFIX .antlr4
  GIT_REPOSITORY https://github.com/antlr/antlr4.git
  GIT_TAG 4.7.1
  GIT_SHALLOW TRUE
  SOURCE_SUBDIR runtime/Cpp
  CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${ANTLR4_RUNTIME_DIR} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DBUILD_SHARED_LIBS=TRUE -BUILD_TESTS=FALSE -DLIBRARY_OUTPUT_PATH=${LIBRARY_OUTPUT_PATH}
  UPDATE_COMMAND ""
  BUILD_BYPRODUCTS ${ANTLR4_RUNTIME_DIR}/lib/antlr4-runtime.lib ${ANTLR4_RUNTIME_DIR}/lib/antlr4-runtime.dll ${ANTLR4_RUNTIME_DIR}/lib/antlr4-runtime-static.lib
)

link_directories(${ANTLR4_RUNTIME_DIR}/lib)

function(antlr_gen _target _input)

  add_dependencies(${_target} antlr4)

  get_filename_component(_input "${_input}" ABSOLUTE)
  get_filename_component(_output "${_input}" NAME_WE)

  set(_output ${CMAKE_CURRENT_BINARY_DIR}/${_output})

  set(_outputs 
    ${_output}BaseListener.cpp
    ${_output}BaseListener.h
    ${_output}BaseVisitor.cpp
    ${_output}BaseVisitor.h
    ${_output}Lexer.cpp
    ${_output}Lexer.h
    ${_output}Listener.cpp
    ${_output}Listener.h
    ${_output}Parser.cpp
    ${_output}Parser.h
    ${_output}Visitor.cpp
    ${_output}Visitor.h
  )

  add_custom_command(OUTPUT ${_outputs}
    DEPENDS ${_input}
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} VERBATIM
    COMMAND ${Java_JAVA_EXECUTABLE} -Xmx500M -cp ${ANTLR_JAR} org.antlr.v4.Tool -visitor -Dlanguage=Cpp ${_input}
  )
  target_sources(${_target} PRIVATE ${_outputs})
  target_include_directories(${_target} PRIVATE 
    ${ANTLR4_RUNTIME_DIR}/include/antlr4-runtime
    ${CMAKE_CURRENT_BINARY_DIR}
  )
    #[[
  target_link_libraries(${_target} PRIVATE
    ${ANTLR4_RUNTIME_DIR}/lib/antlr4-runtime
  )
  ]]
  target_link_libraries(${_target} PRIVATE antlr4-runtime)
endfunction()
