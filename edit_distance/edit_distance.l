%{
#include "sds.h"
sds X;
sds Y;
int cost;
int arr[3];
int dist[10][10];
int i;
int j;
int ptr[10][10][3];

void distance(sds X, sds Y, int i, int j) {
  sds tmp_x = X;
  sds tmp_y = Y;
  int arr[3] = {dist[i - 1][j] + 1, dist[i][j - 1] + 1, 0};
  int additional_cost = 0;
  if (X[i] != Y[j]) {
    additional_cost = 2;
  }
  arr[2] = dist[i - 1][j - 1] + additional_cost;
  int min = 10000;
  for (int k = 0; k < 3; k++) {
    if (arr[k] < min) {
      min = arr[k];
    }
  }
  dist[i][j] = min;
  if (arr[0] == min) {
    ptr[i][j][0] = -1; // deletion
  }
  if (arr[1] == min) {
    ptr[i][j][1] = -2; // insertion
  }
  if (arr[2] == min) {
    ptr[i][j][2] = -3; // substitution cost 2 if neq otherwise 0
  }
}
%}


%%
[a-zA-Z]+	{	
if (X == NULL) {
  X = sdsnew("#");
  X = sdscat(X, yytext);
} else {
  Y = sdsnew("#");
  Y = sdscat(Y, yytext);
}
}


%%


int main(int argc, char **argv) {
printf("%d",argc);
if (argc == 2) {
  yyin = fopen(argv[1], "r");
  yylex();
}
if (argc == 1) {
  printf("provide a filename, or two strings as arguments");
}
if (argc == 3) {
  X = sdsnew("#");
  X = sdscat(X, argv[1]);
  Y = sdsnew("#");
  Y = sdscat(Y, argv[2]);
} 


int N = sdslen(X);
int M = sdslen(Y);
// partially initalize the array
for (i = 0; i <= N; i++) {
  dist[i][0] = i;
}
for (j = 0; j <= M; j++) {
  dist[0][j] = j;
}
for (i = 1; i <= N; i++) {
  for (j = 1; j <= M; j++) {
    distance(X, Y, i, j);
  }
  printf("\n");
}
for (i = 0; i <= (N - 1); i++) {
  for (j = 0; j <= (M - 1); j++) {
    printf("(%d,%d,%c:%c)=%d  ", i, j, X[i], Y[j], dist[i][j]);
  }
  printf("\n");
}
for (i = 0; i <= (N - 1); i++) {
  for (j = 0; j <= (M - 1); j++) {
    printf("%d:%d", i, j);
    for (int k = 0; k < 3; k++) {
      if (ptr[i][j][k]) {
        printf(":%d", ptr[i][j][k]);
      }
    }
    printf("\n");
  }
}
printf("min_edit_distance:%d\n", dist[N - 1][M - 1]);
return 0;
}
