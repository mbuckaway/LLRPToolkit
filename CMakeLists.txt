cmake_minimum_required(VERSION 3.6)

set(CMAKE_CONFIGURATION_TYPES Debug Release CACHE TYPE INTERNAL FORCE)

project(ltkcpp)

# MacOSX requires more digits for a version
if(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
set(LTKCPP_VERSION "1.0.0.10.0")
else()
set(LTKCPP_VERSION "1.0.0.10")
endif()

message("LTKCPP Version ${LTKCPP_VERSION}")

#set (CMAKE_BUILD_TYPE "DEBUG")

if (NOT DEFINED CMAKE_BUILD_TYPE)
message(FATAL_ERROR  "Build type is not defined")
endif()

if(${CMAKE_SYSTEM_NAME} MATCHES "Linux") 
if (NOT DEFINED CXXFLAGS)
  set(CXXFLAGS, "-m64 -ggdb3")
endif()
else()
if (NOT DEFINED CXXFLAGS)
  set(CXXFLAGS, "-m64")
endif()
endif()

set(DEFINITIONS_PATH "${CMAKE_CURRENT_SOURCE_DIR}/Definitions")


set(BUILD_SHARE_LIBS TRUE)
set(CMAKE_BUILD_SHARE_LIBS TRUE)

set(INSTALL_LIBDIR "${CMAKE_CURRENT_SOURCE_DIR}/lib")
set(INSTALL_INCLUDEDIR "${CMAKE_CURRENT_SOURCE_DIR}/include")
set(INSTALL_BINDIR "${CMAKE_CURRENT_SOURCE_DIR}/bin")

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})

if(${CMAKE_SYSTEM_NAME} MATCHES "Windows")
 set(LIB_PREFIX "")
 set(LIB_SUFFIX dll)
 set(XMLLIBDIR "${CMAKE_CURRENT_SOURCE_DIR}/..")
 message("Building for Windows")
elseif(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
 #set(CMAKE_MACOSX_RPATH ON)
 set(LIB_PREFIX lib)
 set(LIB_SUFFIX dylib)
elseif(${CMAKE_SYSTEM_NAME} MATCHES "Linux") 
 set(LIB_PREFIX lib)
 set(LIB_SUFFIX so)
 message("Building for Linux")
endif()

# Fix up the CXX/CFLAGS for platform specific issues
if(${CMAKE_SYSTEM_NAME} MATCHES "Linux") 
 set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++0x")	
elseif(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
 set(MACOSX_RPATH "true")
 set(CMAKE_OSX_ARCHITECTURES, x86_64)
 set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${CXXFLAGS} -std=c++0x -stdlib=libc++ -mmacosx-version-min=10.7")	
 set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${CFLAGS} -mmacosx-version-min=10.7")
elseif(${CMAKE_SYSTEM_NAME} MATCHES "Windows")
 set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /Zc:wchar_t,auto,rvalueCast /EHsc /GR")	
 set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /Zc:wchar_t,auto,rvalueCast /EHsc /GR")
endif()

# Fix for Visual Studio machine vs target architecture issue.
set(CMAKE_EXE_LINKER_FLAGS "")
set(CMAKE_SHARED_LINKER_FLAGS "")

add_subdirectory(LTKCPP) 

set(variables
  CMAKE_C_FLAGS
  CMAKE_C_FLAGS_DEBUG
  CMAKE_C_FLAGS_MINSIZEREL
  CMAKE_C_FLAGS_RELEASE
  CMAKE_C_FLAGS_RELWITHDEBINFO
  CMAKE_CXX_FLAGS
  CMAKE_CXX_FLAGS_DEBUG
  CMAKE_CXX_FLAGS_MINSIZEREL
  CMAKE_CXX_FLAGS_RELEASE
  CMAKE_CXX_FLAGS_RELWITHDEBINFO
  CMAKE_LINK_FLAGS_DEBUG
  CMAKE_LINK_FLAGS_MINSIZEREL
  CMAKE_LINK_FLAGS_RELEASE
  CMAKE_LINK_FLAGS_RELWITHDEBINFO
)
message(STATUS "Initial build flags:")
foreach(variable ${variables})
  message(STATUS "  '${variable}': ${${variable}}")
endforeach()
message(STATUS "")
