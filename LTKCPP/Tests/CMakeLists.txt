cmake_minimum_required(VERSION 3.6)

set(CMAKE_CONFIGURATION_TYPES Debug Release CACHE TYPE INTERNAL FORCE)

project(Tests)

message ("Tests LTKCPP_SRC_PATH = ${LTKCPP_SRC_PATH}")
message ("Tests LTKCPP_LIB_PATH = ${LTKCPP_LIB_PATH}")

find_package(LIBXML2 REQUIRED)
find_package(LIBXSLT REQUIRED)

include_directories(
${LIBXML2_INCLUDE_DIR}
${LIBXSLT_INCLUDE_DIR}
${LTKCPP_SRC_PATH}
${LTKCPP_LIB_PATH}
)

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
)

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
)

install(TARGETS dx201 llrp2xml xml2llrp
        RUNTIME DESTINATION ${INSTALL_BINDIR}
        LIBRARY DESTINATION ${INSTALL_LIBDIR}
        ARCHIVE DESTINATION ${INSTALL_LIBDIR})
