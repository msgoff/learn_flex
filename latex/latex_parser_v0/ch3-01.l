%{
#include "y.tab.h"
extern int yylval;
#include <stdio.h>
%}

%%
[0-9]+	{ yylval = atoi(yytext); return  INTEGER; }
[ \t]	;		/* ignore white space */
\n	return 0;	/* logical EOF */
\\frac\{  {yylval= *yytext;ECHO;return FRACTION;}
[a-z0-9]+[}] { ECHO;return ALPHNUM_RIGHTBRACE ;}
[{] {ECHO;return LEFTBRACE ; } 
.	return yytext[0];

%%
