# SPDX-License-Identifier: MIT-0
# SPDX-FileCopyrightText: Copyright (c) 2025 JanSimplify

set(headers
    "${project_name_lowercase}/hello.hpp"
)

foreach(target IN ITEMS "${static_target}" "${shared_target}")
    target_sources(
        "${target}"
        PUBLIC
            FILE_SET ${public_header_set}
            TYPE HEADERS
            BASE_DIRS
                "${PROJECT_SOURCE_DIR}/include"
            FILES
                ${headers}
    )
endforeach()
