#include <stdlib.h>
#include <stdio.h>
#include "lcc.h"

Symbol *symtab = 0;
FILE *output = NULL;

Symbol *symbol_cast(void *ptr) {
    return (Symbol *) ptr;
}

Symbol *make_func_def_symbol(Type ret_type, String *name, Vector *param, Symbol *parent) {
    Symbol *ptr = symbol_cast(malloc(sizeof(Symbol)));
    ptr->self_type = DFUNC;
    ptr->ret_type = ret_type;
    ptr->name = name;
    ptr->param = param;
    ptr->parent = parent;
    ptr->assembly = make_assembly();
    ptr->stack_info.offset = ptr->stack_info.rsp = 0;
    return ptr;
}

Symbol *make_local_symbol(Type self_type, String *name, Symbol *parent, Value res_info) {
    Symbol *ptr = symbol_cast(malloc(sizeof(Symbol)));
    ptr->parent = parent;
    ptr->self_type = self_type;
    ptr->name = name;
    ptr->res_info = res_info;
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

void emit_func_signature(Assembly *code, String *s) {
    assembly_push_back(code, sprint("\t.globl %s\n\t.type  %s, @function", str(s), str(s)));
    assembly_push_back(code, sprint("%s:", str(s)));
}

void assembly_output(Assembly *ptr) {
    for (List_node *p = ptr->beg->next; p != ptr->end; p = p->next)
        fprintf(output, "%s\n", str(p->body));
}

void emit_func_arguments(Assembly *code, Analysis *func) {
    Assembly *al = make_assembly();
    for (int i = 0; i < size(func->param); i++) {
        Symbol *arg = symbol_cast(at(func->param, i));
        arg->parent = symtab;
        symtab = arg;
        arg->stack_info.offset = allocate_stack(&func->stack_info, real_size[arg->self_type], al);
        assembly_push_back(al, sprint("\t# passing %s %d byte(s) %d(%%rbp)",
                                      str(arg->name), real_size[arg->self_type], -arg->stack_info.offset));
        assembly_push_back(al, sprint("\tmov%c   %s, %d(%%rbp)",
                                      op_suffix[arg->self_type],
                                      arugments_register[arg->self_type][i],
                                      -arg->stack_info.offset));
    }
    assembly_append(code, al);
}

Symbol *get_top_scope(Symbol *symtab) {
    Symbol *s = symtab;
    while (s != NULL && s->self_type != DFUNC) s = s->parent;
    return s;
}

int in_global_scope(Symbol *symtab) {
    Symbol *s = get_top_scope(symtab);
    return s == NULL;
}

void assembly_append(Assembly *p1, Assembly *p2) {
    if (p2 != NULL)
        append_list(p1->beg, p1->end, p2->beg, p2->end);
}

void emit_local_variable(Assembly *code, Symbol *s) {
    Symbol *func = get_top_scope(s);
    if (has_stack_offset(&s->res_info))
        emit_pop(code, &s->res_info, &func->stack_info, 0);

    s->stack_info.offset = allocate_stack(&func->stack_info, real_size[s->self_type], code);
    assembly_push_back(code, sprint("\t# allocate %s %d byte(s) %d(%%rbp)",
                                    str(s->name), real_size[s->self_type], -s->stack_info.offset));
    if (has_constant(&s->res_info)) {
        assembly_push_back(code, sprint("\tmov%c   $%d, %d(%%rbp)",
                                        op_suffix[s->self_type],
                                        get_constant(&s->res_info),
                                        -s->stack_info.offset));
    } else if (has_stack_offset(&s->res_info)) {
        assembly_push_back(code, sprint("\tmov%c   %%%s, %d(%%rbp)",
                                        op_suffix[s->self_type],
                                        reg[0][s->self_type],
                                        -s->stack_info.offset));
    }
    // after init, res_info should be set as the same as stack_info
    set_stack_offset(&s->res_info, s->stack_info.offset);
}

Symbol *make_func_decl_symbol(Type ret_type, String *name, Vector *param, Symbol *parent) {
    Symbol *decl = symbol_cast(malloc(sizeof(Symbol)));
    decl->self_type = DFUNC_NAME;
    decl->ret_type = ret_type;
    decl->name = name;
    decl->param = param;
    decl->parent = parent;
    return decl;
}

int allocate_stack(Stack *stack_info, int bytes, Assembly *code) {
    for (int i = 0; i < bytes; i++)
        if ((stack_info->offset + i + bytes) % bytes == 0) {
            int ori = stack_info->rsp;
            while (stack_info->offset + i + bytes > stack_info->rsp) stack_info->rsp += 16;
            if (stack_info->rsp > ori)
                assembly_push_back(code, sprint("\tsubq   $%d, %%rsp", stack_info->rsp - ori));
            return stack_info->offset += i + bytes;
        }
    return 0xFFFF;
}

int has_constant(Value *p) {
    return p->index == 2;
}

int get_constant(Value *p) {
    return (p->index == 2 ? p->int_num : 0xFFFF);
}

int get_stack_offset(Value *p) {
    return (has_stack_offset(p) ? p->offset : 0xFFFF);
}

void set_constant(Value *p, int val) {
    p->index = 2;
    p->int_num = val;
}

void set_stack_offset(Value *p, int offset) {
    p->index = 1;
    p->offset = offset;
}

void free_stack(Stack *p, int byte) {
    p->offset -= byte;
}

int has_stack_offset(Value *p) {
    return p->index == 1;
}

Symbol *find_name(Symbol *symtab, String *name) {
    Symbol *s = symtab;
    while (s != NULL && !equal_string(s->name, name)) s = s->parent;
    return s;
}

void emit_push_var(Assembly *code, Value *res_info, Stack *func_info) {
    //Noting to do with res_info when it stores real value
    if (has_stack_offset(res_info)) {
        int offset = allocate_stack(func_info, real_size[LONG_WORD], code);
        assembly_push_back(code, sprint("\t# push %d(%%rbp)", -offset));
        assembly_push_back(code, sprint("\tmov%c   %d(%%rbp), %%%s",
                                        op_suffix[LONG_WORD],
                                        -get_stack_offset(res_info),
                                        reg[0][LONG_WORD]));
        assembly_push_back(code, sprint("\tmov%c   %%%s, %d(%%rbp)",
                                        op_suffix[LONG_WORD],
                                        reg[0][LONG_WORD],
                                        -offset));
        set_stack_offset(res_info, offset);
    }
}

int emit_push_register(Assembly *code, size_t idx, Stack *func_info) {
    int offset = allocate_stack(func_info, real_size[LONG_WORD], code);
    assembly_push_back(code, sprint("\tmov%c   %%%s, %d(%%rbp)",
                                    op_suffix[LONG_WORD],
                                    reg[idx][LONG_WORD],
                                    -offset));
    return offset;
}

void emit_pop(Assembly *code, Value *res_info, Stack *func_info, size_t idx) {
    if (has_stack_offset(res_info)) {
        assembly_push_back(code, sprint("\tmov%c   %d(%%rbp), %%%s",
                                        op_suffix[LONG_WORD],
                                        -get_stack_offset(res_info),
                                        reg[idx][LONG_WORD]));
        free_stack(func_info, 4);
    } else if (has_constant(res_info)) {
        assembly_push_back(code, sprint("\tmov%c   $%d, %%%s",
                                        op_suffix[LONG_WORD],
                                        get_constant(res_info),
                                        reg[idx][LONG_WORD]));
    }
}

int pop_and_double_op(Assembly *code, Value *op1, char *op_prefix, Value *op2, Stack *func_stack) {
    assembly_push_back(code, sprint("\t# (pop and) %s", op_prefix));
    emit_pop(code, op1, func_stack, 0);
    emit_pop(code, op2, func_stack, 1);
    assembly_push_back(code, sprint("\t%s%c   %%%s, %%%s",
                                    op_prefix,
                                    op_suffix[LONG_WORD],
                                    reg[1][LONG_WORD],
                                    reg[0][LONG_WORD]
    ));
    return emit_push_register(code, 0, func_stack);
}

int pop_and_single_op(Assembly *code, Value *op1, char *op_prefix, Value *op2, Stack *func_stack) {
    assembly_push_back(code, sprint("\t# (pop and) %s", op_prefix));
    emit_pop(code, op1, func_stack, 0);
    emit_pop(code, op2, func_stack, 1);
    assembly_push_back(code, sprint("\t%s%c   %%%s",
                                    op_prefix,
                                    op_suffix[LONG_WORD],
                                    reg[1][LONG_WORD]
    ));
    return emit_push_register(code, 0, func_stack);
}

int pop_and_shift(Assembly *code, Value *op1, char *op_prefix, Value *op2, Stack *func_stack) {
    assembly_push_back(code, sprint("\t# (pop and) %s", op_prefix));
    emit_pop(code, op1, func_stack, 0);
    emit_pop(code, op2, func_stack, 2);
    assembly_push_back(code, sprint("\t%s%c   %%%s, %%%s",
                                    op_prefix,
                                    op_suffix[LONG_WORD],
                                    reg[2][BYTE],
                                    reg[0][LONG_WORD]
    ));
    return emit_push_register(code, 0, func_stack);
}

int pop_and_set(Assembly *code, Value *op1, char *op, Value *op2, Stack *func_stack) {
    assembly_push_back(code, sprint("\t# %s", op));
    assembly_push_back(code, sprint("\t%s   %%%s",
                                    op,
                                    reg[0][BYTE]
    ));
    assembly_push_back(code, sprint("\tmovz%c%c %%%s, %%%s",
                                    op_suffix[BYTE],
                                    op_suffix[LONG_WORD],
                                    reg[0][BYTE],
                                    reg[0][LONG_WORD]
    ));
    return emit_push_register(code, 0, func_stack);
}

