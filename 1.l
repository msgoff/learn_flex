%{
//sds string = sdsfromlonglong(i);

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "sds.h"
#include "sdsalloc.h"

sds *tokens;
int j = 0,count;

void str_sub(char *original_str,char *remove,int remove_len,char *replace_with)
{
		sds bld_str = sdsnew("%s");
		bld_str = sdscat(bld_str,replace_with);
		bld_str = sdscat(bld_str,"%s");

		sds line = sdsnew(yytext);
			tokens = sdssplitlen(line,sdslen(line),remove,2,&count);
			for (j = 1; j < count; j++)
				printf(bld_str,tokens[0], tokens[j]);
				sdsfreesplitres(tokens,count);
} 

%}

%%

string_1\ =\ .*	{ str_sub(yytext,"string_1",8,"_replace_string");	}
string_2\ =\ .*	{
	str_sub(yytext,"string_2",8,"another_string"); 
	printf("do more stuff here");
}

%%

