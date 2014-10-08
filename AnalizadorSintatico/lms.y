%{
#include<stdio.h>

%}
%token  declare do end array of integer boolean char real procedure if then identifier digit letter caractere write read while until true false return program or not goto and else assignment char-constant TRUE FALSE EQUALS LT GT LTE GTE DIFF MULT PLUS MINUS  AND DIVISION OR unsigned-integer unsigned-real
%start program-linha
%%


program-linha :
          | program identifier proc-body ;

proc-body : block-stmt
          ;

block-stmt : declare-stmt do stmt-list end
           ;

declare-stmt :
             | declare decl-list;

decl-list : decl resto_declist
          ;

resto_declist :
              | ';' decl resto_declist
              ;

decl : variable-decl
     | proc-decl;

variable-decl : type ident-list
              ;

ident-list : identifier resto_identlist;

resto_identlist :
                | ',' identifier resto_identlist
                ;

type : simple-type
     | array-type
     ;

simple-type : integer
     | real
     | boolean
     | char
     | label
     ;

array-type : array tamanho of simple-type
           ;

tamanho : integer-constant;

proc-decl : proc-header block-stmt;

proc-header : procedure identifier parentesis-params

parentesis-params :
                  | '(' formal-list ')'
                  ;
formal-list :
            | parameter-decl formal-list
            ;

parameter-decl : parameter-type identifier;

parameter-type : type
               | proc-signature
               ;

proc-signature : procedure identifier parentesis-type

parentesis-type :
                | '(' type-list ')'
                ;
type-list : parameter-type resto-parametertype;

resto-parametertype :
                    | ','parameter-type resto-parametertype
                    ;

stmt-list : stmt resto_stmt;

resto_stmt :
           | ';'stmt resto_stmt
           ;

stmt : label ':' unlabelled-stmt
     | unlabelled-stmt;




label : identifier;
unlabelled-stmt : assign-stmt;
                | if-stmt
                | loop-stmt
                | read-stmt
                | goto-stmt
                | proc-stmt
                | return-stmt
                /* | block-stmt */
                | write-stmt
                ;


assign-stmt : variable assignment expression;

variable : identifier
          | array-element
          ;
array-element : identifier'[' expression ']';

if-stmt : if condition then stmt-list if-stmt-linha end;

if-stmt-linha :
              | else stmt-list
              ;

condition : expression;

loop-stmt : stmt-prefix stmt-list stmt-suffix;

stmt-prefix : while condition do
            | do
            ;

stmt-suffix : until condition
            | end
            ;

read-stmt : read '(' ident-list ')';

write-stmt : write '(' expr-list ')';

goto-stmt : goto label;

proc-stmt : identifier expr-list-linha;

expr-list-linha :
                | expr-list
                ;
return-stmt : return;

expr-list : expression resto-expressionlist;

resto-expressionlist :
                     | ','expression resto-expressionlist
                     ;

expression : simple-expr simple_expr_linha;

simple_expr_linha :
                  | relop simple-expr
                  ;

simple-expr : term simple_expr_list;

simple_expr_list :
                 | addop term simple_expr_list;

term : factor-a term_linha;

term_linha :
           | mulop factor-a term_linha
           ;

factor-a : factor
         | not factor
         | "-" factor
         ;

factor : variable
       | constant
       | '(' expression ')'
       ;

relop : EQUALS
      | LT
      | GT
      | GTE
      | LTE
      | DIFF
      ;

addop : PLUS
      | MINUS
      | OR
      ;

mulop : MULT
      | DIVISION
      | AND
      ;

constant : integer-constant
         | real-constant
         | char-constant
         | boolean-constant
         ;

boolean-constant : FALSE
                 | TRUE
                 ;

integer-constant : unsigned-integer;

real-constant : unsigned-real;

/* char-constant : caractere; */
/*  */
/*  */
/*  */
/*  */

%%


 int main (void) {return yyparse ( );}

 void yyerror (char *s) {fprintf (stderr, "%s\n", s);}
