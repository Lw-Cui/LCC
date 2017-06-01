#ifndef LCC_H
#define LCC_H

#include "ADT.h"

#define max(a, b) \
   ({ __typeof__ (a) _a = (a); \
       __typeof__ (b) _b = (b); \
     _a > _b ? _a : _b; })

#define min(a, b) \
   ({ __typeof__ (a) _a = (a); \
       __typeof__ (b) _b = (b); \
     _a < _b ? _a : _b; })


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
    FUNC_DECL,     // function declaration
    FUNC_CALL,
    NEW_SCOPE,      // new scope, e.g. function, for, while, if
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
        },
        {
                "cl",
                "cx",
                "ecx",
                "rcx",

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

#define INVALID_OFFSET 0xFFFFFF

typedef struct Stack {
    int offset;
    int rsp;
} Stack;

int allocate_stack(Stack *, int, Assembly *);

int allocate_stack(Stack *, int, Assembly *);

void free_stack(Stack *, int);


typedef struct Value {
    // 1: tmp var on stack 2: constant
    int index;

    // for constant
    int int_num;

    // for tmp var
    int offset;
    Type_size size;
} Value;

Value *make_constant_val(int val);

Value *make_stack_val(int offset, Type_size size);

Value *clone_value(Value *);

int has_constant(Value *);

void set_constant(Value *, int val);

int get_constant(Value *);

int has_stack_offset(Value *);

void set_value_info(Value *, int offset, Type_size size);

Type_size get_type_size(Value *);

int get_stack_offset(Value *);

typedef struct Label {
    int beg_label;
    int end_label;
    int exit_label;
} Label;

void set_control_label(Label *);

void set_exit_label(Label *);

String *get_beg_label(Label *);

String *get_end_label(Label *);

String *get_exit_label(Label *);

typedef struct Analysis {
    String *name;
    Type self_type;

    // for code-generated
    Assembly *assembly;

    // for scope
    struct Analysis *parent;

    // for function
    Type ret_type;
    Vector *param;

    // for variable
    Stack stack_info;

    // for tmp var
    Value res_info;
} Analysis;

typedef Analysis Symbol;

void free_variables(Stack *, Symbol *);

void zero_extend(Assembly *code, int idx, Type_size original, Type_size new);

void pop_and_je(Assembly *code, Value *op1, String *if_equal, Stack *func_stack);

int pop_and_double_op(Assembly *code, Value *op1, char *op_prefix, Value *op2, Stack *);

int pop_and_single_op(Assembly *code, Value *op1, char *op_prefix, Value *op2, Stack *);

int pop_and_shift(Assembly *code, Value *op1, char *op_prefix, Value *op2, Stack *func_stack);

int pop_and_set(Assembly *code, Value *op1, char *op_prefix, Value *op2, Stack *func_stack);

void emit_jump(Assembly *code, String *label);

void emit_push_var(Assembly *code, Value *res_info, Stack *func_info);

int emit_push_register(Assembly *code, size_t idx, Type_size size, Stack *func_info);

void emit_pop(Assembly *code, Value *res_info, Stack *func_info, size_t idx);

void emit_func_signature(Assembly *code, String *str);

void emit_get_func_arguments(Assembly *code, Analysis *func);

void emit_set_func_arguments(Assembly *code, Analysis *func);

void emit_local_variable(Assembly *code, Symbol *s);

void add_while_label(Symbol *cond, Analysis *stat);

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