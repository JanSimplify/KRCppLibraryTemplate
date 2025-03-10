# SPDX-License-Identifier: MIT-0
# SPDX-FileCopyrightText: Copyright (c) 2025 JanSimplify

include(FetchContent)

FetchContent_Declare(
    KRCMake
    URL https://github.com/JanSimplify/KRCMake/archive/refs/tags/v1.0.0.zip
    URL_HASH MD5=553a4ca12751ddb5dba2405120c5bb82
)

FetchContent_MakeAvailable(KRCMake)

block()
    set(CMAKE_CXX_STANDARD 20)
    set(CMAKE_CXX_STANDARD_REQUIRED ON)
    set(BUILD_SHARED_LIBS OFF)

    FetchContent_Declare(
        Catch2
        URL https://github.com/catchorg/Catch2/archive/refs/tags/v3.8.0.zip
        URL_HASH MD5=99c04e387d0155ba9d81b991cb74aa81
        SYSTEM
    )

    FetchContent_MakeAvailable(Catch2)

    set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}" PARENT_SCOPE)
endblock()
