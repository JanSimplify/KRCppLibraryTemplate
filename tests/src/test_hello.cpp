// SPDX-License-Identifier: MIT-0
// SPDX-FileCopyrightText: Copyright (c) 2025 JanSimplify

#include <iostream>

#include <catch2/catch_test_macros.hpp>

#include <krlibrary/hello.hpp>
#include <krlibrary/version.hpp>

TEST_CASE("always success", "[krlibrary]")
{
    using namespace krlibrary;
    std::cout << version() << std::endl;
    inline_hello();
    exported_hello();
    REQUIRE(true);
}
