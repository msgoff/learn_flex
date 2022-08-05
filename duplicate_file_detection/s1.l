
%{
#include <stdio.h>
#include <stdlib.h>
#include "globals.h"
%}

%option header="S1_flex.h"
%option prefix="S1_"
%option nounput nomain noyywrap noinput
%option warn stack noyy_top_state

%x fpath
%%
[a-f0-9]{64} { sds test = sdsnew(yytext); 
 	checksum_s1[array_idx_s1] = test;
	BEGIN(fpath);
} 
<fpath>.* {
		sds test = sdsnew(&yytext[2]);
		filepath_s1[array_idx_s1] = test;
		array_idx_s1++;
		BEGIN(0);
}
.	;
\n	;
%%

