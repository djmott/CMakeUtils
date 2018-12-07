
find_program(MIDL midl.exe)

function(midl_generate _idl)
  get_filename_component(_inc_dir ${_idl} DIRECTORY)
  get_filename_component(_header ${_idl} NAME_WE)
  get_filename_component(_server_stub ${_idl} NAME_WE)
  get_filename_component(_client_stub ${_idl} NAME_WE)
  set(_header ${_header}.h)
  set(_server_stub ${_server_stub}_s.c)
  set(_client_stub ${_client_stub}_c.c)
  #
  set(_env "win32")
#  if("${CMAKE_SIZEOF_VOID_P}" STREQUAL "8")
#    set(_env "win64")
#  endif()
  add_custom_command(OUTPUT ${_header} ${_server_stub} ${_client_stub}
    COMMAND ${MIDL} /nologo /oldnames /notlb /W2 /I ${_inc_dir} /env ${_env} /server stub /sstub ${_server_stub} /header ${_header} /client stub /cstub ${_client_stub} /out ${CMAKE_CURRENT_BINARY_DIR} ${_idl}
    DEPENDS ${_idl}
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} VERBATIM
  )
endfunction()

