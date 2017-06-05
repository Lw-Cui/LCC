#include <stdlib.h>
#include <memory.h>
#include <stdio.h>
#include "lcc.h"

Symbol *symtab = NULL;
Label label = {0};
FILE *output = NULL;

Symbol *symbol_cast(void *ptr) {
    return (Symbol *) ptr;
}

static Symbol *make_func_symbol(Type ret_type, String *name, Vector *param) {
    Symbol *ptr = make_symbol();
    ptr->ret_type = ret_type;
    ptr->name = name;
    ptr->param = param;
    ptr->parent = symtab;
    return ptr;
}

void enter_func_def_symbol(Type ret_type, String *name, Vector *param) {
    symtab = make_func_symbol(ret_type, name, param);
    symtab->self_type = DFUNC;
    symtab->assembly = make_assembly();
    symtab->offset = symtab->rsp = 0;
}

void exit_func_def() {
    while (symtab->self_type != FUNC_DECL) symtab = symtab->parent;
}

void make_func_decl_symbol(Type ret_type, String *name, Vector *param) {
    symtab = make_func_symbol(ret_type, name, param);
    symtab->self_type = FUNC_DECL;
}


void make_local_symbol(Type self_type, String *name, Vector *step, Value res_info) {
    Symbol *ptr = make_symbol();
    ptr->parent = symtab;
    symtab = ptr;
    symtab->self_type = self_type;
    symtab->name = name;
    symtab->step = step;
    symtab->res_info = res_info;
}


void make_new_scope() {
    Symbol *ptr = make_symbol();
    ptr->self_type = NEW_SCOPE;
    ptr->parent = symtab;
    symtab = ptr;
}

void destroy_new_scope() {
    while (symtab->self_type != NEW_SCOPE) {
        free_variables(symtab);
        symtab = symtab->parent;
    }
    symtab = symtab->parent;
}

