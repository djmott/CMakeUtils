include_guard(GLOBAL)

enable_testing()


set(CMAKE_UTILS_DIR ${CMAKE_CURRENT_LIST_DIR})

function(build_gtest)
  set(GTEST_INSTALL_DIR "${CMAKE_CURRENT_BINARY_DIR}/gtest")
  if(NOT EXISTS ${GTEST_INSTALL_DIR})
    configure_file(${CMAKE_UTILS_DIR}/CMakeLists.gtest "${CMAKE_CURRENT_BINARY_DIR}/.gtest/CMakeLists.txt" @ONLY)

    execute_process(
      WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/.gtest/"
      COMMAND ${CMAKE_COMMAND} -G "${CMAKE_GENERATOR}" .
    )

    execute_process(
      WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/.gtest/"
      COMMAND ${CMAKE_COMMAND} --build .
    )

    list(APPEND CMAKE_PREFIX_PATH "${CMAKE_CURRENT_BINARY_DIR}/.gtest")
  endif()
  set(GTEST_ROOT ${GTEST_INSTALL_DIR})
  find_package(GTest REQUIRED)
  include_directories(${GTEST_INCLUDE_DIRS})
endfunction()