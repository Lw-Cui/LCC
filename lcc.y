%{

#include <stdio.h>
#include <stdlib.h>
#include <memory.h>
#include <string.h>
#include <zconf.h>
#include "lcc.h"

/*
 *  assembly_append($1.assembly, $3.assembly);
 *  $$ = $1;
 */
#define APPEND_ASSEMBLY()\
        assembly_append((yyvsp[(1) - (3)]).assembly, (yyvsp[(3) - (3)]).assembly);\
        (yyval) = (yyvsp[(1) - (3)]);\

extern Label label;

int yylex(void);
void yyerror(const char *fmt, ...) {
	fflush(stdout);
    va_list ap;
    va_start(ap, fmt);
    fprintf(stderr, "*** ");
    vfprintf(stderr, fmt, ap);
    fprintf(stderr, "\n");
    va_end(ap);
}
%}
%token	IDENTIFIER I_CONSTANT F_CONSTANT STRING_LITERAL FUNC_NAME SIZEOF
%token	PTR_OP INC_OP DEC_OP LEFT_OP RIGHT_OP LE_OP GE_OP EQ_OP NE_OP
%token	AND_OP OR_OP MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN
%token	SUB_ASSIGN LEFT_ASSIGN RIGHT_ASSIGN AND_ASSIGN
%token	XOR_ASSIGN OR_ASSIGN
%token	TYPEDEF_NAME ENUMERATION_CONSTANT
%token	LEFT_BRACE RIGHT_BRACE

%token	TYPEDEF EXTERN STATIC AUTO REGISTER INLINE
%token	CONST RESTRICT VOLATILE
%token	BOOL CHAR SHORT INT LONG SIGNED UNSIGNED FLOAT DOUBLE VOID
%token	COMPLEX IMAGINARY
%token	STRUCT UNION ENUM ELLIPSIS

%token	CASE DEFAULT IF ELSE SWITCH WHILE DO FOR GOTO CONTINUE BREAK RETURN

%token	ALIGNAS ALIGNOF ATOMIC GENERIC NORETURN STATIC_ASSERT THREAD_LOCAL

%start translation_unit
%%

primary_expression
	: IDENTIFIER {
	    // just appeared in assignment expression
	    if (!$$.assembly) $$.assembly = make_assembly();
	    Symbol *var = find_name($1.name);
	    if (var == NULL) yyerror("%s hasn't been defined yet.", str($1.name));
	    if (var->step == NULL) {
	        $$.res_info = make_stack_val(var->offset, (Type_size)var->self_type);
	    } else {
	        $$.res_info = make_array(var->offset, (Type_size)var->self_type, var->step, 0);
            $$.res_info = emit_push_array($$.assembly, $$.res_info);
        }

	    $$.self_type = var->self_type;
	    // for func call
	    $$.name = var->name;
	    $$.ret_type = var->ret_type;
	    // for array
	    $$.step = var->step;
	}
	| constant {
	    // res_info has been set in lexx.l
	    if (!$$.assembly) $$.assembly = make_assembly();
	}
	| string
	| '(' expression ')'
	| generic_selection
	;

constant
	: I_CONSTANT            /* includes character_constant */
	| F_CONSTANT
	| ENUMERATION_CONSTANT	/* after it has been defined as such */
	;

enumeration_constant		/* before it has been defined as such */
	: IDENTIFIER
	;

string
	: STRING_LITERAL
	| FUNC_NAME
	;

generic_selection
	: GENERIC '(' assignment_expression ',' generic_assoc_list ')'
	;

generic_assoc_list
	: generic_association
	| generic_assoc_list ',' generic_association
	;

generic_association
	: type_name ':' assignment_expression
	| DEFAULT ':' assignment_expression
	;

