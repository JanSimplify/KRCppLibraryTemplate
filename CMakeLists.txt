# SPDX-License-Identifier: MIT-0
# SPDX-FileCopyrightText: Copyright (c) 2025 JanSimplify

cmake_minimum_required(VERSION 3.25 FATAL_ERROR)

#=============================
# Project
#=============================

project(KRLibrary VERSION 1.0.0 LANGUAGES CXX)

if(PROJECT_SOURCE_DIR STREQUAL PROJECT_BINARY_DIR)
    message(
        FATAL_ERROR
        "In-source builds not allowed. "
        "Please make a new directory (called a build directory) and run CMake from there."
    )
endif()

string(TOLOWER ${PROJECT_NAME} project_name_lowercase)
string(TOUPPER ${PROJECT_NAME} project_name_uppercase)

#=============================
# Options
#=============================

include(CMakeDependentOption)

option(
    "${PROJECT_NAME}_USE_SHARED_LIBS"
    "Default to SHARED libraries"
    "${BUILD_SHARED_LIBS}"
)

option(
    "${PROJECT_NAME}_ENABLE_INSTALL_SHARED"
    "Install shared library"
    "${PROJECT_IS_TOP_LEVEL}"
)

option(
    "${PROJECT_NAME}_ENABLE_INSTALL_STATIC"
    "Install static library"
    "${PROJECT_IS_TOP_LEVEL}"
)

option(
    "${PROJECT_NAME}_ENABLE_ADDRESS_SANITIZER"
    "Enable address sanitizer"
    OFF
)

option(
    "${PROJECT_NAME}_ENABLE_CODE_COVERAGE"
    "Enable code coverage analysis"
    OFF
)

cmake_dependent_option(
    "${PROJECT_NAME}_ENABLE_TEST"
    "Enalbe test"
    ON
    "PROJECT_IS_TOP_LEVEL"
    OFF
)

cmake_dependent_option(
    "${PROJECT_NAME}_DEVELOP_MODE"
    "Enalbe develop mode"
    ON
    "PROJECT_IS_TOP_LEVEL"
    OFF
)

set(use_shared_libs "${${PROJECT_NAME}_USE_SHARED_LIBS}")

set(enable_install_shared "${${PROJECT_NAME}_ENABLE_INSTALL_SHARED}")
set(enable_install_static "${${PROJECT_NAME}_ENABLE_INSTALL_STATIC}")

set(enable_address_sanitizer "${${PROJECT_NAME}_ENABLE_ADDRESS_SANITIZER}")
set(enable_code_coverage "${${PROJECT_NAME}_ENABLE_CODE_COVERAGE}")

set(enable_test "${${PROJECT_NAME}_ENABLE_TEST}")
set(enable_develop_mode "${${PROJECT_NAME}_DEVELOP_MODE}")

#=============================
# Dependencies
#=============================

include(cmake/dependencies.cmake)

# set asan for catch2
if(enable_address_sanitizer)
    add_compile_options(
        "$<$<OR:$<COMPILE_LANG_AND_ID:C,MSVC>,$<COMPILE_LANG_AND_ID:CXX,MSVC>>:/fsanitize=address>"
    )
endif()

#=============================
# Targets
#=============================

set(static_export_name "static")
set(shared_export_name "shared")
set(library_export_name "${PROJECT_NAME}")

set(static_target "${PROJECT_NAME}_${static_export_name}")
set(shared_target "${PROJECT_NAME}_${shared_export_name}")

add_library("${static_target}" STATIC)
add_library("${shared_target}" SHARED)

set(static_alias_target "${PROJECT_NAME}::${static_export_name}")
set(shared_alias_target "${PROJECT_NAME}::${shared_export_name}")
set(library_alias_target "${PROJECT_NAME}::${library_export_name}")

add_library("${static_alias_target}" ALIAS "${static_target}")
add_library("${shared_alias_target}" ALIAS "${shared_target}")

if(use_shared_libs)
    add_library("${library_alias_target}" ALIAS "${shared_target}")
else()
    add_library("${library_alias_target}" ALIAS "${static_target}")
endif()

#=============================
# Headers
#=============================

set(public_header_set "${project_name_lowercase}_public_header_set")

add_subdirectory(include)

#=============================
# Sources
#=============================

add_subdirectory(src)

#=============================
# Testing
#=============================

if(enable_test)
    include(CTest)
    add_subdirectory(tests)
endif()

#=============================
# Packaging
#=============================

if(enable_install_shared OR enable_install_static)
    add_subdirectory(packaging)
endif()
