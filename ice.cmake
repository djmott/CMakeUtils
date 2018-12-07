
include_guard(GLOBAL)



function(ice_gen _target _slice)
	set(ICE_DIR "" CACHE PATH "Path to ICE")
	if(NOT EXISTS ${ICE_DIR}/bin OR NOT EXISTS ${ICE_DIR}/include OR NOT EXISTS ${ICE_DIR}/lib)
	  message(FATAL_ERROR "ICE SDK not found: ${ICE_DIR}")
	endif()

  get_filename_component(_slice_file ${_slice} ABSOLUTE)
  get_filename_component(_stub ${_slice} NAME_WE)
  set(_stub ${CMAKE_CURRENT_BINARY_DIR}/${_stub})
  
  add_custom_command(OUTPUT ${_stub}.cpp ${_stub}.h
    DEPENDS ${_slice} VERBATIM
    COMMAND ${ICE_DIR}/bin/slice2cpp ${_slice_file}
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
  )
  
  target_sources(${_target} PRIVATE ${_stub}.cpp ${_stub}.h ${_slice})

  target_compile_definitions(${_target} PRIVATE -DICE_CPP11_MAPPING)

  target_include_directories(${_target} PRIVATE
    ${CMAKE_CURRENT_BINARY_DIR}
    ${ICE_DIR}/include 
    ${ICE_DIR}/include/generated/cpp11)

  target_link_libraries(${_target} PRIVATE
    ${ICE_DIR}/lib/ice37++11d.lib
    ${ICE_DIR}/lib/IceDiscovery37++11D.lib
    ${ICE_DIR}/lib/IceLocatorDiscovery37++11D.lib
    ${ICE_DIR}/lib/IceSSL37++11D.lib
  )

endfunction()


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

include(FetchContent)

FetchContent_Declare(ice_runtime GIT_REPOSITORY https://github.com/zeroc-ice/ice.git GIT_SHALLOW TRUE)

FetchContent_Populate(ice_runtime)
]]