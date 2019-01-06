include_guard(GLOBAL)

#ff7b08e0462664a89a6a55b60fcddf9c12d1d0dc
#sonar-scanner.bat -D"sonar.projectKey=NGCL" -D"sonar.sources=." -D"sonar.host.url=http://atlassian:9000" -D"sonar.login=ff7b08e0462664a89a6a55b60fcddf9c12d1d0dc"

#https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-3.2.0.1227.zip

find_package(Java COMPONENTS Runtime REQUIRED)

set(SONAR_DIR ${CMAKE_CURRENT_BINARY_DIR})
set(SONAR_SCANNER_VER 3.2.0.1227)

file(DOWNLOAD https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VER}.zip
  ${SONAR_DIR}/sonar-scanner-cli-${SONAR_SCANNER_VER}.zip)

add_custom_target(sonar-scanner-cli
  COMMAND ${CMAKE_COMMAND} -E tar xzf sonar-scanner-cli-${SONAR_SCANNER_VER}.zip
  WORKING_DIRECTORY ${SONAR_DIR} VERBATIM
)

add_custom_target(sonar_scanner ALL)

#[[
Scan a project with sonar-scanner
#]]
function(sonar_scan)
  set(_options)
  set(_single_args TARGET PROPERTIES)
  set(_multi_args)
  cmake_parse_arguments(sonar "${_options}" "${_single_args}" "${_multi_args}" ${ARGN})

  if(sonar_TARGET)
  else()
    message(FATAL_ERROR "Missing TARGET parameter")
  endif()

  if(sonar_PROPERTIES)
  else()
    message(FATAL_ERROR "Missing PROPERTIES parameter")
  endif()
  if(NOT EXISTS ${sonar_PROPERTIES})
    message(FATAL_ERROR "PROPERTIES file not found (${sonar_PROPERTIES})")
  endif()


  set(_cmd ${SONAR_DIR}/sonar-scanner-${SONAR_SCANNER_VER}/bin/sonar-scanner -X
    -Dproject.settings=${sonar_PROPERTIES})

  add_custom_command(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/.sonar.scan.stamp
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} VERBATIM
    DEPENDS ${sonar_TARGET} sonar-scanner-cli
    COMMAND ${CMAKE_COMMAND} -E echo ${_cmd}
    COMMAND ${_cmd}
  )

  add_custom_target(sonar_scan_${sonar_TARGET}
    DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/.sonar.scan.stamp
  )

  add_dependencies(sonar_scanner sonar_scan_${sonar_TARGET})

endfunction()