postfix_expression
	: primary_expression
	| postfix_expression '[' expression ']' {
	    if (!$$.assembly) $$.assembly = make_assembly();
	    assembly_append($$.assembly, $1.assembly);
	    assembly_append($$.assembly, $3.assembly);

	    $$.res_info = pop_and_index($$.assembly, $1.res_info, $3.res_info);
	}
	| postfix_expression '(' ')'
	| postfix_expression '(' argument_expression_list ')' {
	    if (!$$.assembly) $$.assembly = make_assembly();
	    assembly_append($$.assembly, $3.assembly);
	    emit_set_func_arguments($$.assembly, &$3);
	    if ($1.self_type != FUNC_DECL && $1.self_type != DFUNC) yyerror("Don't find func name %s", str($1.name));
        assembly_push_back($$.assembly, sprint("\tcall   %s", str($1.name)));
        $$.res_info = make_stack_val(
            emit_push_register($$.assembly, 0, (Type_size)$1.ret_type),
            (Type_size)$1.ret_type
        );
        $$.self_type = FUNC_CALL;
	}
	| postfix_expression '.' IDENTIFIER
	| postfix_expression PTR_OP IDENTIFIER
	| postfix_expression INC_OP
	| postfix_expression DEC_OP
	| '(' type_name ')' left_brace initializer_list right_brace
	| '(' type_name ')' left_brace initializer_list ',' right_brace
	;

argument_expression_list
	: assignment_expression {
	    // first (actual) argument, different from 'parameter_list' used in function declaration
        if ($$.param == NULL) $$.param = make_vector();
        $$.assembly = $1.assembly;
        push_back($$.param, clone_value($1.res_info));
	}
	| argument_expression_list ',' assignment_expression {
	    assembly_append($1.assembly, $3.assembly);
        $$.assembly = $1.assembly;
        push_back($$.param, clone_value($3.res_info));
	}
	;

unary_expression
	: postfix_expression
	| INC_OP unary_expression
	| DEC_OP unary_expression
	| unary_operator cast_expression
	| SIZEOF unary_expression {
	}
	| SIZEOF '(' type_name ')'
	| ALIGNOF '(' type_name ')'
	;

unary_operator
	: '&'
	| '*'
	| '+'
	| '-'
	| '~'
	| '!'
	;

cast_expression
	: unary_expression {
	    // avoid pushing `a` into stack when parsing `a = b;`
	    // just push normal left-expression into stack
	    // while array has been pushed in `primary_expression`
	    if (!$$.assembly) $$.assembly = make_assembly();
	    assembly_append($$.assembly, $1.assembly);
        if ($1.self_type != FUNC_CALL && has_stack_offset($1.res_info) && $1.step == NULL) {
            $$.res_info = emit_push_var($$.assembly, $1.res_info);
        } else {
            $$.res_info = $1.res_info;
        }
	}
	| '(' type_name ')' cast_expression
	;

multiplicative_expression
	: cast_expression
	| multiplicative_expression '*' cast_expression {
        APPEND_ASSEMBLY();
        $$.res_info = pop_and_single_op($$.assembly, $1.res_info, "mul", $3.res_info);
	}
	| multiplicative_expression '/' cast_expression {
        APPEND_ASSEMBLY();
        $$.res_info = pop_and_single_op($$.assembly, $1.res_info, "div", $3.res_info);
	}
	| multiplicative_expression '%' cast_expression
	;

additive_expression
	: multiplicative_expression
	| additive_expression '+' multiplicative_expression {
        APPEND_ASSEMBLY();
        $$.res_info = pop_and_op($$.assembly, $1.res_info, "add", $3.res_info);
	}
	| additive_expression '-' multiplicative_expression {
        APPEND_ASSEMBLY();
        $$.res_info = pop_and_op($$.assembly, $1.res_info, "sub", $3.res_info);
	}
	;

shift_expression
	: additive_expression
	| shift_expression LEFT_OP additive_expression {
        APPEND_ASSEMBLY();
        $$.res_info = pop_and_shift($$.assembly, $1.res_info, "sal", $3.res_info);
	}
	| shift_expression RIGHT_OP additive_expression {
        APPEND_ASSEMBLY();
        $$.res_info = pop_and_shift($$.assembly, $1.res_info, "sar", $3.res_info);
	}
	;

relational_expression
	: shift_expression
	| relational_expression '<' shift_expression {
        APPEND_ASSEMBLY();
        $$.res_info = pop_and_set($$.assembly, $1.res_info, "setl", $3.res_info);
	}
	| relational_expression '>' shift_expression {
        APPEND_ASSEMBLY();
        $$.res_info = pop_and_set($$.assembly, $1.res_info, "setg", $3.res_info);
    }
	| relational_expression LE_OP shift_expression {
        APPEND_ASSEMBLY();
        $$.res_info = pop_and_set($$.assembly, $1.res_info, "setle", $3.res_info);
	}
	| relational_expression GE_OP shift_expression {
        APPEND_ASSEMBLY();
        $$.res_info = pop_and_set($$.assembly, $1.res_info, "setge", $3.res_info);
    }
	;

