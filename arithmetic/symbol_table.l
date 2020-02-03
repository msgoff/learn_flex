%{ 
#include "y.tab.h"
#define	LOOKUP 0

int state;
%}

%%
\n { state = LOOKUP; }
^binop { state = BINOP; }
^integer { state = INTEGER; }



[a-zA-Z0-9\!\@\#\$\$\%\%\^\&\*\-\+] {
	if(state != LOOKUP){
		add_word(state,yytext);
	} else {
		switch( lookup_word(yytext)){
		case BINOP:
			return(BINOP);
		case INTEGER: 
			return(INTEGER);
		default:
			printf("%s: not recognized\n",yytext);
			break;}}}

. ;
%%



struct word {
	char *word_name;
	int word_type;
	struct word *next;
};


struct word *word_list;
extern void *malloc();

int
add_word(int type, char *word)
	{
		struct word *wp;
		if(lookup_word(word) != LOOKUP){
			printf("%s alread defined\n",word);
			return 0;
	}
	
	wp = (struct word *) malloc(sizeof(struct word));
	wp->next = word_list;
	wp->word_name = (char *) malloc(strlen(word)+1);
	strcpy(wp->word_name,word);
	wp->word_type = type;
	word_list = wp;
	return 1;
}

int
lookup_word(char *word)
{
	struct word *wp = word_list;
	for(;wp;wp = wp->next){
		if(strcmp(wp->word_name, word) == 0)
			return wp->word_type;
		}
		return LOOKUP;	
}




