# SPDX-License-Identifier: MIT-0
# SPDX-FileCopyrightText: Copyright (c) 2025 JanSimplify

cmake_minimum_required(VERSION 3.25 FATAL_ERROR)

set(package_name KRLibrary)
set(package_library_target KRLibrary::KRLibrary)

project(${package_name}Test)

string(TOLOWER ${PROJECT_NAME} project_name_lowercase)

#=============================
# Options
#=============================

option(
    "${package_name}_ENABLE_CODE_COVERAGE"
    "Enable code coverage analysis"
    OFF
)

set(enable_code_coverage "${${package_name}_ENABLE_CODE_COVERAGE}")

#=============================
# Dependencies
#=============================

if(PROJECT_IS_TOP_LEVEL)
    include(CTest)
    find_package(${package_name} REQUIRED)
endif()

include(cmake/dependencies.cmake)

#=============================
# Targets
#=============================

set(test_target "${PROJECT_NAME}")

add_executable("${test_target}")

#=============================
# Headers
#=============================

add_subdirectory(include)

#=============================
# Sources
#=============================

add_subdirectory(src)

#=============================
# Testing
#=============================

include(Catch)

catch_discover_tests(
    "${test_target}"
    DL_PATHS "$<TARGET_FILE_DIR:${package_library_target}>"
)
