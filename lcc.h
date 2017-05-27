#ifndef LCC_H
#define LCC_H

#include "ADT.h"

typedef enum Type_size {
    BYTE,
    WORD,
    LONG_WORD,
    QUAD_WORD
} Type_size;

typedef enum Type {
    DCHAR = BYTE,
    DINT = LONG_WORD,
    DFUNC,          // function definition
    DFUNC_NAME,     // function declaration
    NEW_SCOPE,      // new scope, e.g. function, for, while, if
    INUM,           // int constant number
    NOT_KNOWN,
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

static char *reg[][4] = {
        {
                "al",
                "ax",
                "eax",
                "rax",
        },
        {

                "bl",
                "bx",
                "ebx",
                "rbx",
        }
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

void free_stack(Stack *, int);

typedef struct Value {
    int index;
    int int_num;
    int offset;
} Value;

int has_constant(Value *);

void set_constant(Value *, int val);

int get_constant(Value *);

int has_stack_offset(Value *);

void set_stack_offset(Value *, int offset);

int get_stack_offset(Value *);

typedef struct Analysis {
    struct Analysis *parent;
    Type self_type, ret_type;
    String *name;
    Stack stack_info;
    Value res_info;
    Vector *param;
    Assembly *assembly;
} Analysis;

typedef Analysis Symbol;

int pop_and_op(Assembly *code, Value *op1, char *op_prefix, Value *op2, Stack *func_info);

void emit_push_var(Assembly *code, Value *res_info, Stack *func_info);

int emit_push_register(Assembly *code, size_t idx, Stack *func_info);

void emit_pop(Assembly *code, Value *res_info, Stack *func_info, size_t idx);

void emit_func_arguments(Assembly *code, Analysis *func);

void emit_local_variable(Assembly *code, Symbol *s);

Symbol *symbol_cast(void *);

Symbol *make_func_def_symbol(Type ret_type, String *name, Vector *param, Symbol *parent);

Symbol *make_func_decl_symbol(Type ret_type, String *name, Vector *param, Symbol *parent);

Symbol *make_local_symbol(Type, String *name, Symbol *parent, Value res_info);

Symbol *make_param_symbol(Type, String *name);

Symbol *make_new_scope(Symbol *parent);

Symbol *find_name(Symbol *symtab, String *name);

Symbol *get_top_scope(Symbol *symtab);

int in_global_scope(Symbol *);

#define YYSTYPE Analysis

#include "y.tab.h"

#endif