equality_expression
	: relational_expression
	| equality_expression EQ_OP relational_expression {
        APPEND_ASSEMBLY();
        $$.res_info = pop_and_set($$.assembly, $1.res_info, "sete", $3.res_info);
	}
	| equality_expression NE_OP relational_expression {
        APPEND_ASSEMBLY();
        $$.res_info = pop_and_set($$.assembly, $1.res_info, "setne", $3.res_info);
	}
	;

and_expression
	: equality_expression
	| and_expression '&' equality_expression
	;

exclusive_or_expression
	: and_expression
	| exclusive_or_expression '^' and_expression
	;

inclusive_or_expression
	: exclusive_or_expression
	| inclusive_or_expression '|' exclusive_or_expression
	;

logical_and_expression
	: inclusive_or_expression
	| logical_and_expression AND_OP inclusive_or_expression
	;

logical_or_expression
	: logical_and_expression
	| logical_or_expression OR_OP logical_and_expression
	;

conditional_expression
	: logical_or_expression
	| logical_or_expression '?' expression ':' conditional_expression
	;

assignment_expression
	: conditional_expression
	| unary_expression assignment_operator assignment_expression {
	    // TODO: extend signal
	    // Assignment, not initialization.
	    assembly_append($1.assembly, $3.assembly);
	    $$.assembly = $1.assembly;
        emit_pop($$.assembly, $3.res_info, 0);
        assembly_push_back($$.assembly, sprint("\t# assign"));
        if (is_pointer($1.res_info)) {
            emit_pop($$.assembly, $1.res_info, 1);
            assembly_push_back($$.assembly, sprint("\tmov%c   %%%s, (%%%s)",
                                        op_suffix[get_type_size($1.res_info)],
                                        regular_reg[0][get_type_size($1.res_info)],
                                        regular_reg[1][get_type_size($1.res_info)]));
        } else {
            assembly_push_back($$.assembly, sprint("\tmov%c   %%%s, %d(%%rbp)",
                                        op_suffix[get_type_size($1.res_info)],
                                        regular_reg[0][get_type_size($1.res_info)],
                                        -get_stack_offset($1.res_info)));
        }
	}
	;

assignment_operator
	: '=' {
	    $$.name = make_string("=");
	}
	| MUL_ASSIGN
	| DIV_ASSIGN
	| MOD_ASSIGN
	| ADD_ASSIGN
	| SUB_ASSIGN
	| LEFT_ASSIGN
	| RIGHT_ASSIGN
	| AND_ASSIGN
	| XOR_ASSIGN
	| OR_ASSIGN
	;

expression
	: assignment_expression
	| expression ',' assignment_expression {
	    assembly_append($1.assembly, $2.assembly);
	    $$.assembly = $1.assembly;
	}
	;

constant_expression
	: conditional_expression	/* with constraints */
	;

declaration
	: declaration_specifiers ';' {
	    /*
	     *  Maybe it's about struct:
	     *  struct A { int b; };
	     */
	    yyerror("`int;` isn't supported yet.");
	}
	| declaration_specifiers init_declarator_list ';' {
	    if (!in_global_scope()) {
            make_local_symbol($1.self_type, $2.name, $2.step, $2.res_info);
            // convert to array step
            if (is_cur_sym_array()) convert_dimension_to_step();
            if (!$$.assembly) $$.assembly = make_assembly();
            // $2.assembly stores initialization result, so should be appended firstly
            assembly_append($$.assembly, $2.assembly);
            emit_local_variable($$.assembly);
            // free for-loop var
            $$.name = $2.name;
	    } else if ($2.self_type == FUNC_DECL) {
            make_func_decl_symbol($1.self_type, $2.name, $2.param);
	    }
	}
	| static_assert_declaration
	;

declaration_specifiers
	: storage_class_specifier declaration_specifiers
	| storage_class_specifier
	| type_specifier declaration_specifiers
	| type_specifier
	| type_qualifier declaration_specifiers
	| type_qualifier
	| function_specifier declaration_specifiers
	| function_specifier
	| alignment_specifier declaration_specifiers
	| alignment_specifier
	;

init_declarator_list
	: init_declarator
	| init_declarator_list ',' init_declarator
	;

