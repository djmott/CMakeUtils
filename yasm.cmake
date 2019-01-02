
find_program(YASM
  NAMES yasm yasm.exe
  PATHS /usr/bin /bin
  DOC "Path to yasm"
  )


if(NOT EXISTS ${YASM})
  message(FATAL_ERROR "yasm not found")
endif()

#[[
Assemble file with yasm

Signature:
  yasm(INPUT <input> OUTPUT <output> [FORMAT <format>] [SYNTAX <syntax>] [DEBUG_FORMAT <debug_format>]
    [LIST_FILE <list_file>] [MAP_FILE <map_file>] [DEFINES <define...>
  )

Parameters:

  INPUT - required - assembler source file

  OUTPUT -  required - desired assembled binary file

  FORMAT - optional - output format (default 'elf') can be one of the following:
      dbg         Trace of all info passed to object format module
      bin         Flat format binary
      dosexe      DOS .EXE format binary
      elf         ELF
      elf32       ELF (32-bit)
      elf64       ELF (64-bit)
      elfx32      ELF (x32)
      coff        COFF (DJGPP)
      macho       Mac OS X ABI Mach-O File Format
      macho32     Mac OS X ABI Mach-O File Format (32-bit)
      macho64     Mac OS X ABI Mach-O File Format (64-bit)
      rdf         Relocatable Dynamic Object File Format (RDOFF) v2.0
      win32       Win32
      win64       Win64
      x64         Win64
      xdf         Extended Dynamic Object

  SYNTAX - optional - input file asm syntax (default 'nasm') can be one of the following:
      gas         GNU AS (GAS)-compatible parser
      gnu         GNU AS (GAS)-compatible parser
      nasm        NASM-compatible parser
      tasm        TASM-compatible parser

  DEBUG_FORMAT - optional - format of debug info (default 'null') can be one of the following:
      cv8         CodeView debugging format for VC8
      dwarf2      DWARF2 debugging format
      null        No debugging info
      stabs       Stabs debugging format

  LIST_FILE - optional - listing file to generate

  MAP_FILE - optional - map file to generate

]]
function(yasm)
  set(options MAP LISTING)
  set(single_args INPUT OUTPUT FORMAT SYNTAX DEBUG_FORMAT LIST_FILE MAP_FILE)
  set(multi_args DEFINES)
  cmake_parse_arguments(yasm "${options}" "${single_args}" "${multi_args}" ${ARGN})

  set(_output ${yasm_OUTPUT})
  get_filename_component(yasm_INPUT ${yasm_INPUT} ABSOLUTE)

  set(_list_args)
  if(yasm_LIST_FILE)
    list(APPEND _output ${yasm_LIST_FILE})
    set(_list_args -l ${yasm_LIST_FILE})
  endif()

  set(_map_args)
  if(yasm_MAP_FILE)
    list(APPEND _output ${yasm_MAP_FILE})
    set(_map_args --mapfile=${yasm_MAP_FILE})
  endif()

  if(NOT yasm_SYNTAX)
    set(yasm_SYNTAX "nasm")
  endif()

  if(NOT yasm_FORMAT)
    set(yasm_FORMAT "elf")
  endif()

  set(_cmd ${YASM} ${_list_args} ${_map_args} -f ${yasm_FORMAT} -p ${yasm_SYNTAX} -g ${yasm_DEBUG_FORMAT} -o ${yasm_OUTPUT} ${yasm_INPUT})

  add_custom_command(
    OUTPUT ${_output}
    DEPENDS ${yasm_INPUT}
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} VERBATIM
    COMMAND ${CMAKE_COMMAND} -E echo ${_cmd}
    COMMAND ${_cmd}
  )
endfunction()