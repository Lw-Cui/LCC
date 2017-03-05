#include <stdio.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <ctype.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
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
            if (execvp(at(vec, 0), (char *const *) get_array(vec)) == -1) {
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