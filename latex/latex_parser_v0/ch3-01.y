%{
#include <stdio.h>
int sym[26];
#define YYDEBUG 1
%}
%token NAME NUMBER INTEGER FRACTION
%token LEFTBRACE ALPHNUM_RIGHTBRACE RIGHTBRACE

%%


stdout:
      expression {printf("%d\n",$1);}
	|latex_fraction {printf("%s","");};	

expression:	expression '+' INTEGER	{ $$ = $1 + $3; }
	|	expression '-' INTEGER	{ $$ = $1 - $3; }
	|	expression '*' INTEGER	{ $$ = $1 * $3; }
	|	expression '/' INTEGER	{ $$ = $1 / $3; }
	|	INTEGER			{ $$ = $1; };

latex_fraction:
	FRACTION ALPHNUM_RIGHTBRACE LEFTBRACE ALPHNUM_RIGHTBRACE  

%%

extern FILE *yyin;
int main()
{
                yyparse();
		return 0;
}

yyerror(s)
char *s;
{
    fprintf(stderr, "%s\n", s);
}


