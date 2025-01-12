%{
#include "parser.tab.h"  
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
%}

%%           
"program"        { return PROGRAM; }
"var"            { return VAR; }
"int"            { return INT; }
"bool"           { return BOOL; }
"IF"             { return IF; }
"WHILE"          { return WHILE; }
"read"           { return READ; }
"write"          { return WRITE; }
"begin"          { return BEGIN_TOKEN; }
"end"            { return END; }
"function"       { return FUNCTION; }


[a-zA-Z][a-zA-Z0-9_]* { yylval.sval = strdup(yytext); return IDENTIFIER; }
[0-9]+               { yylval.ival = atoi(yytext); return NUMBER_CONST; }


"="                  { return EQ; }
"!="                 { return NE; }
"<"                  { return LT; }
"<="                 { return LE; }
">"                  { return GT; }
">="                 { return GE; }
"+"                  { return PLUS; }
"-"                  { return MINUS; }
"*"                  { return MUL; }
"/"                  { return DIV; }
":"                  { return COLON; }
":="                 { return ASSIGN; }


";"                  { return SEMI; }
"{"                  { return LBRACE; }
"}"                  { return RBRACE; }
"["                  { return LBRACKET; }
"]"                  { return RBRACKET; }
"("                  { return LPAREN; }
")"                  { return RPAREN; }


[ \t\n\r]+              ; 

.                    { printf("Unknown character: %c\n", *yytext); }
%%

int yywrap() { return 1; }
