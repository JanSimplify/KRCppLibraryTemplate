# SPDX-License-Identifier: MIT-0
# SPDX-FileCopyrightText: Copyright (c) 2025 JanSimplify

#=============================
# Variables
#=============================

include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

set(INSTALL_CMAKE_CONFIG_DIR "${CMAKE_INSTALL_LIBDIR}/cmake/${project_name_lowercase}")

set(runtime_component "${PROJECT_NAME}_Runtime")
set(development_component "${PROJECT_NAME}_Development")

set(autogen_cmake_config_dir "${PROJECT_BINARY_DIR}/autogen/cmake")

#=============================
# Libraries
#=============================

set(static_target_export "${PROJECT_NAME}StaticTarget")
set(shared_target_export "${PROJECT_NAME}SharedTarget")

if(enable_install_static)
    list(APPEND install_targets "${static_target}")
    list(APPEND install_exports "${static_target_export}")
endif()

if(enable_install_shared)
    list(APPEND install_targets "${shared_target}")
    list(APPEND install_exports "${shared_target_export}")
endif()

foreach(target target_export IN ZIP_LISTS install_targets install_exports)
    install(
        TARGETS "${target}"
        EXPORT "${target_export}"
        RUNTIME
            COMPONENT "${runtime_component}"
        BUNDLE
            COMPONENT "${runtime_component}"
        LIBRARY
            COMPONENT "${runtime_component}"
            NAMELINK_COMPONENT "${development_component}"
        ARCHIVE
            COMPONENT "${development_component}"
        FILE_SET
            ${public_header_set}
            COMPONENT "${development_component}"
    )
    install(
        EXPORT "${target_export}"
        DESTINATION "${INSTALL_CMAKE_CONFIG_DIR}"
        NAMESPACE "${PROJECT_NAME}::"
        COMPONENT "${development_component}"
    )
endforeach()

#=============================
# Package version
#=============================

set(package_version_file "${autogen_cmake_config_dir}/${PROJECT_NAME}ConfigVersion.cmake")

write_basic_package_version_file(
    "${package_version_file}"
    VERSION "${PROJECT_VERSION}"
    COMPATIBILITY "AnyNewerVersion"
)

install(
    FILES "${package_version_file}"
    DESTINATION "${INSTALL_CMAKE_CONFIG_DIR}"
    COMPONENT "${development_component}"
)

#=============================
# Package config
#=============================

set(package_config_file "${autogen_cmake_config_dir}/${PROJECT_NAME}Config.cmake")

configure_package_config_file(
    "ProjectConfig.cmake.in"
    "${package_config_file}"
    INSTALL_DESTINATION "${INSTALL_CMAKE_CONFIG_DIR}"
    PATH_VARS INSTALL_CMAKE_CONFIG_DIR
    NO_SET_AND_CHECK_MACRO
)

install(
    FILES "${package_config_file}"
    DESTINATION "${INSTALL_CMAKE_CONFIG_DIR}"
    COMPONENT "${development_component}"
)
