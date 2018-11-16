include_guard(GLOBAL)

find_program(GNULD NAMES ld ld.exe)


find_program(MASM NAMES "ml.exe" "ml64.exe")

function(ldlink _target _script)
  get_filename_component(_script ${_script} ABSOLUTE)

  add_custom_command(OUTPUT ${_target}
    DEPENDS ${_script}
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} VERBATIM
    COMMAND ${GNULD} -T ${_script}
  )

endfunction()