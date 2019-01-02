include_guard(GLOBAL)

find_package(Java COMPONENTS Runtime REQUIRED)

include(ExternalProject)

set(ANTLR_INSTALL_PREFIX ${CMAKE_CURRENT_BINARY_DIR}/antlr)
if(MSVC)
  set(ANTLR_LIB "${ANTLR_INSTALL_PREFIX}/lib/antlr4-runtime.lib")
elseif("GNU" STREQUAL "${CMAKE_CXX_COMPILER_ID}")
  set(ANTLR_LIB "${ANTLR_INSTALL_PREFIX}/lib/libantlr4-runtime.dll.a")
endif()

file(DOWNLOAD http://www.antlr.org/download/antlr-4.7.1-complete.jar ${ANTLR_INSTALL_PREFIX}/bin/antlr4.jar)

ExternalProject_Add(antlr4_runtime
  PREFIX .antlr
  GIT_REPOSITORY https://github.com/antlr/antlr4.git
  GIT_TAG 4.7.1
  GIT_SHALLOW TRUE
  SOURCE_SUBDIR runtime/Cpp
  UPDATE_COMMAND ""
  PATCH_COMMAND ""
  INSTALL_DIR ${ANTLR_INSTALL_PREFIX}
  CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${ANTLR_INSTALL_PREFIX} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
    -DBUILD_SHARED_LIBS=TRUE -DBUILD_TESTS=FALSE
  )

add_custom_command(OUTPUT ${ANTLR_LIB} DEPENDS antlr4_runtime COMMAND ${CMAKE_COMMAND} -E echo "building antlr library" WORKING_DIRECTORY ${ANTLR_INSTALL_PREFIX}/lib)

add_custom_target(antlr ALL DEPENDS ${ANTLR_LIB} antlr4_runtime)

#[[
Generate antlr grammar
Parameters:
  INPUT <file> - required - input g4 grammar file
  VISITOR - optional - generate visitor sources
  LISTENER - optional - generate listener sources
  NAMESPACE <name> - optional - symbols produced in specified namespace

Variables:
  ANTLR_SOURCES - generated source files
  ANTLR_HEADERS - generated headers
]]
function(antlr_gen)
  set(_options VISITOR LISTENER)
  set(_single_args INPUT NAMESPACE)
  set(_multi_args)
  cmake_parse_arguments(antlr "${_options}" "${_single_args}" "${_multi_args}" ${ARGN})

  get_filename_component(_input ${antlr_INPUT} ABSOLUTE)
  get_filename_component(_infile ${antlr_INPUT} NAME_WE)

  set(ANTLR_SOURCES ${_infile}Lexer.cpp ${_infile}Parser.cpp)
  set(ANTLR_HEADERS ${_infile}Lexer.h ${_infile}Parser.h)

  set(_cmd ${Java_JAVA_EXECUTABLE} -Xmx500M -cp ${ANTLR_INSTALL_PREFIX}/bin/antlr4.jar org.antlr.v4.Tool -Dlanguage=Cpp)

  if(antlr_VISITOR)
    set(_cmd ${_cmd} -visitor)
    set(ANTLR_SOURCES ${ANTLR_SOURCES} ${_infile}BaseVisitor.cpp ${_infile}Visitor.cpp)
    set(ANTLR_HEADERS ${ANTLR_HEADERS} ${_infile}BaseVisitor.h ${_infile}Visitor.h)
  else()
    set(_cmd ${_cmd} -no-visitor)
  endif()

  if(antlr_LISTENER)
    set(_cmd ${_cmd} -listener)
    set(ANTLR_SOURCES ${ANTLR_SOURCES} ${_infile}BaseListener.cpp ${_infile}Listener.cpp)
    set(ANTLR_HEADERS ${ANTLR_HEADERS} ${_infile}BaseListener.h ${_infile}Listener.h)
  else()
    set(_cmd ${_cmd} -no-listener)
  endif()

  if(antlr_NAMESPACE)
    set(_cmd ${_cmd} -package ${antlr_NAMESPACE})
  endif()


  set(ANTLR_SOURCES ${ANTLR_SOURCES} PARENT_SCOPE)
  set(ANTLR_HEADERS ${ANTLR_HEADERS} PARENT_SCOPE)

  set(_cmd ${_cmd} ${_input})

  add_custom_command(
    OUTPUT ${_output} ${ANTLR_SOURCES} ${ANTLR_HEADERS}
    DEPENDS antlr4_runtime ${_input}
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} VERBATIM
    COMMAND ${CMAKE_COMMAND} -E echo ${_cmd}
    COMMAND ${_cmd}
  )

  set(ANTLR_INCLUDE_DIR ${ANTLR_INSTALL_PREFIX}/include/antlr4-runtime PARENT_SCOPE)
endfunction()