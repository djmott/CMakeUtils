
find_program(YASM
  yasm NAMES yasm yasm.exe
  PATHS /usr/bin /bin
  DOC "Path to yasm"
  )


if(NOT EXISTS ${YASM})
  message(FATAL_ERROR "yasm not found")
endif()

function(yasm)
  set(options MAP LISTING)
  set(single_args INPUT OUTPUT FORMAT SYNTAX DEBUG_FORMAT LIST_FILE MAP_FILE)
  set(multi_args DEFINES)
  cmake_parse_arguments(yasm "${options}" "${single_args}" "${mutli_args}" ${ARGN})

  set(_cmd ${YASM})
  set(_output ${yasm_OUTPUT})
  get_filename_component(yasm_INPUT ${yasm_INPUT} ABSOLUTE)

  if(yasm_LIST_FILE AND ${yasm_LISTING})
    list(APPEND _output ${yasm_LIST_FILE})
    set(_cmd ${_cmd} -l ${yasm_LIST_FILE})
  endif()

  if(yasm_MAP_FILE AND ${yasm_MAP})
    list(APPEND _output ${yasm_MAP_FILE})
    set(_cmd ${_cmd} --mapfile=${yasm_MAP_FILE})
  endif()

  if(NOT yasm_SYNTAX)
    set(yasm_SYNTAX "nasm")
  endif()

  set(_cmd ${_cmd} -f ${yasm_FORMAT} -p ${yasm_SYNTAX} -g ${yasm_DEBUG_FORMAT} -o ${yasm_OUTPUT} ${yasm_INPUT})

  add_custom_command(
    OUTPUT ${_output}
    DEPENDS ${yasm_INPUT}
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} VERBATIM
    COMMAND ${CMAKE_COMMAND} -E echo ${_cmd}
    COMMAND ${_cmd}
  )
endfunction()