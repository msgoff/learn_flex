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
	do 
		{
		yyparse();
	}
		while(!feof(yyin));
}

yyerror(s)
char *s;
{
    fprintf(stderr, "%s\n", s);
}



