cmake_minimum_required(VERSION 3.6)

set(CMAKE_CONFIGURATION_TYPES Debug Release CACHE TYPE INTERNAL FORCE)

project(Examples)

message ("Examples LTKCPP_SRC_PATH = ${LTKCPP_SRC_PATH}")
message ("Examples LTKCPP_LIB_PATH = ${LTKCPP_LIB_PATH}")

if(${CMAKE_SYSTEM_NAME} MATCHES "Windows")
set(LIBXML2_INCLUDE_DIR "${XMLLIBDIR}/include/libxml2")
set(LIBXML2_LIBRARIES "${XMLLIBDIR}/lib/libxml2.lib")
set(LIBXSLT_INCLUDE_DIR "${XMLLIBDIR}/include/libxslt")
set(LIBXSLT_LIBRARIES "${XMLLIBDIR}/lib/libxslt.lib")
set(LIBXSLT_XSLTPROC_EXECUTABLE "${XMLLIBDIR}/bin/xsltproc.exe")
set(WINSOCK "Ws2_32.lib")
else()
find_package(LIBXML2 REQUIRED)
find_package(LIBXSLT REQUIRED)
set(WINSOCK "")
endif()


include_directories(
${LIBXML2_INCLUDE_DIR}
${LIBXSLT_INCLUDE_DIR}
${LTKCPP_SRC_PATH}
${LTKCPP_LIB_PATH}
)

add_executable(example1
example1.cpp
)

set_target_properties(example1 PROPERTIES OUTPUT_NAME example1) 
set_target_properties(example1 PROPERTIES DEBUG_POSTFIX "d")

target_link_libraries(example1 
	${LIBXML2_LIBRARIES}
	${LIBXSLT_LIBRARIES}
	$<TARGET_LINKER_FILE:ltklib>
	$<TARGET_LINKER_FILE:llrplib>
	${WINSOCK}
)

install(TARGETS example1
        RUNTIME DESTINATION ${INSTALL_BINDIR}
        LIBRARY DESTINATION ${INSTALL_LIBDIR}
        ARCHIVE DESTINATION ${INSTALL_LIBDIR})