Symbol *make_param_symbol(Type type, String *name) {
    Symbol *ptr = make_symbol();
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


Symbol *get_top_scope() {
    Symbol *s = symtab;
    while (s != NULL && s->self_type != DFUNC) s = s->parent;
    return s;
}

int in_global_scope() {
    Symbol *s = get_top_scope();
    return s == NULL;
}

void assembly_append(Assembly *p1, Assembly *p2) {
    if (p2 != NULL)
        append_list(p1->beg, p1->end, p2->beg, p2->end);
}

void emit_local_variable(Assembly *code) {
    if (has_stack_offset(&symtab->res_info))
        emit_pop(code, &symtab->res_info, 0);
    if (!is_array()) {
        // normal var
        symtab->offset = allocate_stack(real_size[symtab->self_type]);
        assembly_push_back(code, sprint("\t# allocate %s %d byte(s) %d(%%rbp)",
                                        str(symtab->name), real_size[symtab->self_type], -symtab->offset));
    } else {
        //array
        for (int i = 0; i < *(int *) at(symtab->step, 0) / real_size[symtab->self_type]; i++)
            symtab->offset = allocate_stack(real_size[symtab->self_type]);
        assembly_push_back(code, sprint("\t# allocate %s %d byte(s) %d(%%rbp)",
                                        str(symtab->name), *(int *) at(symtab->step, 0), -symtab->offset));
    }
    // initialization
    if (has_constant(&symtab->res_info)) {
        assembly_push_back(code, sprint("\tmov%c   $%d, %d(%%rbp)",
                                        op_suffix[symtab->self_type],
                                        get_constant(&symtab->res_info),
                                        -symtab->offset));
    } else if (has_stack_offset(&symtab->res_info)) {
        signal_extend(code, 0, get_type_size(&symtab->res_info), (Type_size) symtab->self_type);
        assembly_push_back(code, sprint("\tmov%c   %%%s, %d(%%rbp)",
                                        op_suffix[symtab->self_type],
                                        regular_reg[0][symtab->self_type],
                                        -symtab->offset));
    }
}

int allocate_stack(int bytes) {
    Symbol *stack_info = get_top_scope();
    for (int i = 0; i < bytes; i++)
        if ((stack_info->offset + i + bytes) % bytes == 0) {
            // rsp only could be increased; stack top is designed to do alloc/free.
            // Otherwise func call alignment cannot be satisfied
            while (stack_info->offset + i + bytes > stack_info->rsp) stack_info->rsp += 16;
            return stack_info->offset += i + bytes;
        }
    yyerror("allocation error");
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
    p->size = LONG_WORD;
}

void free_stack(int byte) {
    get_top_scope()->offset -= byte;
}

int has_stack_offset(Value *p) {
    return p->index == 1 || p->index == 3;
}

Symbol *find_name(String *name) {
    Symbol *s = symtab;
    while (s != NULL && !equal_string(s->name, name)) {
        s = s->parent;
    }
    return s;
}

Value *emit_push_array(Assembly *code, Value *res_info) {
    int offset = allocate_stack(real_size[QUAD_WORD]);
    assembly_push_back(code, sprint("\t# push %d(%%rbp)", -offset));
    assembly_push_back(code, sprint("\tleaq   %d(%%rbp), %%%s",
                                    -get_stack_offset(res_info),
                                    regular_reg[0][QUAD_WORD]));
    assembly_push_back(code, sprint("\tmovq   %%%s, %d(%%rbp)",
                                    regular_reg[0][QUAD_WORD],
                                    -offset));
    return make_array(offset, QUAD_WORD, res_info->step, 0);
}

Value *emit_push_var(Assembly *code, Value *res_info) {
    int offset = allocate_stack(real_size[get_type_size(res_info)]);
    assembly_push_back(code, sprint("\t# push %d(%%rbp)", -offset));
    assembly_push_back(code, sprint("\tmov%c   %d(%%rbp), %%%s",
                                    op_suffix[get_type_size(res_info)],
                                    -get_stack_offset(res_info),
                                    regular_reg[0][get_type_size(res_info)]));
    assembly_push_back(code, sprint("\tmov%c   %%%s, %d(%%rbp)",
                                    op_suffix[get_type_size(res_info)],
                                    regular_reg[0][get_type_size(res_info)],
                                    -offset));
    if (is_address(res_info))
        return make_pointer(offset, get_type_size(res_info));
    else
        return make_stack_val(offset, get_type_size(res_info));
}

int emit_push_register(Assembly *code, size_t idx, Type_size size) {
    int offset = allocate_stack(real_size[size]);
    assembly_push_back(code, sprint("\tmov%c   %%%s, %d(%%rbp)",
                                    op_suffix[size],
                                    regular_reg[idx][size],
                                    -offset));
    return offset;
}

void emit_pop(Assembly *code, Value *res_info, size_t idx) {
    if (has_stack_offset(res_info)) {
        assembly_push_back(code, sprint("\tmov%c   %d(%%rbp), %%%s",
                                        op_suffix[get_type_size(res_info)],
                                        -get_stack_offset(res_info),
                                        regular_reg[idx][get_type_size(res_info)]));
        free_stack(real_size[get_type_size(res_info)]);
    } else if (has_constant(res_info)) {
        assembly_push_back(code, sprint("\tmov%c   $%d, %%%s",
                                        op_suffix[get_type_size(res_info)],
                                        get_constant(res_info),
                                        regular_reg[idx][get_type_size(res_info)]));
    }
}

Value *pop_and_op(Assembly *code, Value *op1, char *op_prefix, Value *op2) {
    assembly_push_back(code, sprint("\t# (pop and) %s", op_prefix));
    emit_pop(code, op1, 0);
    emit_pop(code, op2, 1);
    Type_size max_type = max(get_type_size(op1), get_type_size(op2));
    signal_extend(code, 0, get_type_size(op1), max_type);
    signal_extend(code, 1, get_type_size(op2), max_type);
    assembly_push_back(code, sprint("\t%s%c   %%%s, %%%s",
                                    op_prefix,
                                    op_suffix[max_type],
                                    regular_reg[1][max_type],
                                    regular_reg[0][max_type]
    ));
    return make_stack_val(emit_push_register(code, 0, max_type), max_type);
}

Value *pop_and_single_op(Assembly *code, Value *op1, char *op_prefix, Value *op2) {
    assembly_push_back(code, sprint("\t# (pop and) %s", op_prefix));
    emit_pop(code, op1, 0);
    emit_pop(code, op2, 1);
    Type_size max_type = max(get_type_size(op1), get_type_size(op2));
    signal_extend(code, 0, get_type_size(op1), max_type);
    signal_extend(code, 1, get_type_size(op2), max_type);
    assembly_push_back(code, sprint("\t%s%c   %%%s",
                                    op_prefix,
                                    op_suffix[max_type],
                                    regular_reg[1][max_type]
    ));
    return make_stack_val(emit_push_register(code, 0, max_type), max_type);
}

Value *pop_and_shift(Assembly *code, Value *op1, char *op_prefix, Value *op2) {
    assembly_push_back(code, sprint("\t# (pop and) %s", op_prefix));
    emit_pop(code, op1, 0);
    emit_pop(code, op2, 2);
    assembly_push_back(code, sprint("\t%s%c   %%%s, %%%s",
                                    op_prefix,
                                    op_suffix[get_type_size(op1)],
                                    regular_reg[2][BYTE],
                                    regular_reg[0][get_type_size(op1)]
    ));
    return make_stack_val(emit_push_register(code, 0, get_type_size(op1)), get_type_size(op1));
}

void extend(Assembly *code, char *reg[][4], int idx, Type_size original, Type_size new) {
    if (original >= new) return;
    assembly_push_back(code, sprint("\tmovs%c%c %%%s, %%%s",
                                    op_suffix[original],
                                    op_suffix[new],
                                    reg[idx][original],
                                    reg[idx][new]
    ));
}

void signal_extend(Assembly *code, int idx, Type_size original, Type_size new) {
    extend(code, regular_reg, idx, original, new);
}

void arguments_extend(Assembly *code, int idx, Type_size original, Type_size new) {
    extend(code, arguments_reg, idx, original, new);
}

Value *pop_and_set(Assembly *code, Value *op1, char *op, Value *op2) {
    assembly_push_back(code, sprint("\t# (pop and) set"));
    emit_pop(code, op1, 0);
    emit_pop(code, op2, 1);
    Type_size max_type = max(get_type_size(op1), get_type_size(op2));
    signal_extend(code, 0, get_type_size(op1), max_type);
    signal_extend(code, 1, get_type_size(op2), max_type);
    assembly_push_back(code, sprint("\tcmp%c   %%%s, %%%s",
                                    op_suffix[max_type],
                                    regular_reg[1][max_type],
                                    regular_reg[0][max_type]
    ));
    assembly_push_back(code, sprint("\t%-7s%%%s",
                                    op,
                                    regular_reg[0][BYTE]
    ));
    signal_extend(code, 0, BYTE, QUAD_WORD);
    return make_stack_val(emit_push_register(code, 0, QUAD_WORD), QUAD_WORD);
}

void pop_and_je(Assembly *code, Value *op1, String *if_equal) {
    assembly_push_back(code, sprint("\t# (pop) cmp and je"));
    emit_pop(code, op1, 0);
    assembly_push_back(code, sprint("\tcmp%c   $0, %%%s",
                                    op_suffix[get_type_size(op1)],
                                    regular_reg[0][get_type_size(op1)]
    ));
    assembly_push_back(code, sprint("\tje     %s",
                                    str(if_equal)
    ));
}


void set_control_label(Label *p) {
    p->beg_label++;
    p->end_label++;
}

String *get_beg_label(Label *p) {
    return sprint(".B%d", p->beg_label);
}

String *get_end_label(Label *p) {
    return sprint(".E%d", p->end_label);
}

void free_variables(Symbol *symbol) {
    get_top_scope()->offset -= real_size[symbol->self_type];
}

void emit_jump(Assembly *code, String *label) {
    assembly_push_back(code, sprint("\tjmp    %s",
                                    str(label)));
}

void add_while_label(Symbol *cond, Analysis *stat) {
    set_control_label(&label);
    assembly_push_front(cond->assembly, append_char(get_beg_label(&label), ':'));
    pop_and_je(cond->assembly, &cond->res_info, get_end_label(&label));
    emit_jump(stat->assembly, get_beg_label(&label));
    assembly_push_back(stat->assembly, append_char(get_end_label(&label), ':'));
}

Type_size get_type_size(Value *p) {
    return p->size;
}

Value *make_constant_val(int val) {
    Value *ptr = (Value *) malloc(sizeof(Value));
    memset(ptr, 0, sizeof(Value));
    ptr->index = 2;
    ptr->int_num = val;
    ptr->size = LONG_WORD;
    return ptr;
}

Value *clone_value(Value *bak) {
    Value *ptr = (Value *) malloc(sizeof(Value));
    memset(ptr, 0, sizeof(Value));
    ptr->index = bak->index;
    ptr->offset = bak->offset;
    ptr->size = bak->size;
    ptr->int_num = bak->int_num;
    return ptr;
}

void set_exit_label(Label *p) {
    p->exit_label++;
}

String *get_exit_label(Label *p) {
    return sprint(".F%d", p->exit_label);
}

void emit_set_func_arguments(Assembly *code, Symbol *func) {
    Assembly *al = make_assembly();
    for (int i = 0; i < size(func->param); i++) {
        Value *arg = (Value *) (at(func->param, i));
        assembly_push_back(al, sprint("\t# passing arg %d", i));
        if (has_constant(arg)) {
            assembly_push_back(al, sprint("\tmov%c   $%d, %%%s",
                                          op_suffix[arg->size],
                                          get_constant(arg),
                                          arguments_reg[i][arg->size]
            ));
            arguments_extend(al, i, arg->size, QUAD_WORD);
        } else if (has_stack_offset(arg)) {
            assembly_push_back(al, sprint("\tmov%c   %d(%%rbp), %%%s",
                                          op_suffix[arg->size],
                                          -get_stack_offset(arg),
                                          arguments_reg[i][arg->size]
            ));
            arguments_extend(al, i, arg->size, QUAD_WORD);
        }
    }
    assembly_append(code, al);
}

void emit_get_func_arguments(Assembly *code) {
    Symbol *func = symtab;
    Assembly *al = make_assembly();
    for (int i = 0; i < size(func->param); i++) {
        Symbol *arg = symbol_cast(at(func->param, i));
        arg->parent = symtab;
        symtab = arg;
        arg->offset = allocate_stack(real_size[arg->self_type]);
        assembly_push_back(al, sprint("\t# passing %s %d byte(s) %d(%%rbp)",
                                      str(arg->name), real_size[arg->self_type], -arg->offset));
        assembly_push_back(al, sprint("\tmov%c   %%%s, %d(%%rbp)",
                                      op_suffix[arg->self_type],
                                      arguments_reg[i][arg->self_type],
                                      -arg->offset));
    }
    assembly_append(code, al);
}

Symbol *make_symbol() {
    Symbol *ptr = symbol_cast(malloc(sizeof(Symbol)));
    memset(ptr, 0, sizeof(Symbol));
    return ptr;
}

int is_array() {
    return symtab->step != NULL;
}

void convert_dimension_to_step() {
    Symbol *s = symtab;
    Vector *real_step = make_vector();

    add_dimension(s, 1);
    int bytes = real_size[s->self_type];
    for (int i = 0; i < size(s->step); i++)
        bytes *= *(int *) at(s->step, i);
    // first step means whole size; last step means self_type
    for (int i = 0; i < size(s->step); i++) {
        int *value = malloc(sizeof(int));
        *value = bytes;
        push_back(real_step, value);
        bytes /= *(int *) at(s->step, i);
    }
    s->step = real_step;
}

void add_dimension(Symbol *s, int d) {
    int *value = malloc(sizeof(int));
    *value = d;
    push_back(s->step, value);
}

Value *pop_and_index(Assembly *code, Value *op1, Value *op2) {
    // pop order doesn't matter -- it guarantees that all will be pop.
    assembly_push_back(code, sprint("\t# pop and index"));
    op2 = pop_and_single_op(code, op2, "mul", make_constant_val(*(int *) at(op1->step, ++op1->cur_dimension)));
    emit_pop(code, op2, 0);
    signal_extend(code, 0, op2->size, QUAD_WORD);
    emit_pop(code, op1, 2); // array
    assembly_push_back(code, sprint("\taddq   %%%s, %%%s",
                                    regular_reg[0][QUAD_WORD],
                                    regular_reg[2][QUAD_WORD]
    ));
    if (op1->cur_dimension == size(op1->step) - 1) {
        int offset = allocate_stack(real_size[get_type_size(op1)]);
        assembly_push_back(code, sprint("\t# index final res"));
        return emit_push_var(code, make_pointer(offset, get_type_size(op1)));
    } else {
        int offset = allocate_stack(real_size[QUAD_WORD]);
        assembly_push_back(code, sprint("\tmovq   %%%s, %d(%%rbp)",
                                        regular_reg[2][QUAD_WORD],
                                        -offset));
        return make_array(offset, op1->size, op1->step, op1->cur_dimension);
    }
}

Value *make_array(int offset, Type_size size, Vector *step, int dimension) {
    Value *ptr = make_pointer(offset, size);
    ptr->step = step;
    ptr->cur_dimension = dimension;
    return ptr;
}

static Value *make_value(int offset, Type_size size) {
    Value *p = (Value *) malloc(sizeof(Value));
    memset(p, 0, sizeof(Value));
    p->offset = offset;
    p->size = size;
    return p;
}

Value *make_stack_val(int offset, Type_size size) {
    Value *ptr = make_value(offset, size);
    ptr->index = 1;
    return ptr;
}

Value *make_pointer(int offset, Type_size size) {
    Value *ptr = make_value(offset, size);
    ptr->index = 3;
    return ptr;
}

int is_address(Value *p) {
    return p->index == 3;
}

