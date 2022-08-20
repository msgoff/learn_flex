%{

char current_repo[256];
long int max_watchers_count;
%}
INTEGER 0|[1-9][0-9]*
%x integer
%%
repos.*?":"	{
	if(strcmp(current_repo,yytext)!=0){	
		printf("%s:%ld",current_repo,max_watchers_count);
		memset(current_repo,'\0',256);
		strcpy(current_repo,yytext);
		max_watchers_count=0;
	}

	BEGIN(integer);	
}
<integer>{INTEGER} {
	long int cmp = 0;
	cmp = atol(yytext);	
	if(cmp>max_watchers_count){
	max_watchers_count = cmp;
	}
	BEGIN(0);
}

%%

int main(int argc, char** argv){


	yylex();
}
