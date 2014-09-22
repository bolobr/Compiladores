/*
 *  The scanner definition for COOL.
 */

/*
 *  Stuff enclosed in %{ %} in the first section is copied verbatim to the
 *  output, so headers and global definitions are placed here to be visible
 * to the code in the file.  Don't remove anything that was here initially
 */
%{
#include <cool-parse.h>
#include <stringtab.h>
#include <utilities.h>

/* The compiler assumes these identifiers. */
#define yylval cool_yylval
#define yylex  cool_yylex

/* Max size of string constants */
#define MAX_STR_CONST 1025
#define YY_NO_UNPUT   /* keep g++ happy */

extern FILE *fin; /* we read from this file */

extern void cool_yyrestart(FILE *f){
 yyrestart(f);
}
/* define YY_INPUT so we read from the FILE fin:
 * This change makes it possible to use this scanner in
 * the Cool compiler.
 */
#undef YY_INPUT
#define YY_INPUT(buf,result,max_size) \
	if ( (result = fread( (char*)buf, sizeof(char), max_size, fin)) < 0) \
		YY_FATAL_ERROR( "read() in flex scanner failed");

char string_buf[MAX_STR_CONST]; /* to assemble string constants */
char *string_buf_ptr;

extern int curr_lineno;
extern int verbose_flag;

extern YYSTYPE cool_yylval;

/*
 *  Add Your own definitions here
 */
int nest_level = 0; //Conta o nivel de identaÃÃo;
std::string str = "";
bool invalid_str = false;
%}

/*
 * Define names for regular expressions here.
 */

DARROW          =>
INTEGER [0-9]+
TYPE_ID [a-z]([a-zA-Z0-9]*)
OBJECT_ID [a-z]([a-zA-Z0-9]*)
COMMENT_START("(*")
COMMENT_END("*)")
NEWLINE \n
ASSIGN <-
EscapedCharacters [\n\f\r\t\v\32 ]

%x EXPRESSION TOKEN

%%

 /*
  *  Nested comments
  */
<INITIAL,EXPRESSION>\(\* {
  ++nest_level;
  BEGIN(EXPRESSION);
}

<EXPRESSION>\*\) {
  --nest_level;
  if(nest_level <= 0)
  {
    str = "";
    if(nest_level == 0)
      BEGIN(INITIAL);
    else {
      nest_level = 0;
      cool_yylval.error_msg = "Unmatched *)";
      return (ERROR);
    }
  }
}

<INITIAL>\*\) {
  cool_yylval.error_msg = "Unmatched *)";
  return (ERROR);
}

<EXPRESSION>. { 
  str += yytext;
}

<EXPRESSION><<EOF>> {
  BEGIN(INITIAL);
  cool_yylval.error_msg = "Ended file before expected";
  return (ERROR);
}

 /*
  *  The multiple-character operators.
  */
{DARROW}		{ return (DARROW); }
{ASSIGN} {return (ASSIGN);}

 /*
  * Keywords are case-insensitive except for the values true and false,
  * which must begin with a lower-case letter.
  */
 /* Keywords */
[Cc][Ll][Aa][Ss][Ss] { return (CLASS); }  // class
[Ii][Nn][Hh][Ee][Rr][Ii][Tt][Ss] { return (INHERITS); }  // inherits
[Ii][Ff] { return (IF); }  // if
[Ee][Ll][Ss][Ee] { return (ELSE); }  // else
[Ff][Ii] { return (FI); }  // fi
[Ii][Nn] { return (IN); }  // in
[Ii][Ss][Vv][Oo][Ii][Dd] { return (ISVOID); }  // isvoid
[Ll][Ee][Tt] { return (LET); }  // let
[Ll][Oo][Oo][Pp] { return (LOOP); }  // loop
[Pp][Oo][Oo][Ll] { return (POOL); }  // pool
[Tt][Hh][Ee][Nn] { return (THEN); }  // then
[Ww][Hh][Ii][Ll][Ee] { return (WHILE); }  // while
[Cc][Aa][Ss][Ee] { return (CASE); }  // case
[Ee][Ss][Aa][Cc] { return (ESAC); }  // esac
[Nn][Ee][Ww] { return (NEW); }  // new
[Oo][Ff] { return (OF); }  // of
[Nn][Oo][Tt] { return (NOT); }  // not

f[aA][lL][sS][eE] {
  cool_yylval.boolean = false;
  return (BOOL_CONST);
}

t[rR][uU][eE] {
  cool_yylval.boolean = true;
  return (BOOL_CONST);
}
     /* Operators */
"+"      { return ('+'); }
"-"      { return ('-'); }
"="      { return ('='); }
"<"      { return ('<'); }
\.      { return ('.'); }
"~"      { return ('~'); }
","      { return (','); }
";"      { return (';'); }
":"      { return (':'); }
")"      { return (')'); }
"@"      { return ('@'); }
"{"      { return ('{'); }
"}"      { return ('}'); }
"*"      { return ('*'); }
"("      { return ('('); }

 /*
  *  String constants (C syntax)
  *  Escape sequence \c is accepted for all characters c. Except for 
  *  \n \t \b \f, the result is c.
  *
  */

{TYPE_ID}   {
  cool_yylval.symbol = idtable.add_string(yytext, yyleng);
  return (TYPEID);
}

{INTEGER}             { 
  int parsed_number = strtol(yytext, &yytext + yyleng, 10);
  cool_yylval.symbol = inttable.add_int(parsed_number);                                        
  return (INT_CONST);
}

{OBJECT_ID}   {
  cool_yylval.symbol = idtable.add_string(yytext, yyleng);
  return (OBJECTID);
}

<TOKEN>\" {
  
  BEGIN(INITIAL); //on end quote, we are out of the string state
  if (str.size() > MAX_STR_CONST)
    {
      cool_yylval.error_msg = "this size of string is not supported";
      str = "";
      return (ERROR);
    }
  else if (!invalid_str)
    {
      cool_yylval.symbol = stringtable.add_string(const_cast<char *>(str.c_str()));
      str = "";
      return (STR_CONST);
    }
 }

\"                                          {
  invalid_str = false;
  BEGIN(TOKEN);
}

<TOKEN>(\\.|\\\n) {
  char unescaped = 0;
  switch (yytext[1]) {
  case 'n': unescaped = '\n'; break;
  case 'b': unescaped = '\b'; break;
  case 'f': unescaped = '\f'; break;
  case 't': unescaped = '\t'; break;
  case '\n': curr_lineno++;
  default: unescaped = yytext[1]; break;
  }
  str += unescaped;
}

<TOKEN>[\0] {
  invalid_str = true;
  cool_yylval.error_msg = "String has a null value";
  return (ERROR);
}

<TOKEN><<EOF>> {
  BEGIN(INITIAL);
  invalid_str = true;
  cool_yylval.error_msg = "File ended before the expected";
  return (ERROR);
 }

<TOKEN>. {
  str += yytext;
 }

<TOKEN>\n  {
  curr_lineno++;
  cool_yylval.error_msg = "String is not valid";
  BEGIN(INITIAL);
  return (ERROR);
 }

<INITIAL,EXPRESSION>{NEWLINE} { 
  curr_lineno++; 
}

{EscapedCharacters} { }

. { cool_yylval.error_msg = yytext; return (ERROR); } 

%%
