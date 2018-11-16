include_guard(GLOBAL)

set(CMAKE_UTILS_DIR ${CMAKE_CURRENT_LIST_DIR})
function(build_gflags)
  set(GFLAGS_INSTALL_DIR "${CMAKE_CURRENT_BINARY_DIR}/gflags")
  if(NOT EXISTS ${GFLAGS_INSTALL_DIR})
    configure_file(${CMAKE_UTILS_DIR}/CMakeLists.gflags "${CMAKE_CURRENT_BINARY_DIR}/.gflags/CMakeLists.txt" @ONLY)

    execute_process(
      COMMAND ${CMAKE_COMMAND} -G "${CMAKE_GENERATOR}" -DCMAKE_INSTALL_PREFIX="${GFLAGS_INSTALL_DIR}" .
      WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/.gflags/"
    )
    execute_process(
      COMMAND ${CMAKE_COMMAND} --build .
      WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/.gflags/"
    )
  endif()
  find_package(gflags REQUIRED)

endfunction()
