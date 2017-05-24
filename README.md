# LCC

**L**iwei's **C** **C**ompiler.

One of my object is to compile the `Tshell`.

## Tshell
*T* means *toy* or *tiny*.
 
I use malloc to implement dynamic array, and thanks to `Valgrind` everything works fine.

```
$ valgrind  --leak-check=full ./shell
==31700== Memcheck, a memory error detector
==31700== Copyright (C) 2002-2015, and GNU GPL'd, by Julian Seward et al.
==31700== Using Valgrind-3.11.0 and LibVEX; rerun with -h for copyright info
==31700== Command: ./shell
==31700==
ls
   [ Execute: ls ]
-rw-rw-r--   1 clay clay  11478 Mar  5 23:07 CMakeCache.txt
drwxrwxr-x   6 clay clay   4096 Mar 23 18:46 ..
drwxrwxr-x   5 clay clay   4096 Mar 23 18:55 CMakeFiles
-rw-rw-r--   1 clay clay   1349 Mar  5 23:07 cmake_install.cmake
-rwxrwxr-x   1 clay clay  14608 Mar 23 18:55 shell
drwxrwxr-x   3 clay clay   4096 Mar 23 18:55 .
-rw-rw-r--   1 clay clay   5927 Mar 23 18:55 Makefile
==31701==
==31701== HEAP SUMMARY:
==31701==     in use at exit: 0 bytes in 0 blocks
==31701==   total heap usage: 122 allocs, 122 frees, 62,808 bytes allocated
==31701==
==31701== All heap blocks were freed -- no leaks are possible
==31701==
==31701== For counts of detected and suppressed errors, rerun with: -v
==31701== ERROR SUMMARY: 0 errors from 0 contexts (suppressed: 0 from 0)
   [ Child exited, status = 0 ]
exit
==31700==
==31700== HEAP SUMMARY:
==31700==     in use at exit: 0 bytes in 0 blocks
==31700==   total heap usage: 16 allocs, 16 frees, 2,494 bytes allocated
==31700==
==31700== All heap blocks were freed -- no leaks are possible
==31700==
==31700== For counts of detected and suppressed errors, rerun with: -v
==31700== ERROR SUMMARY: 0 errors from 0 contexts (suppressed: 0 from 0)
```