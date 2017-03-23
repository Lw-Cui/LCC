#include <stdio.h>
#include <pwd.h>
#include <time.h>
#include <grp.h>
#include <string.h>
#include <dirent.h>
#include <sys/stat.h>
#include <dirent.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <ctype.h>
#include <unistd.h>
#include <stdlib.h>
#include "vector.h"
#include "utility.h"


char *read_word(FILE *fp) {
    static int EOL = 0;
    if (EOL == 1) {
        EOL = 0;
        return 0;
    }
    int c;
    Vector *str = make_vector();
    while (!isspace(c = getc(fp))) {
        char *p = (char *) malloc(sizeof(char));
        *p = (char) c;
        push_back(str, p);
    }
    char *s = c_str(str);
    clear(str);
    del_vec(str);
    if (c == '\n') EOL = 1;
    return s;
}

void printls(struct dirent *entry) {
    struct stat buf;
    if (stat(entry->d_name, &buf) == 0) {
        char st[10];
        memset(st, 0, sizeof(st));
#ifdef __APPLE__
#ifndef st_mtime
#define st_mtime st_mtimespec.tv_sec
#endif
#endif
        struct tm *mtime = localtime(&buf.st_mtime);
        printf("%c%s%4d %s %s%7lld %s%3d %02d:%02d %s\n",
               parseType(entry->d_type), parseMode(buf.st_mode, st), buf.st_nlink,
               getpwuid(buf.st_uid)->pw_name, getgrgid(buf.st_gid)->gr_name, buf.st_size,
               Month[mtime->tm_mon], mtime->tm_mday, mtime->tm_hour, mtime->tm_min, entry->d_name);
    } else {
        perror("Read file status fail.");
    }
}

int main(int argc, char *const argv[], char *const env[]) {
    Vector *vec = make_vector();
    while (1) {
        clear(vec);
        char *str;
        while ((str = read_word(stdin)) != 0) {
            push_back(vec, str);
            if (!strcmp(str, "exit")) {
                goto Exit;
            }
        }
        push_back(vec, str);
        pid_t pid = fork();
        if (pid == 0) {
            printf("   [ Execute: %s ]\n", (char *) at(vec, 0));
            if (!strcmp((char *) at(vec, 0), "ls")) {
                traverse(".", printls, NULL);
                goto Exit;
            } else if (execvp(at(vec, 0), (char *const *) get_array(vec)) == -1) {
                perror("execvp error");
                exit(EXIT_FAILURE);
            }
        } else if (pid > 0) {
            int status;
            do {
                if (waitpid(pid, &status, WUNTRACED) == -1) {
                    perror("Waitpid");
                    exit(EXIT_FAILURE);
                }
                if (WIFEXITED(status)) {
                    printf("   [ Child exited, status = %d ]\n", WEXITSTATUS(status));
                } else if (WIFSIGNALED(status)) {
                    printf("   [ Child killed (signal %d)\n ]", WTERMSIG(status));
                } else if (WIFSTOPPED(status)) {
                    printf("   [ Child stopped (signal %d) ]\n", WSTOPSIG(status));
                }
            } while (!WIFEXITED(status) && !WIFSIGNALED(status));
        }
    }
    Exit:
    clear(vec);
    del_vec(vec);
    return 0;
}