init_declarator
	: declarator '=' initializer {
	    $$.res_info = $3.res_info;
	    $$.assembly = $3.assembly;
	    $$.step = $1.step;
    }
	| declarator {
	    // no initializer
	    $$.res_info = make_value(0, 0);
	    $$.res_info->index = NONE;
	    $$.step = $1.step;
	}
	;

storage_class_specifier
	: TYPEDEF	/* identifiers must be flagged as TYPEDEF_NAME */
	| EXTERN
	| STATIC
	| THREAD_LOCAL
	| AUTO
	| REGISTER
	;

type_specifier
	: VOID
	| CHAR {
	    $$.self_type = DCHAR;
	}
	| SHORT {
	    $$.self_type = DSHORT;
	}
	| INT {
	    $$.self_type = DINT;
	}
	| LONG {
	    $$.self_type = DLONG;
	}
	| FLOAT
	| DOUBLE
	| SIGNED
	| UNSIGNED
	| BOOL
	| COMPLEX
	| IMAGINARY	  	/* non-mandated extension */
	| atomic_type_specifier
	| struct_or_union_specifier
	| enum_specifier
	| TYPEDEF_NAME		/* after it has been defined as such */
	;

struct_or_union_specifier
	: struct_or_union left_brace struct_declaration_list right_brace
	| struct_or_union IDENTIFIER left_brace struct_declaration_list right_brace
	| struct_or_union IDENTIFIER
	;

struct_or_union
	: STRUCT
	| UNION
	;

struct_declaration_list
	: struct_declaration
	| struct_declaration_list struct_declaration
	;

struct_declaration
	: specifier_qualifier_list ';'	/* for anonymous struct/union */
	| specifier_qualifier_list struct_declarator_list ';'
	| static_assert_declaration
	;

specifier_qualifier_list
	: type_specifier specifier_qualifier_list
	| type_specifier
	| type_qualifier specifier_qualifier_list
	| type_qualifier
	;

struct_declarator_list
	: struct_declarator
	| struct_declarator_list ',' struct_declarator
	;

struct_declarator
	: ':' constant_expression
	| declarator ':' constant_expression
	| declarator
	;

enum_specifier
	: ENUM left_brace enumerator_list right_brace
	| ENUM left_brace enumerator_list ',' right_brace
	| ENUM IDENTIFIER left_brace enumerator_list right_brace
	| ENUM IDENTIFIER left_brace enumerator_list ',' right_brace
	| ENUM IDENTIFIER
	;

enumerator_list
	: enumerator
	| enumerator_list ',' enumerator
	;

enumerator	/* identifiers must be flagged as ENUMERATION_CONSTANT */
	: enumeration_constant '=' constant_expression
	| enumeration_constant
	;

atomic_type_specifier
	: ATOMIC '(' type_name ')'
	;

type_qualifier
	: CONST
	| RESTRICT
	| VOLATILE
	| ATOMIC
	;

function_specifier
	: INLINE
	| NORETURN
	;

alignment_specifier
	: ALIGNAS '(' type_name ')'
	| ALIGNAS '(' constant_expression ')'
	;

declarator
	: pointer direct_declarator
	| direct_declarator
	;

direct_declarator
	: IDENTIFIER {
        // used in declaration, not normal expression
	    // TODO: for func arguments: int foo(int a[][6]);
    }
	| '(' declarator ')'
	| direct_declarator '[' ']'
	| direct_declarator '[' '*' ']'
	| direct_declarator '[' STATIC type_qualifier_list assignment_expression ']'
	| direct_declarator '[' STATIC assignment_expression ']'
	| direct_declarator '[' type_qualifier_list '*' ']'
	| direct_declarator '[' type_qualifier_list STATIC assignment_expression ']'
	| direct_declarator '[' type_qualifier_list assignment_expression ']'
	| direct_declarator '[' type_qualifier_list ']'
	| direct_declarator '[' assignment_expression ']' {
        if (!has_constant($3.res_info)) yyerror("Dimension of array should be constant");
        if ($1.step == NULL) $1.step = make_vector();
	    add_dimension(&$1, get_constant($3.res_info));
	    $$.step = $1.step;
	}
	| direct_declarator '(' parameter_type_list ')' {
	    // normal function declaration
	    $$.self_type = FUNC_DECL;
	    $$.name = $1.name;
	    $$.param = $3.param;
	}
	| direct_declarator '(' ')'
	| direct_declarator '(' identifier_list ')'
	;

pointer
	: '*' type_qualifier_list pointer
	| '*' type_qualifier_list
	| '*' pointer
	| '*'
	;

