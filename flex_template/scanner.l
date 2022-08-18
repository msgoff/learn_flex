%{
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include "globals.h"
int line_start;
int line_stop;
int debug;
struct PRINT {
	char * name;
	bool   print_match;	
}data[]={
	//false will show the RLE for the match
	//true  will show the actual match 
	"COLON",false,
	"COMMA",true,
	"COMMENT",true,
	"DIGIT",true,
	"DOLLAR",true,
	"DOT",true,
	"ESCAPESEQUENCE",true,
	"FSLASH",false,
	"GT",true,
	"INTEGER",true,
	"LBRACE",true,
	"LBRACK",true,
	"LOWER",false,
	"LPAREN",true,
	"LT",true,
	"MONTH",true,
	"NL",false,
	"OR",true,
	"POWER",true,
	"RBRACE",true,
	"RBRACK",true,
	"RPAREN",true,
	"SEMICOLON",true,
	"STAR",true,
	"TIMEZONE",true,
	"UNDERSCORE",true,
	"UPPER",true,
	"WS",false,
	"XDIGIT",true,
};

bool search_print_struct(char* state){
	for(int i=0;i<sizeof(data)/sizeof(data[0]);i++){
		if(!strcmp(state,data[i].name)){
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
GT ">"
LT "<"
POWER "^"
OR "|"
STAR "*"
SEMICOLON ";"
ESCAPESEQUENCE \\[btnfr\"\']
DOLLAR "$"
DOT "."
COMMA ","
UNDERSCORE "_"
ID {ALPHA}({ALPHA}|{UNDERSCORE})*
DAY	"Mon"|"Tue"|"Wed"|"Thu"|"Fri"|"Sat"|"Sun"
MONTH	"Jan"|"Feb"|"Mar"|"Apr"|"May"|"Jun"|"Jul"|"Aug"|"Sep"|"Oct"|"Nov"|"Dec"
TIMEZONE	"UT"|"GMT"|"EST"|"EDT"|"CST"|"CDT"|"MST"|"MDT"|"PST"|"PDT"
WS	[[:blank:]]
%x line

%%


{COLON}+	{
	if(yyleng==1){
		if(search_print_struct("COLON")){
			printf("%s",yytext);	
        } else { 
			printf("{COLON}");
		}
	} else {
		if(search_print_struct("COLON")){
			printf("%s",yytext);	
		} else {	
			printf("{COLON}{%d}",yyleng);
		}
	}
}
    

{COMMA}+	{
	if(yyleng==1){
		if(search_print_struct("COMMA")){
			printf("%s",yytext);	
        } else { 
			printf("{COMMA}");
		}
	} else {
		if(search_print_struct("COMMA")){
			printf("%s",yytext);	
		} else {	
			printf("{COMMA}{%d}",yyleng);
		}
	}
}
    

{COMMENT}+	{
	if(yyleng==1){
		if(search_print_struct("COMMENT")){
			printf("%s",yytext);	
        } else { 
			printf("{COMMENT}");
		}
	} else {
		if(search_print_struct("COMMENT")){
			printf("%s",yytext);	
		} else {	
			printf("{COMMENT}{%d}",yyleng);
		}
	}
}
    


{DIGIT}+	{
	if(yyleng==1){
		if(search_print_struct("DIGIT")){
			printf("%s",yytext);	
        } else { 
			printf("{DIGIT}");
		}
	} else {
		if(search_print_struct("DIGIT")){
			printf("%s",yytext);	
		} else {	
			printf("{DIGIT}{%d}",yyleng);
		}
	}
}
    

{DOLLAR}+	{
	if(yyleng==1){
		if(search_print_struct("DOLLAR")){
			printf("%s",yytext);	
        } else { 
			printf("{DOLLAR}");
		}
	} else {
		if(search_print_struct("DOLLAR")){
			printf("%s",yytext);	
		} else {	
			printf("{DOLLAR}{%d}",yyleng);
		}
	}
}
    

{DOT}+	{
	if(yyleng==1){
		if(search_print_struct("DOT")){
			printf("%s",yytext);	
        } else { 
			printf("{DOT}");
		}
	} else {
		if(search_print_struct("DOT")){
			printf("%s",yytext);	
		} else {	
			printf("{DOT}{%d}",yyleng);
		}
	}
}
    

{ESCAPESEQUENCE}+	{
	if(yyleng==1){
		if(search_print_struct("ESCAPESEQUENCE")){
			printf("%s",yytext);	
        } else { 
			printf("{ESCAPESEQUENCE}");
		}
	} else {
		if(search_print_struct("ESCAPESEQUENCE")){
			printf("%s",yytext);	
		} else {	
			printf("{ESCAPESEQUENCE}{%d}",yyleng);
		}
	}
}
    

    

{GT}+	{
	if(yyleng==1){
		if(search_print_struct("GT")){
			printf("%s",yytext);	
        } else { 
			printf("{GT}");
		}
	} else {
		if(search_print_struct("GT")){
			printf("%s",yytext);	
		} else {	
			printf("{GT}{%d}",yyleng);
		}
	}
}
    


{INTEGER}+	{
	if(yyleng==1){
		if(search_print_struct("INTEGER")){
			printf("%s",yytext);	
        } else { 
			printf("{INTEGER}");
		}
	} else {
		if(search_print_struct("INTEGER")){
			printf("%s",yytext);	
		} else {	
			printf("{INTEGER}{%d}",yyleng);
		}
	}
}
    

{LBRACE}+	{
	if(yyleng==1){
		if(search_print_struct("LBRACE")){
			printf("%s",yytext);	
        } else { 
			printf("{LBRACE}");
		}
	} else {
		if(search_print_struct("LBRACE")){
			printf("%s",yytext);	
		} else {	
			printf("{LBRACE}{%d}",yyleng);
		}
	}
}
    

{LBRACK}+	{
	if(yyleng==1){
		if(search_print_struct("LT")){
			printf("%s",yytext);	
        } else { 
			printf("{LBRACK}");
		}
	} else {
		if(search_print_struct("LT")){
			printf("%s",yytext);	
		} else {	
			printf("{LBRACK}{%d}",yyleng);
		}
	}
}
    

{LOWER}+	{
	if(yyleng==1){
		if(search_print_struct("LOWER")){
			printf("%s",yytext);	
        } else { 
			printf("{LOWER}");
		}
	} else {
		if(search_print_struct("LOWER")){
			printf("%s",yytext);	
		} else {	
			printf("{LOWER}{%d}",yyleng);
		}
	}
}
    

{LPAREN}+	{
	if(yyleng==1){
		if(search_print_struct("LPAREN")){
			printf("%s",yytext);	
        } else { 
			printf("{LPAREN}");
		}
	} else {
		if(search_print_struct("LPAREN")){
			printf("%s",yytext);	
		} else {	
			printf("{LPAREN}{%d}",yyleng);
		}
	}
}
    

{LT}+	{
	if(yyleng==1){
		if(search_print_struct("WORD")){
			printf("%s",yytext);	
        } else { 
			printf("{LT}");
		}
	} else {
		if(search_print_struct("WORD")){
			printf("%s",yytext);	
		} else {	
			printf("{LT}{%d}",yyleng);
		}
	}
}
    

    

{NL}+	{
	if(yyleng==1){
		if(search_print_struct("NL")){
			printf("%s",yytext);	
        } else { 
			printf("{NL}\n");
		}
	} else {
		if(search_print_struct("NL")){
			printf("%s",yytext);	
		} else {	
			printf("{NL}{%d}\n",yyleng);
		}
	}
}
    

{OR}+	{
	if(yyleng==1){
		if(search_print_struct("OR")){
			printf("%s",yytext);	
        } else { 
			printf("{OR}");
		}
	} else {
		if(search_print_struct("OR")){
			printf("%s",yytext);	
		} else {	
			printf("{OR}{%d}",yyleng);
		}
	}
}
    

{POWER}+	{
	if(yyleng==1){
		if(search_print_struct("POWER")){
			printf("%s",yytext);	
        } else { 
			printf("{POWER}");
		}
	} else {
		if(search_print_struct("POWER")){
			printf("%s",yytext);	
		} else {	
			printf("{POWER}{%d}",yyleng);
		}
	}
}
    


{RBRACE}+	{
	if(yyleng==1){
		if(search_print_struct("RBRACE")){
			printf("%s",yytext);	
        } else { 
			printf("{RBRACE}");
		}
	} else {
		if(search_print_struct("RBRACE")){
			printf("%s",yytext);	
		} else {	
			printf("{RBRACE}{%d}",yyleng);
		}
	}
}
    

    

{RPAREN}+	{
	if(yyleng==1){
		if(search_print_struct("RPAREN")){
			printf("%s",yytext);	
        } else { 
			printf("{RPAREN}");
		}
	} else {
		if(search_print_struct("RPAREN")){
			printf("%s",yytext);	
		} else {	
			printf("{RPAREN}{%d}",yyleng);
		}
	}
}
    

{SEMICOLON}+	{
	if(yyleng==1){
		if(search_print_struct("SEMICOLON")){
			printf("%s",yytext);	
        } else { 
			printf("{SEMICOLON}");
		}
	} else {
		if(search_print_struct("SEMICOLON")){
			printf("%s",yytext);	
		} else {	
			printf("{SEMICOLON}{%d}",yyleng);
		}
	}
}
    

    

{STAR}+	{
	if(yyleng==1){
		if(search_print_struct("STAR")){
			printf("%s",yytext);	
        } else { 
			printf("{STAR}");
		}
	} else {
		if(search_print_struct("STAR")){
			printf("%s",yytext);	
		} else {	
			printf("{STAR}{%d}",yyleng);
		}
	}
}
    

    

{UNDERSCORE}+	{
	if(yyleng==1){
		if(search_print_struct("UNDERSCORE")){
			printf("%s",yytext);	
        } else { 
			printf("{UNDERSCORE}");
		}
	} else {
		if(search_print_struct("UNDERSCORE")){
			printf("%s",yytext);	
		} else {	
			printf("{UNDERSCORE}{%d}",yyleng);
		}
	}
}
    

{UPPER}+	{
	if(yyleng==1){
		if(search_print_struct("UPPER")){
			printf("%s",yytext);	
        } else { 
			printf("{UPPER}");
		}
	} else {
		if(search_print_struct("UPPER")){
			printf("%s",yytext);	
		} else {	
			printf("{UPPER}{%d}",yyleng);
		}
	}
}
    

{WS}+	{
	if(yyleng==1){
		if(search_print_struct("WS")){
			printf("%s",yytext);	
        } else { 
			printf("{WS}");
		}
	} else {
		if(search_print_struct("WS")){
			printf("%s",yytext);	
		} else {	
			printf("{WS}{%d}",yyleng);
		}
	}
}
    
{FSLASH}+	{
	if(yyleng==1){
		if(search_print_struct("FSLASH")){
			printf("%s",yytext);	
        } else { 
			printf("{FSLASH}");
		}
	} else {
		if(search_print_struct("FSLASH")){
			printf("%s",yytext);	
		} else {	
			printf("{FSLASH}{%d}",yyleng);
		}
	}
}

{XDIGIT}+	{
	if(yyleng==1){
		if(search_print_struct("XDIGIT")){
			printf("%s",yytext);	
        } else { 
			printf("{XDIGIT}");
		}
	} else {
		if(search_print_struct("")){
			printf("%s",yytext);	
		} else {	
			printf("{XDIGIT}{%d}",yyleng);
		}
	}
}



.	;
%%


    
