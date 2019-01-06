include_guard(GLOBAL)
include(GoogleTest)
enable_testing()


set(GTEST_PREFIX "${CMAKE_CURRENT_BINARY_DIR}/.gtest")
set(GTEST_DIR "${CMAKE_CURRENT_BINARY_DIR}/gtest")

if(NOT EXISTS ${GTEST_DIR})
  file(MAKE_DIRECTORY ${GTEST_PREFIX})
  configure_file(${CMAKE_CURRENT_LIST_DIR}/CMakeLists.gtest "${GTEST_PREFIX}/CMakeLists.txt" @ONLY)

  execute_process(
    WORKING_DIRECTORY "${GTEST_PREFIX}"
    COMMAND ${CMAKE_COMMAND} -G "${CMAKE_GENERATOR}" .
  )

  execute_process(
    WORKING_DIRECTORY "${GTEST_PREFIX}"
    COMMAND ${CMAKE_COMMAND} --build .
  )

  list(APPEND CMAKE_PREFIX_PATH "${GTEST_PREFIX}")
endif()




#[[
set(CMAKE_UTILS_DIR ${CMAKE_CURRENT_LIST_DIR})
set(GTEST_BUILD_TYPE Release)

if(NOT GTEST_INSTALL_DIR)
  set(GTEST_INSTALL_DIR "${CMAKE_CURRENT_BINARY_DIR}/gtest")
endif()

function(build_gtest _GTEST_BUILD_TYPE)
  set(GTEST_BUILD_TYPE _GTEST_BUILD_TYPE)
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
  #find_package(GTest REQUIRED)
  include_directories(${GTEST_INSTALL_DIR}/include)
  link_directories(${GTEST_INSTALL_DIR}/lib)
endfunction()

function(add_gtest _target)
  target_link_libraries(${_target} PRIVATE ${GTEST_INSTALL_DIR}/lib/gtestd.lib)
endfunction()
]]