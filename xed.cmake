include_guard(GLOBAL)
include(ExternalProject)

find_package(Python2 COMPONENTS Interpreter REQUIRED)
find_package(Git REQUIRED)

set(XED_DIR ${CMAKE_CURRENT_BINARY_DIR}/xed)

file(MAKE_DIRECTORY ${XED_DIR})

add_custom_target(xed_checkout
  WORKING_DIRECTORY ${XED_DIR} VERBATIM
  COMMAND ${GIT_EXECUTABLE} clone https://github.com/intelxed/xed.git xed
  COMMAND ${GIT_EXECUTABLE} clone https://github.com/intelxed/mbuild.git mbuild
  )

add_custom_target(xed_build ALL
  DEPENDS xed_checkout
  WORKING_DIRECTORY ${XED_DIR}/xed
  COMMAND ${Python2_EXECUTABLE} mfile.py install
  )