# SPDX-License-Identifier: MIT-0
# SPDX-FileCopyrightText: Copyright (c) 2025 JanSimplify

#=============================
# Sources
#=============================

set(sources
    "test_hello.cpp"
)

target_sources("${test_target}" PRIVATE ${sources})

#=============================
# Link libraries
#=============================

target_link_libraries(
    ${test_target} 
    PRIVATE
        ${package_library_target}
        Catch2::Catch2WithMain
)

#=============================
# Properties
#=============================

include(KRCMakeCompileOptions)

set(test_output "${project_name_lowercase}")

target_compile_features("${test_target}" PRIVATE "cxx_std_20")

set_target_properties(
    "${test_target}"
    PROPERTIES
        OUTPUT_NAME "${test_output}"
        CXX_EXTENSIONS OFF
        LINK_LIBRARIES_ONLY_TARGETS ON
)

krcmake_target_set_develop_mode(
    TARGETS "${test_target}"
    ERROR_AS_FATAL
)

#=============================
# Compile Options
#=============================

include(KRCMakeCompileOptions)

krcmake_target_compile_options(
    TARGETS "${test_target}"
    PRIVATE
        MSVC_OPTIONS
            "/utf-8"
            "/permissive-"
)

krcmake_target_set_develop_mode(
    TARGETS "${test_target}"
    ERROR_AS_FATAL
)
