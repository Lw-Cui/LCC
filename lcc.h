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

extern FILE *output;

typedef struct Assembly {
    List_node *beg, *end;
} Assembly;

Assembly *make_assembly();

void assembly_push_back(Assembly *ptr, String *code);

void assembly_push_front(Assembly *ptr, String *code);

void assembly_output(Assembly *ptr);

void emit_func_signature(Assembly *code, String *str);

typedef struct Analysis {
    struct Analysis *parent;
    Type self_type, ret_type;
    String *name;
    int offset;
    Vector *param;
    Assembly *assembly;
} Analysis;

typedef Analysis Symbol;

void emit_func_arguments(Assembly *code, Analysis *func);

Symbol *symbol_cast(void *);

Symbol *make_func_symbol(Type ret_type, String *name, Vector *param, Symbol *parent);

Symbol *make_local_symbol(Type, String *name, Symbol *parent);

Symbol *make_param_symbol(Type, String *name);

Symbol *make_new_scope(Symbol *parent);

void print_local_symbol(Symbol *var);

#define YYSTYPE Analysis

#include "y.tab.h"

#endif