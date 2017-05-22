cmake_minimum_required(VERSION 3.5)
project(shell)

set(CMAKE_C_STANDARD 11)

set(SHELL_SOURCE_FILES shellDriver.c
        ADT.c ADT.h
        utility.c utility.h)
add_executable(shell ${SHELL_SOURCE_FILES})

set(LCC_SOURCE_FILES
        main.c
        lcc.c lcc.h
        y.tab.c y.tab.h
        lex.yy.c
        ADT.c ADT.h
        )
add_executable(LCC ${LCC_SOURCE_FILES})
