cmake_minimum_required(VERSION 3.5)
project(shell)

set(CMAKE_C_STANDARD 11)

set(SHELL_SOURCE_FILES shellDriver.c
        vector.c vector.h
        utility.c utility.h)
add_executable(shell ${SHELL_SOURCE_FILES})

set(LCC_SOURCE_FILES
        main.c
        y.tab.h
        y.tab.c
        lex.yy.c
        )
add_executable(LCC ${LCC_SOURCE_FILES})
