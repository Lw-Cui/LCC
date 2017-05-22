#ifndef LCC_H
#define LCC_H

#include "ADT.h"

typedef enum {
    DCHAR,
    DINT,
    DFUNC,
    DFUNC_NAME,
    NEW_SCOPE,
} Type;

extern char *type_name[];

typedef struct Symbol {
    struct Symbol *parent;
    Type self_type, ret_type;
    String *name;
    Vector *param;
} Symbol;

Symbol *symbol_cast(void *);

Symbol *make_func_symbol(Type ret_type, String *name, Vector *param, Symbol *parent);

Symbol *make_local_var_symbol(Type, String *name);

Symbol *make_new_scope(Symbol *parent);

void print_func_symbol(Symbol *func);

#define YYSTYPE Symbol

#include "y.tab.h"

#endif