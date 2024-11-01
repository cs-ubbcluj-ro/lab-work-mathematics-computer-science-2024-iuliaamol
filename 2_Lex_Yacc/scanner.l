%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_SYMBOLS 100
#define MAX_TOKEN_LENGTH 50

// Structure (PIF) Program internal Form
typedef struct {
    char token[MAX_TOKEN_LENGTH];
    int tokenType;
} PIFEntry;

PIFEntry pif[MAX_SYMBOLS];
int pifIndex = 0; // Index for PIF entries

// Structure for Symbol Table (ST)
char *symbolTable[MAX_SYMBOLS];
int symbolCount = 0; // Number of symbols in the symbol table

void insertSymbol(char *symbol) {
    // Check for duplicates
    for (int i = 0; i < symbolCount; i++) {
        if (strcmp(symbolTable[i], symbol) == 0) {
            return; // Symbol already exists
        }
    }
    // Add new symbol
    if (symbolCount < MAX_SYMBOLS) {
        symbolTable[symbolCount++] = strdup(symbol); // Duplicate string for storage
    }
}

void printResults() {
    // Print Program Internal Form
    printf("Program Internal Form (PIF):\n");
    for (int i = 0; i < pifIndex; i++) {
        printf("Token: %s, Type: %d\n", pif[i].token, pif[i].tokenType);
    }
    
    // Print Symbol Table
    printf("\nSymbol Table (ST):\n");
    for (int i = 0; i < symbolCount; i++) {
        printf("Symbol: %s\n", symbolTable[i]);
        free(symbolTable[i]); // Free allocated memory
    }
}
%}

%% // Define the rules for the lexer
[ \t\n]+               ; // Skip whitespace

// Keywords
"var"                 { pif[pifIndex++] = (PIFEntry){"var", 1}; }
"int"                 { pif[pifIndex++] = (PIFEntry){"int", 2}; }
"bool"                { pif[pifIndex++] = (PIFEntry){"bool", 3}; }
"IF"                  { pif[pifIndex++] = (PIFEntry){"IF", 4}; }
"WHILE"               { pif[pifIndex++] = (PIFEntry){"WHILE", 5}; }
"read"                { pif[pifIndex++] = (PIFEntry){"read", 6}; }
"write"               { pif[pifIndex++] = (PIFEntry){"write", 7}; }
"begin"               { pif[pifIndex++] = (PIFEntry){"begin", 8}; }
"end"                 { pif[pifIndex++] = (PIFEntry){"end", 9}; }
"program"             { pif[pifIndex++] = (PIFEntry){"program", 10}; }

// Boolean literals
"true"                { pif[pifIndex++] = (PIFEntry){"true", 11}; }
"false"               { pif[pifIndex++] = (PIFEntry){"false", 12}; }

// Numbers
[0-9]+                { pif[pifIndex++] = (PIFEntry){yytext, 13}; }

// Identifiers (variable names)
[a-zA-Z_][a-zA-Z0-9_]* { insertSymbol(yytext); pif[pifIndex++] = (PIFEntry){yytext, 14}; }

// Operators and symbols
"+"                   { pif[pifIndex++] = (PIFEntry){" + ", 15}; }
"-"                   { pif[pifIndex++] = (PIFEntry){" - ", 16}; }
"*"                   { pif[pifIndex++] = (PIFEntry){" * ", 17}; }
"/"                   { pif[pifIndex++] = (PIFEntry){" / ", 18}; }
":="                  { pif[pifIndex++] = (PIFEntry){" :=", 19}; }
";"                   { pif[pifIndex++] = (PIFEntry){" ; ", 20}; }
"{"                   { pif[pifIndex++] = (PIFEntry){" { ", 21}; }
"}"                   { pif[pifIndex++] = (PIFEntry){" } ", 22}; }
"("                   { pif[pifIndex++] = (PIFEntry){" ( ", 23}; }
")"                   { pif[pifIndex++] = (PIFEntry){" ) ", 24}; }
"["                   { pif[pifIndex++] = (PIFEntry){" [ ", 25}; }
"]"                   { pif[pifIndex++] = (PIFEntry){" ] ", 26}; }
">="                  { pif[pifIndex++] = (PIFEntry){" >=", 27}; }
"<="                  { pif[pifIndex++] = (PIFEntry){" <=", 28}; }
"<"                   { pif[pifIndex++] = (PIFEntry){" <", 29}; }
">"                   { pif[pifIndex++] = (PIFEntry){" >", 30}; }
"!="                  { pif[pifIndex++] = (PIFEntry){" !=", 31}; }

// Comments
"//".*                ; // Skip single line comments

// Handle invalid tokens
[^\n]+                { fprintf(stderr, "Lexical error at line %d: Invalid token '%s'\n", yylineno, yytext); }
.                    { fprintf(stderr, "Lexical error at line %d: Invalid character '%s'\n", yylineno, yytext); }

%% 

int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <source_file>\n", argv[0]);
        return EXIT_FAILURE;
    }
    
    // Initialize PIF and ST
    memset(pif, 0, sizeof(pif));
    for (int i = 0; i < MAX_SYMBOLS; i++) {
        symbolTable[i] = NULL; // Initialize symbol table
    }

    // Open the source file
    FILE *source = fopen(argv[1], "r");
    if (!source) {
        perror("Failed to open file");
        return EXIT_FAILURE;
    }

    // Set the input for the lexer
    yyin = source;
    yylex(); // Start scanning

    // Print the results
    printResults();

    // Close the file
    fclose(source);
    return EXIT_SUCCESS;
}
