cmake_minimum_required(VERSION 3.6)

project(Library)

set(CMAKE_CONFIGURATION_TYPES Debug Release CACHE TYPE INTERNAL FORCE)

set(BUILD_SHARE_LIBS TRUE)
set(CMAKE_BUILD_SHARE_LIBS TRUE)
set(LTKCPP_SRC_PATH ${CMAKE_CURRENT_SOURCE_DIR})
set(LTKCPP_LIB_PATH ${CMAKE_CURRENT_BINARY_DIR})

set(CODE_GEN_H_XSLT "${LTKCPP_SRC_PATH}/ltkcpp_gen_h.xslt")
set(CODE_GEN_CPP_XSLT "${LTKCPP_SRC_PATH}/ltkcpp_gen_cpp.xslt")
set(LLRPDEF "${DEFINITIONS_PATH}/Core/llrp-1x0-def.xml")

# On Windows, we just assume the location. On Mac/Linux, we can figure it out
if(${CMAKE_SYSTEM_NAME} MATCHES "Windows")
set(LIBXML2_INCLUDE_DIR "${XMLLIBDIR}/include/libxml2")
set(LIBXML2_LIBRARIES "${XMLLIBDIR}/lib/libxml2.lib")
set(LIBXSLT_INCLUDE_DIR "${XMLLIBDIR}/include/libxslt")
set(LIBXSLT_LIBRARIES "${XMLLIBDIR}/lib/libxslt.lib")
set(LIBXSLT_XSLTPROC_EXECUTABLE "${XMLLIBDIR}/bin/xsltproc.exe")
set(LIBTYPE "STATIC")
else()
find_package(LIBXML2 REQUIRED)
find_package(LIBXSLT REQUIRED)
set(LIBTYPE "SHARED")
endif()

message ("CurrentBinDir: ${CMAKE_CURRENT_BINARY_DIR}")
message ("Include: ${CMAKE_CURRENT_SOURCE_DIR}/${PATH_MODIFIER}")

include_directories(
${LIBXML2_INCLUDE_DIR}
${LIBXSLT_INCLUDE_DIR}
${CMAKE_CURRENT_BINARY_DIR}
)

link_directories(
${CMAKE_CURRENT_BINARY_DIR}
)

# Textdecode has not been ported to windows yet
if(${CMAKE_SYSTEM_NAME} MATCHES "Windows")
set(TEXTDECODE "")
set(WINSOCK "Ws2_32.lib")
else()
set(TEXTDECODE "ltkcpp_xmltextdecode.cpp")
set(WINSOCK "")
endif()


add_library(ltklib ${LIBTYPE}
ltkcpp.h
ltkcpp_base.h
ltkcpp_connection.h
ltkcpp_frame.h
ltkcpp_platform.h
ltkcpp_xmltext.h
ltkcpp_array.cpp
ltkcpp_connection.cpp
ltkcpp_element.cpp
ltkcpp_encdec.cpp
ltkcpp_error.cpp
ltkcpp_framedecode.cpp
ltkcpp_frameencode.cpp
ltkcpp_frameextract.cpp
ltkcpp_genout.cpp
ltkcpp_hdrfd.cpp
ltkcpp_typeregistry.cpp
ltkcpp_xmltextencode.cpp
${TEXTDECODE}
)


set_target_properties(ltklib PROPERTIES OUTPUT_NAME ltkcpp) 
set_target_properties(ltklib PROPERTIES DEBUG_POSTFIX "d")
#set_target_properties(ltklib PROPERTIES VERSION "${LTKCPP_VERSION}")
#set_target_properties(ltklib PROPERTIES SOVERSION "${LTKCPP_VERSION}")

target_link_libraries(ltklib
	${LIBXML2_LIBRARIES}
	${LIBXSLT_LIBRARIES}
	${WINSOCK}
)

add_subdirectory(LLRP.org)

add_custom_target(out_ltkcpp_h
COMMENT "Generating out_ltkcpp.h"
COMMAND ${LIBXSLT_XSLTPROC_EXECUTABLE} --stringparam RegistryName Core -o out_ltkcpp.h ${CODE_GEN_H_XSLT} ${LLRPDEF}
)

add_custom_target(out_ltkcpp_inc
COMMENT "Generating out_ltkcpp.cpp"
COMMAND ${LIBXSLT_XSLTPROC_EXECUTABLE} --stringparam RegistryName Core -o out_ltkcpp.inc ${CODE_GEN_CPP_XSLT} ${LLRPDEF}
)

set_target_properties(out_ltkcpp_h PROPERTIES OBJECT_DEPENDS "${CODE_GEN_H_XSLT} out_ltkcpp.h")
set_target_properties(out_ltkcpp_inc PROPERTIES OBJECT_DEPENDS "${CODE_GEN_CPP_XSLT} out_ltkcpp.inc")

add_dependencies(ltklib
out_ltkcpp_h
out_ltkcpp_inc
)

install(TARGETS ltklib 
        RUNTIME DESTINATION ${INSTALL_BINDIR}
        LIBRARY DESTINATION ${INSTALL_LIBDIR}
        ARCHIVE DESTINATION ${INSTALL_LIBDIR})

install(FILES ltkcpp.h
ltkcpp_base.h
ltkcpp_connection.h
ltkcpp_frame.h
ltkcpp_platform.h
ltkcpp_xmltext.h
version.inc
${CMAKE_CURRENT_BINARY_DIR}/out_ltkcpp.h
DESTINATION ${INSTALL_INCLUDEDIR})
