%{
#include <stdio.h>
#include "sds.h"
#include "utils.h"
%}
integer [0-9]+
factorial factorial
space_maybe [ \t]*


%%
{factorial}{space_maybe}{integer}    {
  sds match=sdsnew(yytext);
  sdsrange(match,8,-1);
  sdstrim(match," ");
  factor(match);}
. ;
%%
