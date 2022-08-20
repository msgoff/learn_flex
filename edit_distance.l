%{
char str1[128];
char str2[128];
int cost;
//it substitution has cost of 2 then it is called Levenshtein
%}


%%
[a-zA-Z]+	{	
		if (strlen(str1)==0){
			strcpy(str1,yytext);
		} else	{
			strcpy(str2,yytext);
			}
}

%%


int main(int argc, char** argv){
	memset(str1,'\0',128);
	memset(str2,'\0',128);
	yylex();
	printf("%s:%s\n",str1,str2);
	if(strlen(str1)==strlen(str2)){
	for(int i =0;i<strlen(str1);i++){
		if(str1[i]!=str2[i]){
			cost+=2;
		}

	}}
	printf("cost:%d",cost);
	return 0;
}

