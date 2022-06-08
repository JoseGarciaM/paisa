%{
#include <stdio.h>
#include <string.h>
#include "parser.tab.h"
#include <stdlib.h>
int line_number = 1;
%}

%option noyywrap
int \-?[0-9]+
float \-?[0-9]+\.[0-9]+
id [a-zA-Z][a-zA-Z0-9_]{0,30}
whitespace [ \t]+
char_literal '[0-9a-zA-Z!@#$%^&*()_=<>+/,.?;:\{\}\[\]\"\\-]'
string_literal \"[a-zA-Z!@#$%^&*()_=<>+/,.?;:\{\}\[\]\\-]*\"

%%
"inicio" {return(INICIO);}
"final" {return(FINAL);}

"si" {return(SELECTION_IF);}
"aparte" {return(SELECTION_ELSE);}
"para" {return(LOOP_FOR);}
"hacer" {return(LOOP_DOWHILE);}
"mientras" {return(LOOP_WHILE);}

";" {return(SEMI);}
"," {return(COMMA);}
"." {return(DOT);}
"(" {return(LPAREN);}
")" {return(RPAREN);}
"[" {return(LBRACKET);}
"]" {return(RBRACKET);}
"{" {return(LBRACE);}
"}" {return(RBRACE);}


"suma" {return(ADDITION);}
"resta" {return(SUBTRACTION);}
"multiplica" {return(MULTIPLICATION);}
"divide" {return(DIVIDE);}
"%" {return(MOD);}

"tiene" {return(ASSIGNMENT_OPERATOR);}

"igual" {return(EQUALS);}
"distinto" {return(NOT_EQUALS);}
"menorque" {return(LESS_THAN);}
"mayorque" {return(GREATER_THAN);}
"menorigualque" {return(LESS_EQUAL);}
"mayorigualque" {return(GREATER_EQUAL);}

"and" {return(AND);}
"or" {return(OR);}
"not" {return(NOT);}

"entero" {return(INT);}
"flotante" {return(FLOAT);}
"char" {return(CHAR);}
"vacio" {return(VACIO);}
"struct" {return(STRUCT);}
"func" {return(FUNC);}
"devuelve" {return(RETURN);}
"bool" {return(BOOL);}

"verdadero" {return(BOOLVAL);}
"falso" {return(BOOLVAL);}
"enblanco" {return(NULLVAL);}

"lee"			{return(GETS);}
"imprime"			{return(PUTS);}
"imprimeaparte" 	{return(PUTSLN);}

{id} {yylval.sval = (char*) strdup(yytext); return(ID);}
{float} {return(FLOATNUM);}
{int} {return(INTNUM);}
"\n" {line_number++;}
{whitespace} {/*IGNORE*/}
{char_literal} {return(CHARLITERAL);}
{string_literal} {return(STRINGLITERAL);}

. {printf("LEXICAL ERROR: Unrecognized: %s (line %d)\n", yytext, line_number);}

%%
