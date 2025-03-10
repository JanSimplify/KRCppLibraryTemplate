# SPDX-License-Identifier: MIT-0
# SPDX-FileCopyrightText: Copyright (c) 2025 JanSimplify

#=============================
# Variables
#=============================

set(autogen_include_dir "${PROJECT_BINARY_DIR}/autogen/include")
set(autogen_source_dir "${PROJECT_BINARY_DIR}/autogen/src")

#=============================
# Sources
#=============================

set(sources
    "hello.cpp"
)

foreach(target IN ITEMS "${static_target}" "${shared_target}")
    target_sources(
        "${target}"
        PRIVATE
            ${sources}
    )
endforeach()

#=============================
# Properties
#=============================

set(static_output_name "${project_name_lowercase}")
set(shared_output_name "${project_name_lowercase}")

if(WIN32)
    string(APPEND static_output_name "_static")
    foreach(target IN ITEMS "${static_target}" "${shared_target}")
        set_target_properties(
            "${target}"
            PROPERTIES DEBUG_POSTFIX "d"
        )
    endforeach()
endif()

set_target_properties(
    "${static_target}"
    PROPERTIES
        OUTPUT_NAME "${static_output_name}"
        EXPORT_NAME "${static_export_name}"
)

set_target_properties(
    "${shared_target}"
    PROPERTIES
        OUTPUT_NAME "${shared_output_name}"
        EXPORT_NAME "${shared_export_name}"
)

foreach(target IN ITEMS "${static_target}" "${shared_target}")
    target_compile_features("${target}" PUBLIC "cxx_std_20")
    set_target_properties(
        "${target}"
        PROPERTIES
            VERSION "${PROJECT_VERSION}"
            SOVERSION "${PROJECT_VERSION_MAJOR}"
            CXX_EXTENSIONS OFF
            CXX_VISIBILITY_PRESET "hidden"
            VISIBILITY_INLINES_HIDDEN ON
            LINK_LIBRARIES_ONLY_TARGETS ON
    )
endforeach()

if(NOT enable_install_shared)
    set_target_properties(${shared_target} PROPERTIES EXCLUDE_FROM_ALL ON)
endif()

if(NOT enable_install_static)
    set_target_properties(${static_target} PROPERTIES EXCLUDE_FROM_ALL ON)
endif()

#=============================
# Compile Options
#=============================

include(KRCMakeCompileOptions)

krcmake_target_compile_options(
    TARGETS "${static_target}" "${shared_target}"
    PRIVATE
        MSVC_OPTIONS
            "/utf-8"
            "/permissive-"
)

if(enable_develop_mode)
    krcmake_target_set_develop_mode(
        TARGETS "${static_target}" "${shared_target}"
        ERROR_AS_FATAL
    )
endif()

if(enable_code_coverage)
    krcmake_target_set_coverage(
        TARGETS "${static_target}" "${shared_target}"
    )
endif()

#=============================
# Export header
#=============================

include(GenerateExportHeader)

set(autogen_export_header "${autogen_include_dir}/${project_name_lowercase}/export.hpp")

generate_export_header(
    "${shared_target}"
    BASE_NAME "${project_name_uppercase}"
    EXPORT_FILE_NAME "${autogen_export_header}"
)

target_compile_definitions(
    "${static_target}"
    PUBLIC "${project_name_uppercase}_STATIC_DEFINE"
)

foreach(target IN ITEMS "${static_target}" "${shared_target}")
    target_sources(
        "${target}"
        PUBLIC
            FILE_SET ${public_header_set}
            TYPE HEADERS
            BASE_DIRS
                "${autogen_include_dir}"
            FILES
                "${autogen_export_header}"
    )
endforeach()

#=============================
# Version file
#=============================

set(autogen_version_header "${autogen_include_dir}/${project_name_lowercase}/version.hpp")
set(autogen_version_source "${autogen_source_dir}/version.cpp")

block()
    set(inputs "version.hpp.in" "version.cpp.in")
    set(outputs "${autogen_version_header}" "${autogen_version_source}")

    foreach(in out IN ZIP_LISTS inputs outputs)
        string(JOIN "\n" autogen_notice
            "/**"
            " *  This file is auto-generated from ${in}."
            " *  Do not edit directly."
            " */"
        )
        configure_file(${in} ${out} @ONLY)
    endforeach()
endblock()

foreach(target IN ITEMS "${static_target}" "${shared_target}")
    target_sources(
        "${target}"
        PUBLIC
            FILE_SET ${public_header_set}
            TYPE HEADERS
            BASE_DIRS
                "${autogen_include_dir}"
            FILES
                "${autogen_version_header}"
        PRIVATE
            "${autogen_version_source}"
    )
endforeach()
