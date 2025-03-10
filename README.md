[![CMake on multiple platforms](https://github.com/JanSimplify/KRCppLibraryTemplate/actions/workflows/cmake-multi-platform.yml/badge.svg)](https://github.com/JanSimplify/KRCppLibraryTemplate/actions/workflows/cmake-multi-platform.yml)
[![codecov](https://codecov.io/gh/JanSimplify/KRCppLibraryTemplate/graph/badge.svg?token=O2xx2vGbWu)](https://codecov.io/gh/JanSimplify/KRCppLibraryTemplate)

# KRCppLibraryTemplate

CMake C++20 跨平台库脚手架项目，功能包括：

- 按需编译与安装动态库和静态库；
- 根据PROJECT_VERSION生成版本信息描述函数；
- 使用Catch2测试框架；
- 支持find_package()查找；
- 提供选项启用address sanitizer和code coverage；

特性：

- 禁止动态库默认导出符号，提供辅助宏手动控制符号导出；
- 开发者模式下的启用严格的编译警告选项。

测试于：

- Ubuntu：GCC，Clang；
- Windows：MSVC。

## 使用方法

下载后，替换`LICENSE`为你的许可证协议：

```LICENSE
<Your License>

Copyright (c) <year> <owner>

<License text>
```

搜索并替换文件中的协议与版权声明，这里仅演示如何使用grep进行搜索：

```bash
$ grep -rn 'SPDX' --exclude-dir={build,.git} --exclude=README.md
cmake/dependencies.cmake:1:# SPDX-License-Identifier: MIT-0
cmake/dependencies.cmake:2:# SPDX-FileCopyrightText: Copyright (c) 2025 JanSimplify
# ...
```

搜索并替换项目名称与路径名称，这里仅演示如何使用grep进行搜索：

```bash
$ grep -irn 'KRLibrary' --exclude-dir={build,.git} --exclude=README.md
CMakeLists.txt:10:project(KRLibrary VERSION 1.0.0 LANGUAGES CXX)
tests/CMakeLists.txt:6:project(KRLibraryTest)
# ...
```

修改OpenCppCoverage.conf，将其中的`KRCppLibraryTemplate`修改为你的项目所在目录名称。

修改`include`目录下的子目录名称为小写的项目名称。

公共头文件与源文件的列表分别在`include`和`src`下的`CMakeLists.txt`文件中进行修改。

## 功能演示

未修改的情况下，当前项目名称为`KRLibrary`，项目所在目录为`KRCppLibraryTemplate`。

### 配置选项

所有配置选项的名称前缀均为`<PackageName>`，这里为方便演示以`KRLibrary`为例。

控制别名目标`KRLibrary::KRLibrary`是否指向动态库`KRLibrary::shared`，否则指向静态库`KRLibrary::static`，默认值为[BUILD_SHARED_LIBS](https://cmake.org/cmake/help/latest/variable/BUILD_SHARED_LIBS.html)：

```c
//Default to SHARED libraries
KRLibrary_USE_SHARED_LIBS:BOOL=FALSE
```

是否启用对动态库和静态库的安装，作为顶层项目构建时默认开启，作为子项目时默认关闭：

```c
//Install shared library
KRLibrary_ENABLE_INSTALL_SHARED:BOOL=TRUE

//Install static library
KRLibrary_ENABLE_INSTALL_STATIC:BOOL=TRUE
```

是否编译测试代码：

```c
//Enalbe test
KRLibrary_ENABLE_TEST:BOOL=TRUE
```

是否启用`address sanitizer`进行构建，默认关闭，注意MSVC中静态链接时需要保证各个库的`address sanitizer`选项一致，否则会导致链接错误：

```c
//Enable address sanitizer
KRLibrary_ENABLE_ADDRESS_SANITIZER:BOOL=OFF
```

是否启用代码覆盖率分析，默认关闭，主要为gcc和clang使用，相当于设置`--coverage`选项，MSVC不依赖该选项：

```c
//Enable code coverage analysis
KRLibrary_ENABLE_CODE_COVERAGE:BOOL=OFF
```

### 编译与安装

克隆项目并进入目录：

```bash
git clone https://github.com/JanSimplify/KRCppLibraryTemplate.git --depth=1
cd KRCppLibraryTemplate
```

使用cmake构建项目，这里为了方便，关闭了对测试代码的编译：

```bash
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release -DKRLibrary_ENABLE_TEST=OFF
```

编译项目：

```bash
cmake --build build --config Release
```

安装项目，使用`--prefix`指定安装的根目录，这里仅用作演示，实践中请自行选择合适的目录：

```bash
$ cmake --install build --config Release --prefix install/
-- Installing: install/lib/cmake/KRLibrary/KRLibraryConfig.cmake
-- Installing: install/lib/cmake/KRLibrary/KRLibraryConfigVersion.cmake
-- Installing: install/lib/libkrlibrary.so.1.0.0
# ...
```

### 使用

如果希望在应用项目中使用库，有两种方法：

- 使用`find_package()`，适用于已安装库的情况；
- 使用`fetch_content()`，适用于希望项目独立拉取库代码共同编译的情况。

对于使用已安装库的情况，在应用项目中添加如下语句添加库：

```cmake
find_package(KRLibrary REQUIRED)
```

通常不会将非系统库安装至系统搜索目录，因此配置时需要为CMake指定额外的搜索路径：

```bash
cmake -S <app_dir> -B <app_build> -DCMAKE_PREFIX_PATH=<lib_install_root>
```

如果希望独立拉取并编译库代码，则应当使用`fetch_content()`：

```cmake
include(FetchContent)

FetchContent_Declare(
    KRLibrary
    GIT_REPOSITORY https://github.com/JanSimplify/KRCppLibraryTemplate.git
    GIT_TAG main
    SYSTEM
    GIT_SHALLOW
)

FetchContent_MakeAvailable(KRLibrary)
```

完成导入后，应用项目可以链接至动态库或静态库：

```cmake
# 显式链接动态库和静态库
target_link_libraries(<app1> PRIVATE KRLibrary::static)
target_link_libraries(<app2> PRIVATE KRLibrary::shared)
```

也可以使用非指定版本，它的行为受到CMake变量`BUILD_SHARED_LIBS`的控制：

```cmake
# 不指定动态库和静态库，通过BUILD_SHARED_LIBS或KRLibrary_USE_SHARED_LIBS控制
# 后者优先级更高
target_link_libraries(<app> PRIVATE KRLibrary::KRLibrary)
```

### 控制安装行为

如果只希望分发动态库，而不希望安装头文件、静态库等开发者才会使用的文件，可以在安装时指定组件`KRLibrary_Runtime`：

```bash
$ cmake --install build/ --prefix install/ --component KRLibrary_Runtime
-- Install configuration: "Release"
-- Up-to-date: /home/kr/KRLibrary/install/lib/libkrlibrary.so.1.0.0
-- Up-to-date: /home/kr/KRLibrary/install/lib/libkrlibrary.so.1
```

其他文件目前粗略的分类至`KRLibrary_Development`安装组件中。

如果希望安装头文件、动态库和`cmake`配置文件，但不希望安装静态库，可以在配置阶段进行指定：

```bash
cmake -S . -B build/ -DKRLibrary_ENABLE_INSTALL_STATIC=OFF
```

同理可以通过选项`KRLibrary_ENABLE_INSTALL_SHARED`控制动态库的安装。

### 测试

默认集成`Catch2`测试框架，作为顶层项目构建时默认启用，也可以通过选项开启：

```bash
cmake -S . -B build -DKRLibrary_ENABLE_TEST=ON
cmake --build build
```

切换工作目录并使用`ctest`运行测试：

```bash
$ cd build
$ ctest
Test project /home/kr/KRLibrary/build
    Start 1: always success
1/1 Test #1: always success ...................   Passed    0.03 sec

100% tests passed, 0 tests failed out of 1

Total Test time (real) =   0.04 sec
```

注意不要手动直接运行测试的可执行程序，因为`ctest`会配置必要的环境变量，缺乏这些变量可能会导致找不到依赖的动态库。

### 开发者选项

在作为顶层构建时默认启用，提供严格的编译器警告选项：

```c
//Enalbe develop mode
KRLibrary_DEVELOP_MODE:BOOL=TRUE
```

作为子项目时关闭并隐藏选项，库内部的警告信息不应当传播到库的使用者一方。

### address sanitizer

控制项目是否启用asan，默认关闭：

```c
//Enable address sanitizer
KRLibrary_ENABLE_ADDRESS_SANITIZER:BOOL=OFF
```

MSVC中进行静态链接时，如果各个静态库的`sanitizer`选项不一致，会导致链接错误，这种情况下可以使用该选项进行调整。

### 代码覆盖率分析

控制项目是否启用代码覆盖率分析，默认关闭：

```c
//Enable code coverage analysis
KRLibrary_ENABLE_CODE_COVERAGE:BOOL=OFF
```

例如linux平台，将应用`--coverage`选项，编译后运行测试，可以通过`gcovr`等基于`gcov`的工具获取代码覆盖率报告：

```bash
$ gcovr
------------------------------------------------------------------------------
                           GCC Code Coverage Report
Directory: .
------------------------------------------------------------------------------
File                                       Lines    Exec  Cover   Missing
------------------------------------------------------------------------------
include/krlibrary/hello.hpp                    3       3   100%
src/hello.cpp                                  3       3   100%
------------------------------------------------------------------------------
TOTAL                                          6       6   100%
------------------------------------------------------------------------------
```

基于`gcov`的代码覆盖率分析都存在需要清理`.gcda`文件的问题，这里推荐使用`gcovr`的`-d`选项自动进行清理：

```bash
$ gcovr -d
# ...
```

windows不依赖该选项，只需要保证调试信息可用，然后调用OpenCppCoverage即可：

```bash
OpenCppCoverage.exe --config_file OpenCppCoverage.conf -- ctest --build-config Debug
```
