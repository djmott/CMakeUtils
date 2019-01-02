
find_program(GCC
  NAMES gcc gcc.exe
  PATHS /usr/bin /bin
  DOC "Path to gcc"
)

if(NOT EXISTS ${GCC})
  message(FATAL_ERROR "gcc not found")
endif()

#[[
Compile source with gcc

Parameters:
  INPUT <file...> - required - list of inputs
  OUTPUT <file> - required - generated binary
  BITS <bits> - optional - specify machine type (default 64) can be one of the following:
    32    32 bit build
    64    64 bit build
  LINK_SCRIPT <file> - optional - use linker script by passing -T <file>
  FREESTANDING - optional - passes -ffreestanding
  NOEXCEPTIONS - optional - passes -fno-exceptions
  NORTTI - optional - passes -fno-rtti
  NOSTDLIB - optional - passes -nostdlib
  WALL - optonal - passes -Wall
  WEXTRA - optional - passes -Wextra
]]

function(gcc)

  set(_options NOEXCEPTIONS NORTTI WALL WEXTRA FREESTANDING)
  set(_single_args OUTPUT BITS LINK_SCRIPT)
  set(_multi_args INPUTS)
  cmake_parse_arguments(gcc "${_options}" "${_single_args}" "${_multi_args}" ${ARGN})

  set(_cmd ${GCC} -o ${gcc_OUTPUT})

  if(gcc_BITS)
    set(_cmd ${_cmd} -m${gcc_BITS})
  else()
    set(_cmd ${_cmd} -m64)
  endif()

  if(gcc_LINK_SCRIPT)
    get_filename_component(gcc_LINK_SCRIPT ${gcc_LINK_SCRIPT} ABSOLUTE)
    set(_cmd ${_cmd} -T ${gcc_LINK_SCRIPT})
  endif()

  if(gcc_NOEXCEPTIONS)
    set(_cmd ${_cmd} -fno-exceptions)
  endif()

  if(gcc_NORTTI)
    set(_cmd ${_cmd} -fno-rtti)
  endif()

  if(gcc_WALL)
    set(_cmd ${_cmd} -Wall)
  endif()

  if(gcc_WEXTRA)
    set(_cmd ${_cmd} -Wextra)
  endif()

  if(gcc_FREESTANDING)
    set(_cmd ${_cmd} -ffreestanding)
  endif()

  if(gcc_NOSTDLIB)
    set(_cmd ${_cmd} -nostdlib)
  endif()

  foreach(_tmp ${gcc_INPUTS})
    get_filename_component(_tmp ${_tmp} ABSOLUTE)
    set(_cmd ${_cmd} ${_tmp})
  endforeach()

  add_custom_command(
    OUTPUT ${gcc_OUTPUT}
    DEPENDS ${gcc_INPUT} ${gcc_INPUTS}
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} VERBATIM
    COMMAND ${CMAKE_COMMAND} -E echo ${_cmd}
    COMMAND ${_cmd}
  )
endfunction()