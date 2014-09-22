%{
#include <iostream>
#include "HashTable.h"
#include "const_tab.h"
    using namespace std;
    hashTable *symbol_table = new hashTable();
%}
TYPE_INTEGER [0-9]+
TYPE_REAL [0-9]+.[0-9]*
TYPE_IDENTIFIER [a-z]([a-zA-Z0-9]*)
ASSIGNMENT :=

NEWLINE \n
%%


{TYPE_INTEGER} {
    symbol_table->install(yytext, "INTEGER" );
    return TYPE_INTEGER; }
{TYPE_REAL} {
    symbol_table->install(yytext, "REAL");
    return TYPE_REAL; }

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
[Dd][Oo] { return DO; }
[Ll][Oo][Oo][Pp] { return LOOP; }
[Ii][Ff] { return IF; }
[Ee][Ll][Ss][Ee] { return ELSE; }
[Ww][Hh][Ii][Ll][Ee] { return WHILE; }
[Gg][Oo][Tt][Oo] { return GOTO; }
[Rr][Ee][Tt][Uu][Rr][Nn] { return RETURN; }
[Ee][Nn][Dd] { return END; }
{TYPE_IDENTIFIER} {
    symbol_table->install(yytext, "IDENTIFIER");
    return TYPE_IDENTIFIER; }

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
