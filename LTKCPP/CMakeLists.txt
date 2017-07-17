cmake_minimum_required(VERSION 3.6)

project(LTKCPP)

set(LTKCPP_SRC_PATH "${CMAKE_CURRENT_SOURCE_DIR}/Library")
set(LTKCPP_LIB_PATH "${CMAKE_CURRENT_BINARY_DIR}/Library")
set(TOP_PATH "${CMAKE_CURRENT_SOURCE_DIR}")

add_subdirectory(Library)
add_subdirectory(Examples)
add_subdirectory(Tests)
#add_subdirectory(Release)

