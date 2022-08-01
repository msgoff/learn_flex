
%{
#include <stdio.h>
#include <stdlib.h>

%}

%option header="base_flex.h"
%option prefix="S1_"
%option nounput nomain noyywrap noinput
%option warn stack noyy_top_state

%%
hello { fprintf(stdout,"peng feng");} 
.	;
\n	;
%%

