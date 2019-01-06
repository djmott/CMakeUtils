include_guard(GLOBAL)
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
endif()

if(NOT "" STREQUAL "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")
  file(GLOB _tmp "${GTEST_DIR}/bin/*")
  file(COPY ${_tmp} DESTINATION "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")
endif()

list(APPEND CMAKE_PREFIX_PATH "${GTEST_DIR}/lib/cmake/GTest")
set(GTEST_INCLUDE_DIR "${GTEST_DIR}/include")
if("Debug" STREQUAL "${CMAKE_BUILD_TYPE}")
  set(GTEST_LIBRARY "${GTEST_DIR}/lib/gtestd")
  set(GTEST_MAIN_LIBRARY "${GTEST_DIR}/lib/gtest_maind")
else()
  set(GTEST_LIBRARY "${GTEST_DIR}/lib/gtest")
  set(GTEST_MAIN_LIBRARY "${GTEST_DIR}/lib/gtest_main")
endif()

if(MSVC)
  set(GTEST_LIBRARY "${GTEST_LIBRARY}.lib")
  set(GTEST_MAIN_LIBRARY "${GTEST_MAIN_LIBRARY}.lib")
endif()

find_package(GTest REQUIRED)
include(GoogleTest)
