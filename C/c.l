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

%%
^"#"[ \t]*include[ \t]*["][^"\n]+["] {
	printf("%s\n",yytext);
};

^"#"[ \t]*include[ \t]*[<][^>\n]+[>] {
	printf("%s\n",yytext);
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
