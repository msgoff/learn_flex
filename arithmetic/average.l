%{
float count;
float sum;
%}

%%
^[0-9]+	{
	count++;
	sum += atof(yytext);
}
.	;
\n	;

%%


int main(void)
{

	yylex();
	printf("%ld",(long int)(sum/count));
	return 0;
}
