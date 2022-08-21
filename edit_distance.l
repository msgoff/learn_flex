%{
#include "sds.h"
sds X;
sds Y;
int cost;
int min_value;
int arr[3];
int dist[10][10];
int i;
int j;
void distance(sds X,sds Y,int i,int j){
	sds tmp_x = X;
	sds tmp_y = Y;
	int arr[3]={dist[i-1][j]+1,dist[i][j-1]+1,0};
	int additional_cost=0;
	if(X[i] != Y[j]){
		additional_cost=2;
	}
	arr[2]=dist[i-1][j-1]+additional_cost;
	int min = 10000;
	for(int k=0;k<3;k++){
		if(arr[k]<min){
			min = arr[k];
		}
	}
	dist[i][j]=min;
}
%}


%%
[a-zA-Z]+	{	
		if(X == NULL){
			X = sdsnew("#");	
			X = sdscat(X,yytext);
		} else {
			Y = sdsnew("#");
			Y = sdscat(Y,yytext);
		}	
}


%%


int main(int argc, char** argv){
	yyin = fopen(argv[1],"r");
	yylex();
	int N = sdslen(X);
	int M = sdslen(Y);
	// partially initalize the array
	for(i=0;i<=N;i++){
		dist[i][0]=i;
	}
	for(j=0;j<=M;j++){
		dist[0][j]=j;
	}
	for(i=1;i<=N;i++){
		for(j=1;j<=M;j++){
			distance(X,Y,i,j);
	}
		printf("\n");
	}
	for(i=0;i<=(M-1);i++){
		for(j=0;j<=(M-1);j++){
			printf("(%d,%d,%c:%c)=%d  ",i,j,X[i],Y[j],dist[i][j]);
	}
		printf("\n");
	}
	printf("min_edit_distance:%d\n",dist[N-1][M-1]);	
	return 0;
}

