%{
#include <stdlib.h>
int counter=0;
%}

%s enter_adapter exit_adapter enter_state exit_state enter_mac  exit_mac enter_inet inet exit_inet
%%

^[0-9]+:	{ printf("%s",yytext); BEGIN(enter_adapter); }
<enter_adapter>[0-9a-z]+ { printf("adapter:%s:",yytext); BEGIN(exit_adapter); }
<exit_adapter>:	{ BEGIN(0);   }


state[ ]+ { BEGIN(enter_state); }
<enter_state>[A-Z]+ { printf("state:%s:",yytext);  BEGIN(exit_state); }
<exit_state>[ ]+ { BEGIN(0); }


"link/ether"[ ]+  { BEGIN(enter_mac); }
<enter_mac>([0-9a-f]{2}:){5}[0-9a-f]{2} { printf("mac::%s:",yytext); BEGIN(exit_mac); };
<exit_mac>[ ]+ { BEGIN(0); }

inet[ ]+ { BEGIN(enter_inet); }
<enter_inet>[0-9]{1,3} {
			 printf(":address:"); 
			 char temp[4]; 
                         int test_value=0;
			 counter=1;
			 memset(temp,'\0',4);
			 strcpy(temp,yytext);
			 temp[3]='\0';
			 test_value=atoi(temp);
			 if( (test_value >= 0) && (test_value <= 255)){ 
                            printf("%d",test_value); BEGIN(inet);
			} else { BEGIN(0); }
}
<inet>"."	{ printf("."); }
<inet>[0-9]{1,3} { 
			 char temp[4]; 
                         int test_value=0;
			 counter++;
			 memset(temp,'\0',4);
			 strcpy(temp,yytext);
			 temp[3]='\0';
			 test_value=atoi(temp);
			 if( (test_value >= 0) && (test_value <= 255)){ 
                            printf("%d",test_value); 
                            if(counter==4){ counter=0; printf("\n"); BEGIN(0); } else {
				BEGIN(inet);
			    }
			} else { BEGIN(0); }
}




.	;
\n	;

%%

int main(int argc,char* argv[]){

	yyin=popen("ip addr","r");
	yylex();
	return 0;
}
