%{
#include <stdio.h>
#include "sds.h"
#include "utils.h"
%}
integer [0]|[0]?[1-9]+
FACTORIAL "!"
WS [[:blank:]]

%%
{WS}*{integer}{FACTORIAL}    {
  sds match=sdsnew(yytext);
  sdsrange(match,8,-1);
  sdstrim(match," ");
  printf("%s",match);  
}
. ;
%%
