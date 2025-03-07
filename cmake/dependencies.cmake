# SPDX-License-Identifier: MIT-0
# SPDX-FileCopyrightText: Copyright (c) 2025 JanSimplify

include(FetchContent)

FetchContent_Declare(
    KRCMake
    GIT_REPOSITORY https://github.com/JanSimplify/KRCMake.git
    GIT_TAG a195d00
)

FetchContent_MakeAvailable(KRCMake)
