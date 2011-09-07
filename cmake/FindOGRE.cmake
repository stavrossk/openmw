# Find OGRE includes and library
#
# This module defines
#  OGRE_INCLUDE_DIR
#  OGRE_LIBRARIES, the libraries to link against to use OGRE.
#  OGRE_LIB_DIR, the location of the libraries
#  OGRE_FOUND, If false, do not try to use OGRE
#
# Copyright © 2007, Matt Williams
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
CMAKE_POLICY(PUSH)

IF (OGRE_LIBRARIES AND OGRE_INCLUDE_DIR AND OGRE_LIB_DIR AND OGRE_PLUGIN_DIR)
    SET(OGRE_FIND_QUIETLY TRUE) # Already in cache, be silent
ENDIF (OGRE_LIBRARIES AND OGRE_INCLUDE_DIR AND OGRE_LIB_DIR AND OGRE_PLUGIN_DIR)

IF (WIN32) #Windows
    MESSAGE(STATUS "Looking for OGRE")
    SET(OGRESDK $ENV{OGRE_HOME})
    SET(OGRESOURCE $ENV{OGRE_SRC})
    IF (OGRESDK)
        MESSAGE(STATUS "Using OGRE SDK")
        STRING(REGEX REPLACE "[\\]" "/" OGRESDK "${OGRESDK}")
        SET(OGRE_INCLUDE_DIR ${OGRESDK}/include)
        SET(OGRE_LIB_DIR ${OGRESDK}/lib)
        SET(OGRE_LIBRARIES debug OgreMain_d optimized OgreMain)
    ENDIF (OGRESDK)
    IF (OGRESOURCE)
        MESSAGE(STATUS "Using OGRE built from source")
        SET(OGRE_INCLUDE_DIR $ENV{OGRE_SRC}/OgreMain/include)
        SET(OGRE_LIB_DIR $ENV{OGRE_SRC}/lib)
        SET(OGRE_LIBRARIES debug OgreMain_d optimized OgreMain)
    ENDIF (OGRESOURCE)
ENDIF (WIN32)

IF (UNIX AND NOT APPLE)
    CMAKE_MINIMUM_REQUIRED(VERSION 2.4.7 FATAL_ERROR)
    FIND_PACKAGE(PkgConfig REQUIRED)
    # Don't mark REQUIRED, but use PKG_CHECK_MODULES below (otherwise PkgConfig
    # complains even if OGRE_* are set by hand).
    PKG_SEARCH_MODULE(OGRE OGRE)
    SET(OGRE_INCLUDE_DIR ${OGRE_INCLUDE_DIRS})
    SET(OGRE_LIB_DIR ${OGRE_LIBDIR})
    SET(OGRE_LIBRARIES ${OGRE_LIBRARIES} CACHE STRING "")
    PKG_CHECK_MODULES(OGRE OGRE)
ENDIF (UNIX AND NOT APPLE)

# on OS X we need Ogre SDK because framework doesn't include all libs, just Ogre Main lib
IF (APPLE)
	IF (OGRESDK)
		MESSAGE(STATUS "Using Ogre SDK")
		SET(OGRE_LIB_DIR ${OGRESDK}/lib)
	ELSE (OGRESDK)
		MESSAGE(FATAL_ERROR "Path to Ogre SDK not specified. Specify OGRESDK.")
	ENDIF (OGRESDK)
		

	FIND_PATH(OGRE_INCLUDE_DIR Ogre.h
		PATHS
		/Library/Frameworks
		/opt/local
	)
	FIND_LIBRARY(OGRE_LIBRARIES
		NAMES Ogre
		PATHS
		/Library/Frameworks
		/opt/local
	)
ENDIF (APPLE)

#Do some preparation
SEPARATE_ARGUMENTS(OGRE_INCLUDE_DIR)
SEPARATE_ARGUMENTS(OGRE_LIBRARIES)

SET(OGRE_INCLUDE_DIR ${OGRE_INCLUDE_DIR} CACHE PATH "")
SET(OGRE_LIBRARIES ${OGRE_LIBRARIES} CACHE STRING "")
SET(OGRE_LIB_DIR ${OGRE_LIB_DIR} CACHE PATH "")

if(OGRE_LIB_DIR)
    CMAKE_POLICY(SET CMP0009 NEW)
    IF (NOT APPLE)
	   	FILE(GLOB_RECURSE OGRE_PLUGINS "${OGRE_LIB_DIR}/Plugin_*.so")
	ENDIF (NOT APPLE)
	IF (APPLE)
   		FILE(GLOB_RECURSE OGRE_PLUGINS "${OGRE_LIB_DIR}/Plugin_*.dylib")
   	ENDIF (APPLE)
    FOREACH (OGRE_PLUGINS_FILE ${OGRE_PLUGINS})
        STRING(REGEX REPLACE "/[^/]*$" "" OGRE_PLUGIN_DIR ${OGRE_PLUGINS_FILE})
    ENDFOREACH(OGRE_PLUGINS_FILE)
endif()

IF (OGRE_INCLUDE_DIR AND OGRE_LIBRARIES)
    SET(OGRE_FOUND TRUE)
ENDIF (OGRE_INCLUDE_DIR AND OGRE_LIBRARIES)

IF (OGRE_FOUND)
    IF (NOT OGRE_FIND_QUIETLY)
        MESSAGE(STATUS "  libraries : ${OGRE_LIBRARIES} from ${OGRE_LIB_DIR}")
        MESSAGE(STATUS "  includes  : ${OGRE_INCLUDE_DIR}")
        MESSAGE(STATUS "  plugins   : ${OGRE_PLUGIN_DIR}")
    ENDIF (NOT OGRE_FIND_QUIETLY)
ELSE (OGRE_FOUND)
    IF (OGRE_FIND_REQUIRED)
        MESSAGE(FATAL_ERROR "Could not find OGRE")
    ENDIF (OGRE_FIND_REQUIRED)
ENDIF (OGRE_FOUND)

CMAKE_POLICY(POP)