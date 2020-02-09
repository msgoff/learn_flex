%{
#include <stdio.h>
unsigned charCount = 0, wordCount = 0, lineCount = 0;
#include "sds.h"
#include <Python.h>

%}
title \\title"{".*"}"
email \\email"{".*"}" 
author \\author"{".*"}"
word [^ \t\n]+
eol  \n

%%
{title} {sds s = sdsnew(yytext);sdsrange(s,7,-2);printf("title,%s\n",s);};
{email} {sds s = sdsnew(yytext);sdsrange(s,7,-2);printf("email,%s\n",s);};
{author} {sds s = sdsnew(yytext);sdsrange(s,8,-2);printf("author,%s\n",s);};
{word}	{ wordCount++; charCount += yyleng; }
{eol}	{ charCount++; lineCount++; }

.	charCount++;

%%
int
main(argc,argv)
int argc;
char **argv;
{
	if (argc > 1) {
		FILE *file;

		file = fopen(argv[1], "r");
		if (!file) {
			fprintf(stderr,"could not open %s\n",argv[1]);
			exit(1);
		}
		yyin = file;
	}
	yylex();
	printf("%d %d %d\n",charCount, wordCount, lineCount);
	return 0;
}

