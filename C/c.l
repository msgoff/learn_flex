%{
#include <string.h>
  struct bufstack {
    struct bufstack *prev;
    YY_BUFFER_STATE bs;
    int lineno;
    char *filename;
    FILE *f;
  } *curbs = 0;

  char *curfilename;
%}
%x COMMENT

%%
"//".*	; 	//comment
"/*"	{ 
	BEGIN(COMMENT);
}
<COMMENT>\n	;
<COMMENT>"*/"	{ 
	BEGIN(0);}
<COMMENT>.	;

^"#"[ \t]*include[ \t]*["][^"\n]+["] {
	printf("%s\n",yytext);
};

^"#"[ \t]*include[ \t]*[<][^>\n]+[>] {
	printf("%s\n",yytext);
}

"auto"			{
	 printf("AUTO "); 
}
"char"			{
	 printf("CHAR "); 
}
"const"			{
	 printf("CONST "); 
}
"continue"		{
	 printf("CONTINUE "); 
}
"default"		{
	 printf("DEFAULT "); 
}
"do"			{
	 printf("DO "); 
}
"double"		{
	 printf("DOUBLE "); 
}
"else"			{
	 printf("ELSE "); 
}
"enum"			{
	 printf("ENUM "); 
}
EXIT_SUCCESS		{
	 printf("RETURN_MESSAGE "); }
 
"for"			{
	 printf("FOR "); 
}
"goto"			{
	 printf("GOTO "); 
}
"if"  			{
	 printf("IF "); } 
 
"int"  			{
	 printf("INT "); } 
 
"long"			{
	 printf("LONG "); 
}
"+="			{
	 printf("ADD_ASSIGN "); 
}
"&="			{
	 printf("AND_ASSIGN "); 
}
"&&"			{
	 printf("AND_OP "); 
}
"--"			{
	 printf("DEC_OP "); 
}
"/="			{
	 printf("DIV_ASSIGN "); 
}
"..."			{
	 printf("ELLIPSIS "); 
}
"=="			{
	 printf("EQ_OP "); 
}
">="			{
	 printf("GE_OP "); 
}
"++"			{
	 printf("INC_OP "); 
}
"<<="			{
	 printf("LEFT_ASSIGN "); 
}
"<<"			{
	 printf("LEFT_OP "); 
}
"<="			{
	 printf("LE_OP "); 
}
"%="			{
	 printf("MOD_ASSIGN "); 
}
"*="			{
	 printf("MUL_ASSIGN "); 
}
"!="			{
	 printf("NE_OP "); 
}
"|="			{
	 printf("OR_ASSIGN "); 
}
"||"			{
	 printf("OR_OP "); 
}
"printf"			{
	 printf("PRINT "); }
	
"->"			{
	 printf("PTR_OP "); 
}
">>="			{
	 printf("RIGHT_ASSIGN "); 
}
">>"			{
	 printf("RIGHT_OP "); 
}
"-="			{
	 printf("SUB_ASSIGN "); 
}
"^="			{
	 printf("XOR_ASSIGN "); 
}
"puts" 			{
	 printf("PUTS "); }
 
"register"		{
	 printf("REGISTER "); 
}
"restrict"		{
	 printf("RESTRICT "); 
}
"return"		{
	 printf("RETURN "); 
}
"short"			{
	 printf("SHORT "); 
}
"signed"		{
	 printf("SIGNED "); 
}
"sizeof"		{
	 printf("SIZEOF "); 
}
"static"		{
	 printf("STATIC "); 
}
"struct"		{
	 printf("STRUCT "); 
}
"switch"		{
	 printf("SWITCH "); 
}
"typedef"		{
	 printf("TYPEDEF "); 
}
"union"			{
	 printf("UNION "); 
}
"unsigned"		{
	 printf("UNSIGNED "); 
}
"void"			{
	 printf("VOID "); }
 
"volatile"		{
	 printf("VOLATILE "); 
}
"while"			{
		 printf("WHILE "); 
}
"malloc"			{
	 printf("MALLOC "); 
}
"#ifdef"			{
	 printf("IFDEF "); 
}
[a-z]+		        {
	 printf("<%s>",yytext); 
}
.		        {
	 printf("<%s>",yytext); 
}

\n	;

%%


int main(int argc, char** argv){
  curfilename = argv[1];
  printf("%s\n",curfilename);
  yyin = fopen(argv[1], "r");
  yylex();

  return 0;
}

