%{
#include <stdio.h>
#include "sds.h"
#include "utils.h"
%}
set_definition_lhs let" "+S" "* 
set_definition_eq =
integer [0-9]+
left_braket "["
right_braket "]"
comma ","
space [ \t]*

%%
{set_definition_lhs}{set_definition_eq}{space}{left_braket}({integer}{comma})+({integer}{right_braket}) {
  sds set_def=sdsnew(yytext);
  printf("%s",yytext);
  dot_file("test_file.dot","w",yytext);
};
. ;
%%
