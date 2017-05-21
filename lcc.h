#ifndef LCC_H
#define LCC_H

#include "ADT.h"

typedef struct {
    int type;
    String *name;
} Symbol;

#define YYSTYPE Symbol

#include "y.tab.h"


void size_of_type(enum yytokentype type);

#endif