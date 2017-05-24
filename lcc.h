#ifndef LCC_H
#define LCC_H

#include "ADT.h"

typedef enum Type_size {
    byte,
    word,
    long_word,
    quad_word
} Type_size;

typedef enum {
    DCHAR = byte,
    DINT = long_word,
    DFUNC,
    DFUNC_NAME,
    NEW_SCOPE,
} Type;

static int real_size[] = {
        1,
        2,
        4,
        8,
};
static char *type_name[] = {
        "char",
        "",
        "int",
};
static char op_suffix[] = {
        'b', 'w', 'l', 'q',
};

static char *arugments_register[][6] = {
        {
                "%dil",
                "%sil",
                "%dl",
                "%cl",
                "%r8b",
                "%r9b",
        },
        {},
        {

                "%edi",
                "%esi",
                "%edx",
                "%ecx",
                "%r8d",
                "%r9d",
        },
};

extern FILE *output;

typedef struct Assembly {
    List_node *beg, *end;
} Assembly;

Assembly *make_assembly();

void assembly_push_back(Assembly *ptr, String *code);

void assembly_append(Assembly *ptr, Assembly *p);

void assembly_push_front(Assembly *ptr, String *code);

void assembly_output(Assembly *ptr);

void emit_func_signature(Assembly *code, String *str);

typedef struct Stack {
    int offset;
    int rsp;
} Stack;

int allocate_stack(Stack *, int, Assembly *);

typedef struct Analysis {
    struct Analysis *parent;
    Type self_type, ret_type;
    String *name;
    Stack stack_info;
    Vector *param;
    Assembly *assembly;
} Analysis;

typedef Analysis Symbol;

void emit_func_arguments(Assembly *code, Analysis *func);

void emit_local_variable(Assembly *code, Symbol *s);

Symbol *symbol_cast(void *);

Symbol *make_func_def_symbol(Type ret_type, String *name, Vector *param, Symbol *parent);

Symbol *make_func_decl_symbol(Type ret_type, String *name, Vector *param, Symbol *parent);

Symbol *make_local_symbol(Type, String *name, Symbol *parent);

Symbol *make_param_symbol(Type, String *name);

Symbol *make_new_scope(Symbol *parent);

int is_global_variable(Symbol *);

#define YYSTYPE Analysis

#include "y.tab.h"

#endif