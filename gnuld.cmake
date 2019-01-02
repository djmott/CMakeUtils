include_guard(GLOBAL)

find_program(LD
  NAMES ld ld.exe
  DOC "Path to GNU ld"
  )

if(NOT EXISTS ${LD})
  message(FATAL_ERROR "GNU ld not found")
endif()

function(ld)
  set(options MAP LISTING)
  set(single_args INPUT OUTPUT FORMAT SYNTAX DEBUG_FORMAT LIST_FILE MAP_FILE)
  set(multi_args DEFINES)
  cmake_parse_arguments(yasm "${options}" "${single_args}" "${mutli_args}" ${ARGN})


  add_custom_command(OUTPUT ${_target}
    DEPENDS ${_script}
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} VERBATIM
    COMMAND ${GNULD} -T ${_script}
  )

endfunction()