
include_guard(GLOBAL)

#[[
include(ExternalProject)

#https://github.com/zeroc-ice/ice.git

ExternalProject_Add(ice
  PREFIX "${CMAKE_CURRENT_BINARY_DIR}}/.ice"
  INSTALL_DIR "${CMAKE_CURRENT_BINARY_DIR}}/ice"
  GIT_REPOSITORY https://github.com/zeroc-ice/ice.git
  GIT_SHALLOW TRUE
  CONFIGURE_COMMAND ""


  )
]]

include(FetchContent)

FetchContent_Declare(ice_runtime GIT_REPOSITORY https://github.com/zeroc-ice/ice.git GIT_SHALLOW TRUE)

FetchContent_Populate(ice_runtime)