type_qualifier_list
	: type_qualifier
	| type_qualifier_list type_qualifier
	;


parameter_type_list
	: parameter_list ',' ELLIPSIS
	| parameter_list
	;

parameter_list
	: parameter_declaration
	| parameter_list ',' parameter_declaration {
	    // different from 'argument_expression_list' which used by function invoke
	    $$.param = $1.param;
	    push_back($$.param, back($3.param));
	}
	;

parameter_declaration
	: declaration_specifiers declarator {
	    // function parameter with name
        if ($$.param == NULL) $$.param = make_vector();
        Symbol *var = make_param_symbol($1.self_type, $2.name);
        push_back($$.param, var);
    }
	| declaration_specifiers abstract_declarator
	| declaration_specifiers {
	    // function parameter without name
        if ($$.param == NULL) $$.param = make_vector();
        push_back($$.param, make_symbol());
        symbol_cast(back($$.param))->self_type = $1.self_type;
    }
	;

identifier_list
	: IDENTIFIER
	| identifier_list ',' IDENTIFIER
	;

type_name
	: specifier_qualifier_list abstract_declarator
	| specifier_qualifier_list
	;

abstract_declarator
	: pointer direct_abstract_declarator
	| pointer
	| direct_abstract_declarator
	;

direct_abstract_declarator
	: '(' abstract_declarator ')'
	| '[' ']'
	| '[' '*' ']'
	| '[' STATIC type_qualifier_list assignment_expression ']'
	| '[' STATIC assignment_expression ']'
	| '[' type_qualifier_list STATIC assignment_expression ']'
	| '[' type_qualifier_list assignment_expression ']'
	| '[' type_qualifier_list ']'
	| '[' assignment_expression ']'
	| direct_abstract_declarator '[' ']'
	| direct_abstract_declarator '[' '*' ']'
	| direct_abstract_declarator '[' STATIC type_qualifier_list assignment_expression ']'
	| direct_abstract_declarator '[' STATIC assignment_expression ']'
	| direct_abstract_declarator '[' type_qualifier_list assignment_expression ']'
	| direct_abstract_declarator '[' type_qualifier_list STATIC assignment_expression ']'
	| direct_abstract_declarator '[' type_qualifier_list ']'
	| direct_abstract_declarator '[' assignment_expression ']'
	| '(' ')'
	| '(' parameter_type_list ')'
	| direct_abstract_declarator '(' ')'
	| direct_abstract_declarator '(' parameter_type_list ')'
	;

initializer
	: left_brace initializer_list right_brace
	| left_brace initializer_list ',' right_brace
	| assignment_expression
	;

initializer_list
	: designation initializer
	| initializer
	| initializer_list ',' designation initializer
	| initializer_list ',' initializer
	;

designation
	: designator_list '='
	;

designator_list
	: designator
	| designator_list designator
	;

designator
	: '[' constant_expression ']'
	| '.' IDENTIFIER
	;

static_assert_declaration
	: STATIC_ASSERT '(' constant_expression ',' STRING_LITERAL ')' ';'
	;

statement
	: labeled_statement
	| compound_statement
	| expression_statement
	| selection_statement
	| iteration_statement
	| jump_statement
	;

labeled_statement
	: IDENTIFIER ':' statement
	| CASE constant_expression ':' statement
	| DEFAULT ':' statement
	;

compound_statement
	: left_brace right_brace
	| left_brace block_item_list right_brace {
	    assembly_append($1.assembly, $2.assembly);
	    $$.assembly = $1.assembly;
        assembly_push_back($$.assembly, sprint("\t# end compound statement"));
        destroy_new_scope();
	}
	;

left_brace
    : LEFT_BRACE {
        if (!$$.assembly) $$.assembly = make_assembly();
        assembly_push_back($$.assembly, sprint("\t# start compound statement"));
        make_new_scope();
    }
    ;

right_brace
    : RIGHT_BRACE
    ;

block_item_list
	: block_item
	| block_item_list block_item {
	    assembly_append($1.assembly, $2.assembly);
	    $$.assembly = $1.assembly;
	}
	;

block_item
	: declaration
	| statement
	;

expression_statement
	: ';' {
	    // TODO: add some behavior when acting condition: for (;;)
	    $$.assembly = make_assembly();
	}
	| expression ';'
	;

