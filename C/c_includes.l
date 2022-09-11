%{
#include <string.h>
  struct bufstack {
    struct bufstack *prev;
    YY_BUFFER_STATE bs;
    int lineno;
    char *filename;
    FILE *f;
  } *curbs = 0;

  char *curfilename;
%}
%x EXTERN TYPE
LBRACE "{"
RBRACE "}"
WS [ ]
type int|Bool|void|char|double|float|struct|ssize_t|__pid_t|size_t|error_t
%%
[^:]+":"	{ printf("%s",yytext);
	BEGIN(EXTERN);
 }
<EXTERN>extern{WS}+ {
	BEGIN(TYPE);
}

<TYPE>{type}{WS} {
	printf("type:%s",yytext);
}


.	;
\n	;

%%


int main(int argc, char** argv){
  curfilename = argv[1];
  printf("%s\n",curfilename);
  yyin = fopen(argv[1], "r");
  yylex();

  return 0;
}

