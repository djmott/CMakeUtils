include_guard(GLOBAL)

find_program(CMAKE_CXX_CLANG_TIDY NAMES clang_tidy)
if (CMAKE_CXX_CLANG_TIDY)
  list(APPEND CMAKE_CXX_CLANG_TIDY
    "-checks=-*,readability-*,clang-analyzer-*,bugprone-*"
  )
endif()
