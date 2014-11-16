%{
#include <iostream>
#include "HashTable.h"
#include "const_tab.h"
#include "lms.tab.h"
    using namespace std;
    hashTable *symbol_table = new hashTable();
%}

PROCEDURE procedure
TYPE_IDENTIFIER [a-z]([a-zA-Z0-9]*)
REAL [0-9]+.[0-9]+
INTEGER [0-9]+
ASSIGNMENT :=
NEWLINE \n

%%
"+"  { return PLUS_OP; }
"-" { return MINUS_OP; }
"=" { return EQUALS; }
"<" { return LT; }
"<=" { return LTE; }
">" { return GT; }
">=" { return GTE;}
"!=" { return DIFF; }
"*" { return MUL_OP;}
"/" { return DIV_OP; }
"," { return COMA_SEPARATOR; }
";" { return END_LINE_TOKEN; }
"(" { return PARENTESIS_OPEN;}
")" { return PARENTESIS_CLOSE;}
{ASSIGNMENT} { return ASSIGNMENT_KEY; }


[ ]and[ ] {printf("%s\n", yytext); return AND_KEY; }
[ ]or[ ] { return OR_KEY; }
[ ]not[ ] { return NEGATIVE; }
{ASSIGNMENT} { return ASSIGNMENT; }

integer { return INTEGER_TOKEN; }
real { return REAL_TOKEN; }
boolean { return BOOLEAN_TOKEN; }
char_type { return CHAR_TOKEN; }

read { return READ_TOKEN; }
write { return WRITE_TOKEN; }
program { return CODE_BEGIN; }
[Dd][Ee][Cc][Ll][Aa][Rr][Ee] { return  DECLARE; }
[Dd][Oo] { symbol_table->enterBlock(); return DO_KEY; }
[Ll][Oo][Oo][Pp] { printf("%s\n", yytext);symbol_table->enterBlock(); return LOOP; }
[Ii][Ff] { printf("%s\n", yytext);symbol_table->enterBlock(); return IF; }
[Ee][Ll][Ss][Ee] { printf("%s\n", yytext);return ELSE; }
[Ww][Hh][Ii][Ll][Ee] { printf("%s\n", yytext);symbol_table->enterBlock(); return WHILE_KEY; }
[Gg][Oo][Tt][Oo] { printf("%s\n", yytext);return GOTO; }
[Rr][Ee][Tt][Uu][Rr][Nn] { printf("%s\n", yytext);return RETURN; }
[Ee][Nn][Dd] { printf("%s\n", yytext);symbol_table->exitBlock(); return END_KEY; }
[Pp][Rr][Oo][Cc][Ee][Dd][Uu][Rr][Ee] { printf("%s\n", yytext);symbol_table->enterBlock(); return PROCEDURE; }



{REAL} {
    return TYPE_REAL;
}

{INTEGER} {
    return TYPE_INTEGER;
}

{TYPE_IDENTIFIER} {
    printf("Identifier: %s\n", yytext);
    return TYPE_IDENTIFIER;

}
%%

int yywrap(){
    return 1;

}
