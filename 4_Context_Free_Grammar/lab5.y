%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
void yyerror(const char *s);
extern int yylex(void);
%}

%union {
    int ival;
    char *sval;
    int bval;
}

%token PROGRAM END VAR INT BOOL IF WHILE READ WRITE BEGIN_TOKEN FUNCTION
%token IDENTIFIER NUMBER_CONST
%token EQ NE LT LE GT GE ASSIGN PLUS MINUS MUL DIV COLON SEMI
%token LBRACE RBRACE LBRACKET RBRACKET LPAREN RPAREN

%start program

%%
program:
    PROGRAM IDENTIFIER declist stmtlist END
    {
        printf("Program syntactic correct\n");
        printf("Production rules used: 1\n");
    }
;

declist:
    declaration SEMI
    | declaration SEMI declist
    {
        printf("Production rule used: 2\n");
    }
;

declaration:
    VAR IDENTIFIER COLON type
    {
        printf("Production rule used: 3\n");
    }
;

type:
    INT
    | BOOL
    {
        printf("Production rule used: 4\n");
    }
;

stmtlist:
    stmt SEMI
    | stmt SEMI stmtlist
    {
        printf("Production rule used: 5\n");
    }
;

stmt:
    assignment
    | iostmt
    | ifstmt
    | whilestmt
    | function
    {
        printf("Production rule used: 6\n");
    }
;

assignment:
    IDENTIFIER ASSIGN expression
    {
        printf("Production rule used: 7\n");
    }
;

iostmt:
    READ LPAREN IDENTIFIER RPAREN
    | WRITE LPAREN expression RPAREN
    {
        printf("Production rule used: 8\n");
    }
;

ifstmt:
    IF LPAREN condition RPAREN BEGIN_TOKEN stmtlist END
    {
        printf("Production rule used: 9\n");
    }
;

condition:
    expression relational_op expression
    {
        printf("Production rule used: 10\n");
    }
;

relational_op:
    EQ
    | NE
    | LT
    | LE
    | GT
    | GE
    {
        printf("Production rule used: 11\n");
    }
;

whilestmt:
    WHILE LPAREN condition RPAREN BEGIN_TOKEN stmtlist END
    {
        printf("Production rule used: 12\n");
    }
;

expression:
    term
    | expression PLUS term
    | expression MINUS term
    {
        printf("Production rule used: 13\n");
    }
;

term:
    factor
    | term MUL factor
    | term DIV factor
    {
        printf("Production rule used: 14\n");
    }
;

factor:
    IDENTIFIER
    | NUMBER_CONST
    | LPAREN expression RPAREN
    {
        printf("Production rule used: 15\n");
    }
;

function:
    FUNCTION IDENTIFIER LPAREN IDENTIFIER RPAREN LBRACE stmtlist RBRACE
    {
        printf("Production rule used: 16\n");
    }
;

%%

void yyerror(const char *s) {
    printf("Error: %s\n", s);
}

int main(int argc, char **argv) {
    yyparse();
    return 0;
}
