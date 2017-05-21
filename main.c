#include <stdio.h>

extern FILE *yyin;

extern int yyparse();

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Usage: %s filename\n", argv[0]);
        return 0;
    }
    yyin = fopen(argv[1], "r");

    yyparse();

    fclose(yyin);
    return 0;
}