selection_statement
	: IF '(' expression ')' statement ELSE statement {
        set_control_label(&label);
        // just pop. The top of stack is useless.
        pop_and_je($3.assembly, $3.res_info, get_beg_label(&label));
        assembly_push_front($7.assembly, append_char(get_beg_label(&label), ':'));
        assembly_push_back($7.assembly, append_char(get_end_label(&label), ':'));
        emit_jump($5.assembly, get_end_label(&label));
        assembly_append($5.assembly, $7.assembly);
        assembly_append($3.assembly, $5.assembly);
        $$.assembly = $3.assembly;
	}
	| IF '(' expression ')' statement {
        set_control_label(&label);
        pop_and_je($3.assembly, $3.res_info, get_end_label(&label));
        assembly_push_back($5.assembly, append_char(get_end_label(&label), ':'));
        assembly_append($3.assembly, $5.assembly);
        $$.assembly = $3.assembly;
	}
	| SWITCH '(' expression ')' statement
	;

iteration_statement
	: WHILE '(' expression ')' statement {
        add_while_label(&$3, &$5);
	    assembly_append($3.assembly, $5.assembly);
	    $$.assembly = $3.assembly;
	}
	| DO statement WHILE '(' expression ')' ';'
	| FOR '(' expression_statement expression_statement ')' statement {
	    // for (i = 5; i < 4;) i++;
	}
	| FOR '(' expression_statement expression_statement expression ')' statement {
	    // for (i = 5; i < 4; i++) i++;
	}
	| FOR '(' declaration expression_statement ')' statement {
	    // for (int i = 5; i < 4;) i++;
        add_while_label(&$4, &$6);
	    assembly_append($4.assembly, $6.assembly);
	    assembly_append($3.assembly, $4.assembly);
	    $$.assembly = $3.assembly;
	    free_variables(find_name($3.name));
	}
	| FOR '(' declaration expression_statement expression ')' statement {
	    // for (int i = 5; i < 4; i++) i++;
	    assembly_append($7.assembly, $5.assembly);
        add_while_label(&$4, &$7);
	    assembly_append($4.assembly, $7.assembly);
	    assembly_append($3.assembly, $4.assembly);
	    $$.assembly = $3.assembly;
	    free_variables(find_name($3.name));
	}
	;

jump_statement
	: GOTO IDENTIFIER ';'
	| CONTINUE ';'
	| BREAK ';'
	| RETURN ';'
	| RETURN expression ';' {
	    $$ = $2;
	    emit_pop($$.assembly, $2.res_info, 0);
	    emit_jump($$.assembly, get_exit_label(&label));
    }
	;

translation_unit
	: external_declaration {
        if ($1.assembly) assembly_output($1.assembly);
	}
	| translation_unit external_declaration {
        if ($2.assembly) assembly_output($2.assembly);
	}
	;

external_declaration
	: function_definition
	| declaration
	;

function_definition
	: function_definition_header compound_statement {
	    assembly_push_front($2.assembly, sprint("\tsubq   $%d, %%rsp", get_top_scope()->rsp));
	    assembly_append($1.assembly, $2.assembly);
	    $$ = $1;
	    // Important: 'return' maybe occurred anywhere
        assembly_push_back($$.assembly, append_char(get_exit_label(&label), ':'));
        // for next usage
	    set_exit_label(&label);
        assembly_push_back($$.assembly, sprint("\taddq   $%d, %%rsp", get_top_scope()->rsp));
        assembly_push_back($$.assembly, make_string("\tpopq   %rbp"));
        assembly_push_back($$.assembly, make_string("\tret\n"));
        // goto decl
        exit_func_def();
	}
	;

function_definition_header
    : declaration_specifiers declarator declaration_list
    | declaration_specifiers declarator {
        // To support recursion and symtab search
        // decl is the parent of def
        make_func_decl_symbol($1.self_type, $2.name, $2.param);
	    enter_func_def_symbol($1.self_type, $2.name, $2.param);
	    if (!$$.assembly) $$.assembly = make_assembly();
	    emit_func_signature($$.assembly, $2.name);
        assembly_push_back($$.assembly, make_string("\tpushq  %rbp"));
        assembly_push_back($$.assembly, make_string("\tmovq   %rsp, %rbp"));
        emit_get_func_arguments($$.assembly);
    }
    ;

declaration_list
	: declaration
	| declaration_list declaration {
	    assembly_append($1.assembly, $2.assembly);
	    $$.assembly = $1.assembly;
	}
	;

%%
