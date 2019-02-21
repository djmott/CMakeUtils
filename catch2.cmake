include_guard(GLOBAL)

find_package(Git REQUIRED)

configure_file(${CMAKE_CURRENT_LIST_DIR}/CMakeLists.catch2 ${CMAKE_CURRENT_BINARY_DIR}/.catch2/CMakeLists.txt @ONLY)

execute_process(
  COMMAND ${CMAKE_COMMAND} -G "${CMAKE_GENERATOR}"
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/.catch2
)

execute_process(
  COMMAND ${CMAKE_COMMAND} --build .
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/.catch2
)

list(APPEND CMAKE_PREFIX_PATH ${CMAKE_CURRENT_BINARY_DIR}/catch2/lib/cmake)