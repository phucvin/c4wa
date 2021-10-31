grammar c4wa;

@header {
package net.inet_lab.c4wa.autogen.parser;
}
// https://github.com/antlr/grammars-v4/blob/master/c/C.g4

module
    : global_decl* func+ EOF
    ;

global_decl
    : variable_decl ';'
    | EXTERN? variable_decl '(' param_list? ')' ';'
    ;

variable_decl
    : primitive ID          # variable_decl_primitive
    | primitive '*' ID      # variable_decl_pointer_to_primitive
    | STRUCT '*' ID         # variable_decl_pointer_to_struct
    ;

primitive : UNSIGNED? (LONG | INT | SHORT | CHAR);

func : EXTERN? variable_decl '(' param_list? ')' big_block;

param_list : variable_decl (',' variable_decl);

big_block: '{' element* '}';

block : big_block | element;

element
    : ';'                                   # element_empty
    | statement ';'                         # element_statement
    | ASM                                   # element_asm
    | DO block WHILE '(' expression ')'     # element_do_while
    | IF '(' expression ')' block           # element_if
    | IF '(' expression ')' block ELSE block # element_if_else
    ;

statement
    : variable_decl
    | simple_assignment
    | complex_assignment
    | function_call
    | return_expression
    ;

return_expression : RETURN expression;

simple_assignment : (ID '=')+ expression;

complex_assignment: lhs '=' expression;

lhs
    : expression '->' ID
    | expression '[' expression ']'
    ;

function_call : ID '(' arg_list? ')' ;

arg_list: expression (',' expression)*;

expression
    : CONST                         # expression_const
    | ID                            # expression_variable
    | expression BINARY_OP2 arg2    # expression_binary_op2
    | expression BINARY_OP1 arg2    # expression_binary_op1
    | function_call                 # expression_function_call
    ;

arg2 : expression;

CONST : [0-9]+;
BINARY_OP2 : '*'|'/'|'%';
BINARY_OP1 : '+'|'-';
PLUS   :  '+';
MINUS  :  '-';
UNSIGNED : 'unsigned';
LONG   :  'long';
INT    :  'int';
SHORT  :  'short';
CHAR   :  'char';
STRUCT :  'struct';
RETURN :  'return';
EXTERN :  'extern';
DO     :  'do';
WHILE  :  'while';
IF     :  'if';
ELSE   :  'else';

ID     :  [a-zA-Z_][a-zA-Z0-9_]*;
ASM    :  'asm' [ \t\n\r]* '{' .*? '}';

Whitespace
    :   [ \t]+
        -> skip
    ;

Newline
    :   (   '\r' '\n'?
        |   '\n'
        )
        -> skip
    ;

BlockComment
    :   '/*' .*? '*/'
        -> skip
    ;

LineComment
    :   '//' ~[\r\n]*
        -> skip
    ;
