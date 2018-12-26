
find_program(GCC
  gcc NAMES gcc gcc.exe
  PATHS /usr/bin /bin
  DOC "Path to gcc"
)

if(NOT EXISTS ${GCC})
  message(FATAL_ERROR "gcc not found")
endif()

#[[
Compile source with gcc

Parameters:

  INPUT <file> - required - input source file
  OUTPUT <file> - required - generated binary
  BITS <bits> - optional - specify machine type (default 64) can be one of the following:
    32    32 bit build
    64    64 bit build
  NOEXCEPTIONS - optional - passes -fno-exceptions
  NORTTI - optional - passes -fno-rtti
  WALL - optonal - passes -Wall
  WEXTRA - optional - passes -Wextra
  FREESTANDING - optional - passes -ffreestanding
]]

function(gcc)

  set(_options NOEXCEPTIONS NORTTI WALL WEXTRA FREESTANDING)
  set(_single_args INPUT OUTPUT BITS)
  set(_multi_args)
  cmake_parse_arguments(gcc "${_options}" "${_single_args}" "${_mutli_args}" ${ARGN})

  get_filename_component(gcc_INPUT ${gcc_INPUT} ABSOLUTE)

  set(_bits_arg -m64)
  if(gcc_BITS)
    set(_bits_arg "-m${gcc_BITS}")
  endif()

  set(_cmd
    ${GCC} -o ${gcc_OUTPUT} -c ${gcc_INPUT}
    ${_bits_arg}
    $<$<BOOL:gcc_NOEXCEPTIONS>:-fno-exceptions>
    $<$<BOOL:gcc_NORTTI>:-fno-rtti>
    $<$<BOOL:gcc_WALL>:-Wall>
    $<$<BOOL:gcc_WEXTRA>:-Wextra>
    $<$<BOOL:gcc_FREESTANDING>:-ffreestanding>
    )

  add_custom_command(
    OUTPUT ${gcc_OUTPUT}
    DEPENDS ${gcc_INPUT}
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} VERBATIM
    COMMAND ${CMAKE_COMMAND} -E echo ${_cmd}
    COMMAND ${_cmd}
  )
endfunction()