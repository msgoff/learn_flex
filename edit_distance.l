%{
#include "sds.h"
sds X;
sds Y;
int cost;
int min_value;
int distance( sds X, sds Y){
	if (sdslen(X) == 0) return sdslen(Y);
	if (sdslen(Y) == 0) return sdslen(X);
}
%}


%%
[a-zA-Z]+	{	
		if(X == NULL){	
			X = sdsnew(yytext);
		} else {
			Y = sdsnew(yytext);
		}	
}


%%


int main(int argc, char** argv){
	yylex();
	int N = sdslen(X);
	int M = sdslen(Y);
	printf("%s",X);
	sdsrange(X,0,sdslen(X)-2);
	printf("%s",X);
	/*for(intd i = 1; i<=N;i++){
	  for(int j = 1;j<=M;j++){
		
	}}
	*/
	return 0;
}

