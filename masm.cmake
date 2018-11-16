include_guard(GLOBAL)

find_program(MASM NAMES "ml.exe" "ml64.exe")

function(assemble _target _input)
  get_filename_component(_input ${_input} ABSOLUTE)
  get_filename_component(_input_name ${_input} NAME_WE)
  set(_listing ${CMAKE_CURRENT_BINARY_DIR}/${_input_name}.lst)
  set(_output ${CMAKE_CURRENT_BINARY_DIR}/${_input_name}.obj)
  add_custom_command(OUTPUT ${_output}
    DEPENDS ${_input}
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} VERBATIM
    COMMAND ${MASM} /c /Fl${_listing} /Sa /Fo${_output} ${_input}
  )

endfunction()