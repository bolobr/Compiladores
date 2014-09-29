%{
#include <iostream>
#include "HashTable.h"
#include "const_tab.h"
    using namespace std;
    hashTable *symbol_table = new hashTable();
%}
TYPE_INTEGER integer
TYPE_REAL real
TYPE_BOOLEAN boolean
PROCEDURE procedure
TYPE_ARRAY array
TYPE_IDENTIFIER [a-z]([a-zA-Z0-9]*)
ASSIGNMENT :=
ANY_TYPE integer
NEWLINE \n

%s EXPRESSION
%%
expression BEGIN(EXPRESSION);
<EXPRESSION>; {
    printf("When it passess here?");
    return LOOP;
}

{TYPE_INTEGER} {
    symbol_table->install(yytext, "INTEGER");
    BEGIN(EXPRESSION);
    printf("it should show this");
    return TYPE_INTEGER; }
real{TYPE_IDENTIFIER} {
    symbol_table->install(yytext, "REAL");
    return TYPE_REAL; }
procedure{TYPE_IDENTIFIER} {
    symbol_table->install(yytext, "PROCEDURE");
    return TYPE_PROCEDURE;
}

boolean{TYPE_IDENTIFIER} {
    symbol_table->install(yytext, "BOOLEAN");
    return TYPE_BOOLEAN;
}

array{TYPE_INTEGER}{ANY_TYPE}{TYPE_IDENTIFIER} {
    symbol_table->install(yytext, "Array");
    return TYPE_ARRAY;
}

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

and { return AND_OP; }
or { return OR_OP; }
not { return NEGATIVE; }
program { return CODE_BEGIN; }
{ASSIGNMENT} { return ASSIGNMENT; }
[Dd][Ee][Cc][Ll][Aa][Rr][Ee] { return  DECLARE; }
[Dd][Oo] { symbol_table->enterBlock(); return DO; }
[Ll][Oo][Oo][Pp] { symbol_table->enterBlock(); return LOOP; }
[Ii][Ff] { symbol_table->enterBlock(); return IF; }
[Ee][Ll][Ss][Ee] { return ELSE; }
[Ww][Hh][Ii][Ll][Ee] { symbol_table->enterBlock(); return WHILE; }
[Gg][Oo][Tt][Oo] { return GOTO; }
[Rr][Ee][Tt][Uu][Rr][Nn] { return RETURN; }
[Ee][Nn][Dd] { symbol_table->exitBlock(); return END; }
[Pp][Rr][Oo][Cc][Ee][Dd][Uu][Rr][Ee] { symbol_table->enterBlock(); return PROCEDURE; }



%%

main() {
	// open a file handle to a particular file:
	FILE *myfile = fopen("user_program.file", "r");
	// make sure it's valid:
	if (!myfile) {
		cout << "I can't open user program!" << endl;
		return -1;
	}
	// set lex to read from it instead of defaulting to STDIN:
	yyin = myfile;
    int n = 1;
	// lex through the input:
	while(n){
       n = yylex();
    }
    symbol_table->print();
}

int yywrap(){
    return 1;

}
