%{
#include <stdio.h>
#include <stdlib.h>
#include "globals.h"
int line_start;
int line_stop;
%}

%option header="base_flex.h"
%option prefix="S1_"
%option nounput nomain noyywrap noinput
%option warn stack noyy_top_state

%x line
%%
[0-9]+/":"	{ 
	
	resub(yytext,"10","20"); //test case convert 10 to 20
	printf("%s\n",results);
	line_start=atoi(yytext); BEGIN(line); }
<line>":"	;
<line>[ ]+	;
<line>\n	
<line>[0-9]+/":"	{ line_stop=atoi(yytext); }
<line>"<page>"  ;	
<line>"</page>" { printf("head -n %d \"$1\"|tail -n %d\n",line_stop,(line_stop-line_start)); BEGIN(0); }
.	;
\n	;
%%

