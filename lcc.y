%{

#include <stdio.h>
#include <stdlib.h>
#include <memory.h>
#include <string.h>
#include <zconf.h>
#include "lcc.h"
#define POP_AND_OP(op, inst)\
        assembly_append((yyvsp[(1) - (3)]).assembly, (yyvsp[(3) - (3)]).assembly);\
	    (yyval) = (yyvsp[(1) - (3)]);\
        Stack *func_stack = &get_top_scope(symtab)->stack_info;\
        set_stack_offset(&(yyval).res_info, \
            op((yyval).assembly, &(yyvsp[(1) - (3)]).res_info, inst, &(yyvsp[(3) - (3)]).res_info, func_stack));

extern Symbol *symtab;

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
	    Symbol *var = find_name(symtab, $1.name);
	    if (var == NULL) yyerror("%s hasn't been defined.", str(var->name));
	    set_stack_offset(&$$.res_info, var->stack_info.offset);
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
	| postfix_expression '[' expression ']'
	| postfix_expression '(' ')'
	| postfix_expression '(' argument_expression_list ')'
	| postfix_expression '.' IDENTIFIER
	| postfix_expression PTR_OP IDENTIFIER
	| postfix_expression INC_OP
	| postfix_expression DEC_OP
	| '(' type_name ')' left_brace initializer_list right_brace
	| '(' type_name ')' left_brace initializer_list ',' right_brace
	;

argument_expression_list
	: assignment_expression
	| argument_expression_list ',' assignment_expression
	;

unary_expression
	: postfix_expression
	| INC_OP unary_expression
	| DEC_OP unary_expression
	| unary_operator cast_expression
	| SIZEOF unary_expression
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
	    /* avoid pushing `a` into stack when parsing `a = b;` */
	    if (!$$.assembly) $$.assembly = make_assembly();
        emit_push_var($$.assembly, &$1.res_info, &get_top_scope(symtab)->stack_info);
        $$.res_info = $1.res_info;
	}
	| '(' type_name ')' cast_expression
	;

multiplicative_expression
	: cast_expression
	| multiplicative_expression '*' cast_expression {
	    POP_AND_OP(pop_and_single_op, "mul");
	}
	| multiplicative_expression '/' cast_expression {
	    POP_AND_OP(pop_and_single_op, "div");
	}
	| multiplicative_expression '%' cast_expression
	;

additive_expression
	: multiplicative_expression
	| additive_expression '+' multiplicative_expression {
	    POP_AND_OP(pop_and_double_op, "add");
	}
	| additive_expression '-' multiplicative_expression {
	    POP_AND_OP(pop_and_double_op, "sub");
	}
	;

shift_expression
	: additive_expression
	| shift_expression LEFT_OP additive_expression {
	    POP_AND_OP(pop_and_shift, "sal");
	}
	| shift_expression RIGHT_OP additive_expression {
	    POP_AND_OP(pop_and_shift, "sar");
	}
	;

relational_expression
	: shift_expression
	| relational_expression '<' shift_expression
	| relational_expression '>' shift_expression
	| relational_expression LE_OP shift_expression
	| relational_expression GE_OP shift_expression
	;

equality_expression
	: relational_expression
	| equality_expression EQ_OP relational_expression
	| equality_expression NE_OP relational_expression
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
	    // Assignment, not initialization.
	    assembly_append($1.assembly, $3.assembly);
	    $$.assembly = $1.assembly;
        Stack *func_stack = &get_top_scope(symtab)->stack_info;
        emit_pop($$.assembly, &$3.res_info, func_stack, 0);
        assembly_push_back($$.assembly, sprint("\t# assign"));
        assembly_push_back($$.assembly, sprint("\tmov%c   %%%s, %d(%%rbp)",
                                    op_suffix[LONG_WORD],
                                    reg[0][LONG_WORD],
                                    -get_stack_offset(&$1.res_info)));
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
	| expression ',' assignment_expression
	;

constant_expression
	: conditional_expression	/* with constraints */
	;

