%{


%}

MONTH Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec
DATE 0[1-9]|[1-2][0-9]|3[0-1]
H 0[1-9]|1[0-9]|2[0-4]
M 0[0-9]|[1-5][0-9]
S 0[0-9]|[1-5][0-9]
HOSTNAME localhost
KERNEL kernel
TS "["[ ]+[0-9]+"."[0-9]+"]"
WS [ ]
DEVICE .*?:[ ]
MESSAGE . 
%%

^{MONTH}{WS}+{DATE}{WS}+{H}:{M}:{S}{WS}+{HOSTNAME}{WS}+{KERNEL}:{WS}+{TS}{WS}+{DEVICE}{WS}*{MESSAGE}+	{ printf("%s\n",yytext); };
.	;
\n	;

%%

int main(int argc, char* argv[]){

	yyin=fopen(argv[1],"r");
	yylex();
	return 0;
}

