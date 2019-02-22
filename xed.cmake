include_guard(GLOBAL)



configure_file(${CMAKE_CURRENT_LIST_DIR}/CMakeLists.xed ${CMAKE_CURRENT_BINARY_DIR}/.xed/CMakeLists.txt @ONLY)

execute_process(
  COMMAND ${CMAKE_COMMAND} -G "${CMAKE_GENERATOR}" -DGIT_EXECUTABLE=${GIT_EXECUTABLE} -DPython2_EXECUTABLE=${Python2_EXECUTABLE}
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/.xed
)

execute_process(
  COMMAND ${CMAKE_COMMAND} --build .
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/.xed
)


add_library(xed STATIC IMPORTED GLOBAL)
add_library(xed-ild STATIC IMPORTED GLOBAL)

set_target_properties(xed PROPERTIES IMPORTED_LOCATION ${CMAKE_CURRENT_BINARY_DIR}/xed/lib/xed.lib)
set_target_properties(xed-ild PROPERTIES IMPORTED_LOCATION ${CMAKE_CURRENT_BINARY_DIR}/xed/lib/xed-ild.lib)

target_include_directories(xed INTERFACE ${CMAKE_CURRENT_BINARY_DIR}/xed/include)
target_include_directories(xed-ild INTERFACE ${CMAKE_CURRENT_BINARY_DIR}/xed/include)
