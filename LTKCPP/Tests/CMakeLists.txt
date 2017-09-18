cmake_minimum_required(VERSION 3.6)

set(CMAKE_CONFIGURATION_TYPES Debug Release CACHE TYPE INTERNAL FORCE)

project(Tests)

message ("Tests LTKCPP_SRC_PATH = ${LTKCPP_SRC_PATH}")
message ("Tests LTKCPP_LIB_PATH = ${LTKCPP_LIB_PATH}")

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

# Textdecode not supports on Windows, so we can't link this
if(NOT ${CMAKE_SYSTEM_NAME} MATCHES "Windows")
add_executable(xml2llrp
xml2llrp.cpp
)

set_target_properties(xml2llrp PROPERTIES OUTPUT_NAME xml2llrp) 
set_target_properties(xml2llrp PROPERTIES DEBUG_POSTFIX "d")

target_link_libraries(xml2llrp 
	${LIBXML2_LIBRARIES}
	${LIBXSLT_LIBRARIES}
	$<TARGET_LINKER_FILE:ltklib>
	$<TARGET_LINKER_FILE:llrplib>
	${WINSOCK}
)
endif()

add_executable(llrp2xml
llrp2xml.cpp
)

set_target_properties(llrp2xml PROPERTIES OUTPUT_NAME llrp2xml) 
set_target_properties(llrp2xml PROPERTIES DEBUG_POSTFIX "d")

target_link_libraries(llrp2xml 
	${LIBXML2_LIBRARIES}
	${LIBXSLT_LIBRARIES}
	$<TARGET_LINKER_FILE:ltklib>
	$<TARGET_LINKER_FILE:llrplib>
	${WINSOCK}
)

add_executable(dx201
dx201.cpp
)

set_target_properties(dx201 PROPERTIES OUTPUT_NAME dx201) 
set_target_properties(dx201 PROPERTIES DEBUG_POSTFIX "d")

target_link_libraries(dx201 
	${LIBXML2_LIBRARIES}
	${LIBXSLT_LIBRARIES}
	$<TARGET_LINKER_FILE:ltklib>
	$<TARGET_LINKER_FILE:llrplib>
	${WINSOCK}
)

if(${CMAKE_SYSTEM_NAME} MATCHES "Windows")
install(TARGETS dx201 llrp2xml
        RUNTIME DESTINATION ${INSTALL_BINDIR}
        LIBRARY DESTINATION ${INSTALL_LIBDIR}
        ARCHIVE DESTINATION ${INSTALL_LIBDIR})
else()
install(TARGETS dx201 llrp2xml xml2llrp
        RUNTIME DESTINATION ${INSTALL_BINDIR}
        LIBRARY DESTINATION ${INSTALL_LIBDIR}
        ARCHIVE DESTINATION ${INSTALL_LIBDIR})
endif()