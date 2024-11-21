%{
#include "globals.h"
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int line_start;
int line_stop;
int debug;
char line_buffer[2048];
struct PRINT {
  char *name;
  bool print_match;
} data[] = {
    // false will show the RLE for the match
    // true  will show the actual match
    "PATTERN",  true,        "COLON",      false,    "COMMA",
    false,      "COMMENT",   false,        "DIGIT",  false,
    "DOLLAR",   false,       "DOT",        false,    "ESCAPESEQUENCE",
    false,      "FSLASH",    false,        "GT",     false,
    "INTEGER",  false,       "LBRACE",     false,    "LBRACK",
    false,      "LOWER",     true,         "LPAREN", false,
    "LT",       false,       "MONTH",      false,    "NL",
    false,      "OR",        false,        "POWER",  false,
    "RBRACE",   false,       "RBRACK",     false,    "RPAREN",
    false,      "SEMICOLON", false,        "STAR",   false,
    "TIMEZONE", false,       "UNDERSCORE", false,    "UPPER",
    false,      "WS",        false,        "XDIGIT", false,
    "EQUAL",    false,       "CASES_S",    false,    "CONDITIONAL",
    true,
};

bool search_print_struct(char* state){
	for(int i=0;i<sizeof(data)/sizeof(data[0]);i++){
		if(strcmp(state,data[i].name)==0){
			return data[i].print_match;
		}
	}
}
%}

%option header="base_flex.h"
%option prefix="S1_"
%option nounput nomain noyywrap noinput
%option warn stack noyy_top_state
COMMENT	"///".* 
ALNUM	[[:alnum:]]
ALPHA   [[:alpha:]]
BLANK 	[[:blank:]]
CNTRL	[[:cntrl:]]
DIGIT 	[[:digit:]]
GRAPH	[[:graph:]]
LOWER	[[:lower:]]
UPPER	[[:upper:]] 
PRINT	[[:print:]] 
PUNCT	[[:punct:]]
XDIGIT	[[:xdigit:]]

INTEGER ("+"|"-")?(0|[1-9][0-9]*)
NL	"\n"   
LPAREN "("
RPAREN ")" 
LBRACE "{" 
RBRACE "}"
COLON  ":"
LBRACK "]"
RBRACK "]"
FSLASH "/"
SQUOTE "'" 
GT ">"
LT "<"
POWER "^"
OR "|"
STAR "*"
SEMICOLON ";"
DOLLAR "$"
DOT "."
COMMA ","
UNDERSCORE "_"
ID {ALPHA}({ALPHA}|{UNDERSCORE})*
DAY	"Mon"|"Tue"|"Wed"|"Thu"|"Fri"|"Sat"|"Sun"
MONTH	"Jan"|"Feb"|"Mar"|"Apr"|"May"|"Jun"|"Jul"|"Aug"|"Sep"|"Oct"|"Nov"|"Dec"
TIMEZONE	"UT"|"GMT"|"EST"|"EDT"|"CST"|"CDT"|"MST"|"MDT"|"PST"|"PDT"
WS	[[:blank:]]
EQUAL "="
PERCENT "%"
BACKSLASH "\\"




PATTERN "field"
%x line

%%

{PATTERN}{COLON}{WS}*{SQUOTE}{ALPHA}+{SQUOTE}{WS}*{COMMA}{WS}*{NL}?	{
strcat(line_buffer, yytext);
if (search_print_struct("PATTERN")) {
  printf("%s ", yytext);
  printf("this is \n a new replacement");
} else {
  printf("PATTERN{%d} ", yyleng);
}}

.	printf("%s",yytext);
%%
