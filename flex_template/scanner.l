%{
#include <stdio.h>
#include <stdlib.h>
#include "globals.h"
int line_start;
int line_stop;
int debug;
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
SPACE	[[:space:]]
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
		printf("{COLON}");
	} else {
		printf("{COLON}{%d}",yyleng);
	}
}


{UPPER}+	{
	if(yyleng==1){
		printf("{UPPER}");
	} else {
		printf("{UPPER}{%d}",yyleng);
	}
}

{LOWER}+	{
	if(yyleng==1){
		printf("{LOWER}");
	} else {
		printf("{LOWER}{%d}",yyleng);
	}
}
{OR}+	{
	if(yyleng==1){
		printf("{OR}");
	} else {
		printf("{OR}{%d}",yyleng);
	}
}

{WS}+	{
	if(yyleng==1){
		printf("{WS}");
	} else {
		printf("{WS}{%d}",yyleng);
	}
}

{SEMICOLON}+	{
	if(yyleng==1){
		printf("{SEMICOLON}");
	} else {
		printf("{SEMICOLON}{%d}",yyleng);
	}
}
{INTEGER}+	{
	if(yyleng==1){
		printf("{INTEGER}");
	} else {
		printf("{INTEGER}{%d}",yyleng);
	}
}

{STAR}+	{
	if(yyleng==1){
		printf("{STAR}");
	} else {
		printf("{STAR}{%d}",yyleng);
	}
}
{COMMENT}+	{
	if(yyleng==1){
		printf("{COMMENT}");
	} else {
		printf("{COMMENT}{%d}",yyleng);
	}
}

{LPAREN}+	{
	if(yyleng==1){
		printf("{LPAREN}");
	} else {
		printf("{LPAREN}{%d}",yyleng);
	}
}

{RPAREN}+	{
	if(yyleng==1){
		printf("{RPAREN}");
	} else {
		printf("{RPAREN}{%d}",yyleng);
	}
}

{UNDERSCORE}+	{
	if(yyleng==1){
		printf("{UNDERSCORE}");
	} else {
		printf("{UNDERSCORE}{%d}",yyleng);
	}
}

{GT}+	{
	if(yyleng==1){
		printf("{GT}\n");
	} else {
		printf("{GT}{%d}\n",yyleng);
	}
}
{LT}+	{
	if(yyleng==1){
		printf("{LT}\n");
	} else {
		printf("{LT}{%d}\n",yyleng);
	}
}

{NL}+	{
	if(yyleng==1){
		printf("{NL}\n");
	} else {
		printf("{NL}{%d}\n",yyleng);
	}
}




{COMMA}+   {
            if(yyleng==1){
                    printf("{COMMA}\n");
            } else {
                    printf("{COMMA}{%d}\n",yyleng);
            }
    }


{DAY}+   {
            if(yyleng==1){
                    printf("{DAY}\n");
            } else {
                    printf("{DAY}{%d}\n",yyleng);
            }
    }

{DOLLAR}+   {
            if(yyleng==1){
                    printf("{DOLLAR}\n");
            } else {
                    printf("{DOLLAR}{%d}\n",yyleng);
            }
    }

{DOT}+   {
            if(yyleng==1){
                    printf("{DOT}\n");
            } else {
                    printf("{DOT}{%d}\n",yyleng);
            }
    }

{ESCAPESEQUENCE}+   {
            if(yyleng==1){
                    printf("{ESCAPESEQUENCE}\n");
            } else {
                    printf("{ESCAPESEQUENCE}{%d}\n",yyleng);
            }
    }






{RBRACE}+   {
            if(yyleng==1){
                    printf("{RBRACE}\n");
            } else {
                    printf("{RBRACE}{%d}\n",yyleng);
            }
    }

{RBRACK}+   {
            if(yyleng==1){
                    printf("{RBRACK}\n");
            } else {
                    printf("{RBRACK}{%d}\n",yyleng);
            }
    }

{SPACE}+   {
            if(yyleng==1){
                    printf("{SPACE}\n");
            } else {
                    printf("{SPACE}{%d}\n",yyleng);
            }
    }





{XDIGIT}+   {
            if(yyleng==1){
                    printf("{XDIGIT}\n");
            } else {
                    printf("{XDIGIT}{%d}\n",yyleng);
            }
}

.	;
%%