declaration
	: declaration_specifiers ';' {
	    /*
	        Maybe it's about struct:
	        struct A { int b; };
	    */
	    yyerror("`int;` isn't supported yet.");
	}
	| declaration_specifiers init_declarator_list ';' {
	    if (!in_global_scope(symtab)) {
	        symtab->self_type = $1.self_type;
            if (!$$.assembly) $$.assembly = make_assembly();
            // $2.assembly stores initialization result, so should be appended firstly
            assembly_append($$.assembly, $2.assembly);
            emit_local_variable($$.assembly, symtab);
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
	: init_declarator {
	    if (!in_global_scope(symtab))
            symtab = make_local_symbol(NOT_KNOWN, $1.name, symtab, $1.res_info);
        else
	        yyerror("Global var isn't supported yet: %s", str($1.name));
	}
	| init_declarator_list ',' init_declarator
	;

init_declarator
	: declarator '=' initializer {
	    $$.res_info = $3.res_info;
	    $$.assembly = $3.assembly;
    }
	| declarator {
	    // no initializer
	    $$.res_info.index = -1;
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
	| SHORT
	| INT {
	    $$.self_type = DINT;
	}
	| LONG
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
	: IDENTIFIER    // used in declaration, not normal expression
	| '(' declarator ')'
	| direct_declarator '[' ']'
	| direct_declarator '[' '*' ']'
	| direct_declarator '[' STATIC type_qualifier_list assignment_expression ']'
	| direct_declarator '[' STATIC assignment_expression ']'
	| direct_declarator '[' type_qualifier_list '*' ']'
	| direct_declarator '[' type_qualifier_list STATIC assignment_expression ']'
	| direct_declarator '[' type_qualifier_list assignment_expression ']'
	| direct_declarator '[' type_qualifier_list ']'
	| direct_declarator '[' assignment_expression ']'
	| direct_declarator '(' parameter_type_list ')' {
	    // normal function declaration
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
	    $$.param = $1.param;
	    push_back($$.param, back($3.param));
	}
	;

parameter_declaration
	: declaration_specifiers declarator {
	    // single function parameter
        if ($$.param == NULL) $$.param = make_vector();
        Symbol *var = make_param_symbol($1.self_type, $2.name);
        push_back($$.param, var);
    }
	| declaration_specifiers abstract_declarator
	| declaration_specifiers {
	    // function parameter
        if ($$.param == NULL) $$.param = make_vector();
        push_back($$.param, malloc(sizeof(Symbol)));
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
	    $$.assembly = $2.assembly;
	}
	;

left_brace
    : LEFT_BRACE {
        symtab = make_new_scope(symtab);
    }
    ;

right_brace
    : RIGHT_BRACE {
        while (symtab->self_type != NEW_SCOPE) symtab = symtab->parent;
        symtab = symtab->parent;
    }
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
	: ';'
	| expression ';'
	;

selection_statement
	: IF '(' expression ')' statement ELSE statement
	| IF '(' expression ')' statement
	| SWITCH '(' expression ')' statement
	;

iteration_statement
	: WHILE '(' expression ')' statement
	| DO statement WHILE '(' expression ')' ';'
	| FOR '(' expression_statement expression_statement ')' statement
	| FOR '(' expression_statement expression_statement expression ')' statement
	| FOR '(' declaration expression_statement ')' statement
	| FOR '(' declaration expression_statement expression ')' statement
	;

jump_statement
	: GOTO IDENTIFIER ';'
	| CONTINUE ';'
	| BREAK ';'
	| RETURN ';'
	| RETURN expression ';'
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
	    assembly_append($1.assembly, $2.assembly);
	    $$ = $1;
        assembly_push_back($$.assembly, sprint("\taddq   $%d, %%rsp", get_top_scope(symtab)->stack_info.rsp));
        assembly_push_back($$.assembly, make_string("\tpopq   %rbp"));
        assembly_push_back($$.assembly, make_string("\tret\n"));
        // goto decl
        symtab = symtab->parent;
	}
	;

function_definition_header
    : declaration_specifiers declarator declaration_list
    | declaration_specifiers declarator {
        // To support recursion
        Symbol *decl = make_func_decl_symbol($1.self_type, $2.name, $2.param, symtab);
	    symtab = make_func_def_symbol($1.self_type, $2.name, $2.param, decl);
	    if (!$$.assembly) $$.assembly = make_assembly();
	    emit_func_signature($$.assembly, $2.name);
        assembly_push_back($$.assembly, make_string("\tpushq  %rbp"));
        assembly_push_back($$.assembly, make_string("\tmovq   %rsp, %rbp"));
        emit_func_arguments($$.assembly, symtab);
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
