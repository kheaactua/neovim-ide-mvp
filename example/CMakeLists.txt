#
# CONFIDENTIAL - FORD MOTOR COMPANY
#
# This is an unpublished work, which is a trade secret, created in
# 2020.  Ford Motor Company owns all rights to this work and intends
# to maintain it in confidence to preserve its trade secret status.
# Ford Motor Company reserves the right to protect this work as an
# unpublished copyrighted work in the event of an inadvertent or
# deliberate unauthorized publication.  Ford Motor Company also
# reserves its rights under the copyright laws to protect this work
# as a published work.  Those having access to this work may not copy
# it, use it, or disclose the information contained in it without
# the written authorization of Ford Motor Company.


# CMakeLists for file creating integration tests for FNV SOA / CommonAPI.
# Designed to be built within buildroot, using capicxx-cmake-modules to find
# the CommonAPI assets

cmake_policy(SET CMP0048 NEW)
project(vim-ide-test VERSION 0.1 LANGUAGES CXX)
cmake_minimum_required(VERSION 3.16)
cmake_policy(VERSION 3.16)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_SYSROOT}/usr/lib/cmake")

add_executable(app)
target_sources(app PUBLIC src/main.cpp)

# vim: ts=2 sw=2 sts=0 expandtab ff=unix :
