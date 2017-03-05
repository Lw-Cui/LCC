cmake_minimum_required(VERSION 3.5)
project(shell)

set(CMAKE_C_STANDARD 11)

set(SOURCE_FILES main.c utility.c utility.h)
add_executable(shell ${SOURCE_FILES})