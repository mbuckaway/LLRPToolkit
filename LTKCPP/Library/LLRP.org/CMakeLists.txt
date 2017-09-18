cmake_minimum_required(VERSION 3.6)

set(CMAKE_CONFIGURATION_TYPES Debug Release CACHE TYPE INTERNAL FORCE)

project(LLRP.org)

set(LLRPORGDEF   "${DEFINITIONS_PATH}/LLRP.org/LLRPOrgExampleDef.xml")
set(CODE_GEN_H_XSLT "${LTKCPP_SRC_PATH}/ltkcpp_gen_h.xslt")
set(CODE_GEN_CPP_XSLT "${LTKCPP_SRC_PATH}/ltkcpp_gen_cpp.xslt")
set(OUTDIR "${OUTDIR}/${PROJECT_NAME}")

message ("LTKCPP_SRC_PATH = ${LTKCPP_SRC_PATH}")
message ("LTKCPP_LIB_PATH = ${LTKCPP_LIB_PATH}")

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

include_directories(
${LIBXML2_INCLUDE_DIR}
${LIBXSLT_INCLUDE_DIR}
${LTKCPP_SRC_PATH}
${CMAKE_CURRENT_BINARY_DIR}
)

add_library(llrplib ${LIBTYPE}
llrporg_ltkcpp.h
llrporg_ltkcpp_genout.cpp
)

set_target_properties(llrplib PROPERTIES OUTPUT_NAME llrplib) 
set_target_properties(llrplib PROPERTIES DEBUG_POSTFIX "d")
#set_target_properties(llrplib PROPERTIES VERSION "${LTKCPP_VERSION}")

target_link_libraries(llrplib 
	${LIBXML2_LIBRARIES}
	${LIBXSLT_LIBRARIES}
	$<TARGET_LINKER_FILE:ltklib>
)

add_custom_target(out_llrporg_ltkcpp_h
COMMENT "Generating out_llrporg_ltkcpp.h"
COMMAND ${LIBXSLT_XSLTPROC_EXECUTABLE} --stringparam RegistryName LLRPOrg -o out_llrporg_ltkcpp.h ${CODE_GEN_H_XSLT} ${LLRPORGDEF}
)

add_custom_target(out_llrporg_ltkcpp_inc
COMMENT "Generating out_llrporg_ltkcpp.inc"
COMMAND ${LIBXSLT_XSLTPROC_EXECUTABLE} --stringparam RegistryName LLRPOrg -o out_llrporg_ltkcpp.inc ${CODE_GEN_CPP_XSLT} ${LLRPORGDEF}
)

set_target_properties(out_llrporg_ltkcpp_h PROPERTIES OBJECT_DEPENDS out_llrporg_ltkcpp.h)
set_target_properties(out_llrporg_ltkcpp_inc PROPERTIES OBJECT_DEPENDS out_llrporg_ltkcpp.inc)

add_dependencies(llrplib
out_llrporg_ltkcpp_h
out_llrporg_ltkcpp_inc
)

install(TARGETS llrplib
        RUNTIME DESTINATION ${INSTALL_BINDIR}
        LIBRARY DESTINATION ${INSTALL_LIBDIR}
        ARCHIVE DESTINATION ${INSTALL_LIBDIR})

install(FILES
llrporg_ltkcpp.h
${CMAKE_CURRENT_BINARY_DIR}/out_llrporg_ltkcpp.h
DESTINATION ${INSTALL_INCLUDEDIR})
