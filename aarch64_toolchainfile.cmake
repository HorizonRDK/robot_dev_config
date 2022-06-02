# Copyright (c) 2018, ARM Limited.
# SPDX-License-Identifier: Apache-2.0

set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_VERSION 1)
set(CMAKE_SYSTEM_PROCESSOR aarch64)
# specify the cross compiler
set(CMAKE_C_COMPILER $ENV{CROSS_COMPILE}gcc)
set(CMAKE_CXX_COMPILER $ENV{CROSS_COMPILE}g++)
# where is the target environment
set(CMAKE_FIND_ROOT_PATH ${CMAKE_CURRENT_LIST_DIR}/../install ${CMAKE_CURRENT_LIST_DIR}/../build ${CMAKE_CURRENT_LIST_DIR}/../../sysroot_docker)
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_CROSSCOMPILING_EMULATOR qemu-aarch64-static)
set(CMAKE_SYSROOT ${CMAKE_CURRENT_LIST_DIR}/../../sysroot_docker)
set(BUILD_TESTING off)
set(BUILD_HBMEM ON)
set(PYTHON_SOABI cpython-38-aarch64-linux-gnu)

# This assumes that pthread will be available on the target system
# (this emulates that the return of the TRY_RUN is a return code "0"
set(THREADS_PTHREAD_ARG "0"
  CACHE STRING "Result from TRY_RUN" FORCE)
