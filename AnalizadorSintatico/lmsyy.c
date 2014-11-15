%{
#include <iostream>
#include "HashTable.h"
#include "const_tab.h"
    using namespace std;
    hashTable *symbol_table = new hashTable();
%}

PROCEDURE procedure
TYPE_IDENTIFIER [a-z]([a-zA-Z0-9]*)
REAL [0-9]+.[0-9]+
INTEGER [0-9]+
ASSIGNMENT :=
NEWLINE \n

%x LIST_FOLLOW EXPRESSION
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

[ ]and[ ] { return AND_OP; }
[ ]or[ ] { return OR_OP; }
[ ]not[ ] { return NEGATIVE; }
{ASSIGNMENT} { return ASSIGNMENT; }

program { return CODE_BEGIN; }
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

{TYPE_IDENTIFIER} {
    return 1;

}

{REAL} {
    printf("real");
    return 1;
}

{INTEGER} {
    return 1;
}


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
}

int yywrap(){
    return 1;

}
