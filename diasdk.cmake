include_guard(GLOBAL)

set(DIA_SDK_ROOT ${CMAKE_CURRENT_LIST_DIR}/dia_sdk CACHE PATH "Location of the DIA SDK")

find_file(DIA2_H_PATH dia2.h PATHS ${DIA_SDK_ROOT}/include)

if(NOT DIA2_H_PATH)
  message(FATAL_ERROR "Could not find the DIA SDK")
endif()

add_library(DIA STATIC IMPORTED GLOBAL)

if(8 EQUAL ${CMAKE_SIZEOF_VOID_P})
  set(DIA_DLL ${DIA_SDK_ROOT}/bin/amd64/msdia140.dll)
  set_target_properties(DIA PROPERTIES IMPORTED_LOCATION ${DIA_SDK_ROOT}/lib/amd64/diaguids.lib)
else()
  set(DIA_DLL ${DIA_SDK_ROOT}/bin/msdia140.dll)
  set_target_properties(DIA PROPERTIES IMPORTED_LOCATION ${DIA_SDK_ROOT}/lib/diaguids.lib)
endif()

target_include_directories(DIA 
  INTERFACE ${DIA_SDK_ROOT}/include
  ${DIA_SDK_ROOT}/idl
)

if(CMAKE_RUNTIME_OUTPUT_DIRECTORY)
  file(COPY ${DIA_DLL} DESTINATION ${CMAKE_RUNTIME_OUTPUT_DIRECTORY})
endif()
