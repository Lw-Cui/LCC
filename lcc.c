#include <stdlib.h>
#include <stdio.h>
#include "lcc.h"

char *type_name[] = {
        "char",
        "int",
};

Symbol *symtab = 0;

Symbol *symbol_cast(void *ptr) {
    return (Symbol *) ptr;
}

Symbol *make_func_symbol(Type ret_type, String *name, Vector *param, Symbol *parent) {
    Symbol *ptr = symbol_cast(malloc(sizeof(Symbol)));
    ptr->self_type = DFUNC;
    ptr->ret_type = ret_type;
    ptr->name = name;
    ptr->param = param;
    ptr->parent = parent;
    return ptr;
}

void print_func_symbol(Symbol *func) {
    printf("FUNC_NAME %s\n", str(func->name));
    for (int i = 0; i < size(func->param); i++)
        printf("\tFUNC_PARAM %d: %s - %s\n", i, type_name[symbol_cast(at(func->param, i))->self_type],
               str(symbol_cast(at(func->param, i))->name));
}

Symbol *make_local_symbol(Type self_type, String *name, Symbol *parent) {
    Symbol *ptr = symbol_cast(malloc(sizeof(Symbol)));
    ptr->parent = parent;
    ptr->self_type = self_type;
    ptr->name = name;
    return ptr;
}

Symbol *make_new_scope(Symbol *parent) {
    Symbol *ptr = symbol_cast(malloc(sizeof(Symbol)));
    ptr->self_type = NEW_SCOPE;
    ptr->parent = parent;
    return ptr;
}

Symbol *make_param_symbol(Type type, String *name) {
    Symbol *ptr = symbol_cast(malloc(sizeof(Symbol)));
    ptr->self_type = type;
    ptr->name = name;
    return ptr;
}

void print_local_symbol(Symbol *var) {
    printf("\t\tLOCAL %s TYPE %s\n", str(var->name), type_name[var->self_type]);
}

Assembly *make_assembly() {
    Assembly *ptr = malloc(sizeof(Assembly));
    ptr->beg = make_list(NULL, NULL, NULL);
    ptr->end = make_list(ptr->beg, NULL, NULL);
    return ptr;
}

void assembly_push_back(Assembly *ptr, String *code) {
    make_list(ptr->end->prev, code, ptr->end);
}

void assembly_push_front(Assembly *ptr, String *code) {
    make_list(ptr->beg, code, ptr->beg->next);
}
