
%{
#include <stdio.h>
#include <stdlib.h>
#include "globals.h"
%}

%option header="S2_flex.h"
%option prefix="S2_"
%option nounput nomain noyywrap noinput
%option warn stack noyy_top_state

%x fpath
%%
[a-f0-9]{64} { sds test = sdsnew(yytext); 
 	checksum_s2[array_idx_s2] = test;
	BEGIN(fpath);
} 
<fpath>.* {
		sds test = sdsnew(&yytext[2]);
		filepath_s2[array_idx_s2] = test;
		array_idx_s2++;
		BEGIN(0);
}
.	;
\n	;
%%

