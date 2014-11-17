%{
#include<stdio.h>
#define YYDEBUG 1
int yylex(void);
void yyerror(const char* s) { fprintf(stderr, "%s\n", s); }
%}
%token CODE_BEGIN TYPE_IDENTIFIER DECLARE DO_KEY end array of INTEGER_TOKEN BOOLEAN_TOKEN CHAR_TOKEN REAL_TOKEN procedure IF_KEY then caractere WRITE_TOKEN COMA_SEPARATOR END_LINE_TOKEN READ_TOKEN WHILE_KEY until return_key  NOT_KEY goto_key ELSE_KEY ASSIGNMENT_KEY char-constant TRUE_VALUE FALSE_VALUE EQUALS LT GT LTE GTE DIFF MULT PLUS MINUS  AND_KEY DIVISION OR_KEY unsigned-integer unsigned-real PARENTESIS_OPEN THEN_KEY PARENTESIS_CLOSE END_KEY
%start program-linha
%%


program-linha :
              | CODE_BEGIN TYPE_IDENTIFIER proc-body
              ;
proc-body : block-stmt
          ;

block-stmt : declare-stmt DO_KEY stmt-list END_KEY;

declare-stmt :
             | DECLARE decl-list
             ;

decl-list : decl END_LINE_TOKEN resto_declist
          ;

resto_declist :
              | decl END_LINE_TOKEN resto_declist
              ;

decl : variable-decl
     | proc-decl;

variable-decl : type ident-list
              ;

ident-list : TYPE_IDENTIFIER resto_identlist;
resto_identlist :
                | COMA_SEPARATOR TYPE_IDENTIFIER resto_identlist
                ;

type : simple-type
     | array-type
     ;

simple-type : INTEGER_TOKEN
     | REAL_TOKEN
     | BOOLEAN_TOKEN
     | CHAR_TOKEN
     | label
     ;

array-type : array tamanho of simple-type
           ;

tamanho : integer-constant;

proc-decl : proc-header block-stmt;

proc-header : procedure TYPE_IDENTIFIER parentesis-params

parentesis-params :
                  | PARENTESIS_OPEN formal-list PARENTESIS_CLOSE
                  ;
formal-list :
            | parameter-decl formal-list
            ;

parameter-decl : parameter-type TYPE_IDENTIFIER;

parameter-type : type
               | proc-signature
               ;

proc-signature : procedure TYPE_IDENTIFIER parentesis-type

parentesis-type :
                | PARENTESIS_OPEN type-list PARENTESIS_CLOSE
                ;
type-list : parameter-type resto-parametertype;

resto-parametertype :
                    | COMA_SEPARATOR parameter-type resto-parametertype
                    ;

stmt-list : stmt END_LINE_TOKEN resto_stmt ;

resto_stmt :
           | stmt END_LINE_TOKEN resto_stmt
           ;

stmt : label ':' unlabelled-stmt
     | unlabelled-stmt
     ;




label : TYPE_IDENTIFIER;

unlabelled-stmt : assign-stmt;
                | if-stmt
                | loop-stmt
                | read-stmt
                | goto-stmt
                | proc-stmt
                | return-stmt
                | write-stmt
                ;


assign-stmt : variable ASSIGNMENT_KEY expression;

variable : TYPE_IDENTIFIER
          | array-element
          ;
array-element : TYPE_IDENTIFIER'[' expression ']';

if-stmt : IF_KEY condition THEN_KEY stmt-list if-stmt-linha END_KEY;

if-stmt-linha :
              | ELSE_KEY stmt-list
              ;

condition : expression;

loop-stmt : stmt-prefix stmt-list stmt-suffix;

stmt-prefix : WHILE_KEY condition DO_KEY
            | DO_KEY
            ;

stmt-suffix : until condition
            | end
            ;

read-stmt : READ_TOKEN PARENTESIS_OPEN ident-list PARENTESIS_CLOSE ;

write-stmt : WRITE_TOKEN PARENTESIS_OPEN expr-list PARENTESIS_CLOSE  ;

goto-stmt : goto_key label;

proc-stmt : TYPE_IDENTIFIER expr-list-linha;

expr-list-linha : { printf("blah  blah \n\n"); }
                | expr-list
                ;
return-stmt : return_key;

expr-list : expression resto-expressionlist;

resto-expressionlist :
                     | COMA_SEPARATOR expression resto-expressionlist
                     ;

expression : simple-expr simple_expr_linha ;

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
         | NOT_KEY factor
         | "-" factor
         ;

factor : variable
       | constant
       | PARENTESIS_OPEN expression PARENTESIS_CLOSE
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
      | OR_KEY
      ;

mulop : MULT
      | DIVISION
      | AND_KEY
      ;

constant : integer-constant
         | real-constant
         | char-constant
         | boolean-constant
         ;

boolean-constant : FALSE_VALUE
                 | TRUE_VALUE
                 ;

integer-constant : unsigned-integer;

real-constant : unsigned-real;


%%

 int main (void) {
    return yyparse ( );
    printf("this is (the end) a test");
 }

 void yyerror (char *s) {
    fprintf (stderr, "Parse error: %s\n", s);

 }
