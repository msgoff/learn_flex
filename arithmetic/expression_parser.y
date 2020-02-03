%{
#include <stdio.h>
#define YYSTYPE int
%}

%token BINOP INTEGER

%%

expression: INTEGER BINOP INTEGER{ printf("expression is valid\n");};

%%

extern FILE *yyin;

int main()
{
	while(!feof(yyin)) {
		yyparse();
	}
}

yyerror(s)
char *s;
{
    fprintf(stderr, "%s\n", s);
}



