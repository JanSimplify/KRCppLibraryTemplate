# SPDX-License-Identifier: MIT-0
# SPDX-FileCopyrightText: Copyright (c) 2025 JanSimplify

include(FetchContent)

FetchContent_Declare(
    KRCMake
    URL https://github.com/JanSimplify/KRCMake/archive/refs/tags/v1.0.0.zip
    URL_HASH MD5=553a4ca12751ddb5dba2405120c5bb82
)

FetchContent_MakeAvailable(KRCMake)
