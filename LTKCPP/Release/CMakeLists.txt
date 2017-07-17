cmake_minimum_required(VERSION 3.6)

project(Release)

if(${CMAKE_SYSTEM_NAME} MATCHES "Windows")
message ("Documentation will not be generated on Windows")
else()

set (LTKCPP_HDRS
        ${LTKCPP_SRC_PATH}/ltkcpp.h
        ${LTKCPP_SRC_PATH}/ltkcpp_base.h
        ${LTKCPP_SRC_PATH}/ltkcpp_connection.h
        ${LTKCPP_SRC_PATH}/ltkcpp_frame.h
        ${LTKCPP_SRC_PATH}/ltkcpp_platform.h
        ${LTKCPP_SRC_PATH}/ltkcpp_xmltext.h
        ${LTKCPP_LIB_PATH}/out_ltkcpp.h
    )
        
FindDoxygen()

if (DOXYGEN_FOUND MATCHES "TRUE")
	add_custom_target(docs
	COMMENT "Generating documentation"
    COMMAND  rm -rf "${CMAKE_CURRENT_BINARY_DIR}/std"
    COMMAND  rm -f ltkcpp_dox.log
    COMMAND  mkdir -p "${CMAKE_CURRENT_BINARY_DIR}/std/libltkcpp"
    COMMAND  cp $(LTKCPP_FILES) std/libltkcpp/.
    COMMAND chmod 444 std/libltkcpp/*
    COMMAND mkdir std/libltkcpp/example
    COMMAND cp ../Examples/example1.cpp std/libltkcpp/example/example1.cpp
    COMMAND cp ../Examples/Example-Makefile std/libltkcpp/example/Makefile
    COMMAND chmod 644 std/libltkcpp/example/*
    COMMAND chmod 755 std/libltkcpp/example
    COMMAND mkdir std/Documentation
    COMMAND chmod 777 std/Documentation
    COMMAND( cat ltkcpp.dox ; echo OUTPUT_DIRECTORY="std/Documentation" ) | doxygen -
    chmod 755 std/Documentation
    chmod 755 std/libltkcpp
    chmod 755 std	
    )

endif()
endif()