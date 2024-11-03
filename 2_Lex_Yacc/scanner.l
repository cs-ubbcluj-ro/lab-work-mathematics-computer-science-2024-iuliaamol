%{
#include <stdio.h>
#include <string.h>

#define MAX_SYMBOLS 100
#define MAX_TOKEN_LENGTH 50

typedef struct {
    char symbol[MAX_TOKEN_LENGTH];
    int position;
} Symbol;

Symbol symbolTable[MAX_SYMBOLS];
int symbolCount = 0;

typedef struct {
    char token[MAX_TOKEN_LENGTH];
    int position;
} PIFEntry;

PIFEntry pif[MAX_SYMBOLS];
int pifIndex = 0;

int addSymbol(char* symbol) {
    for (int i = 0; i < symbolCount; i++) {
        if (strcmp(symbolTable[i].symbol, symbol) == 0) {
            return symbolTable[i].position;
        }
    }
    symbolTable[symbolCount].position = symbolCount + 1;
    strcpy(symbolTable[symbolCount].symbol, symbol);
    symbolCount++;
    return symbolCount;
}

void addToPIF(char* token, int position) {
    strcpy(pif[pifIndex].token, token);
    pif[pifIndex].position = position;
    pifIndex++;
}

%}

DIGIT [0-9]+
IDENTIFIER [a-zA-Z][a-zA-Z0-9_]*

%%
[ \t\n]+                     ;  // Ignore whitespace
"program"                    { addToPIF("program", 0); }  // Do not add "test" to ST
"var"|"IF"|"WHILE"|"begin"|"end"  { addToPIF(yytext, 0); }
"true"|"false"               { int pos = addSymbol(yytext); addToPIF("CONST", pos); }
{DIGIT}                      { int pos = addSymbol(yytext); addToPIF("CONST", pos); }
{IDENTIFIER}                 { int pos = addSymbol(yytext); addToPIF("ID", pos); }
"+"|"-"|"*"|"/"|"="|"<"|">"  { addToPIF(yytext, 0); }
";"|":"|"{"|"}"|"("|")"      { addToPIF(yytext, 0); }

.                            { printf("Lexical error at line %d: Invalid token '%s'\n", yylineno, yytext); }
%%

int yywrap() { return 1; }

int main(int argc, char** argv) {
    if (argc != 2) {
        printf("Usage: %s <source_file>\n", argv[0]);
        return 1;
    }

    FILE* source = fopen(argv[1], "r");
    if (!source) {
        perror("Failed to open file");
        return 1;
    }

    yyin = source;
    yylex();  // Start lexing

    // Print PIF
    printf("\nProgram Internal Form (PIF):\n");
    for (int i = 0; i < pifIndex; i++) {
        printf("Token: %s, Position: %d\n", pif[i].token, pif[i].position);
    }

    // Print Symbol Table
    printf("\nSymbol Table:\n");
    for (int i = 0; i < symbolCount; i++) {
        printf("Symbol: %s, Position: %d\n", symbolTable[i].symbol, symbolTable[i].position);
    }

    fclose(source);
    return 0;
}
