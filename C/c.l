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
LBRACE "{"
RBRACE "}"

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

{LBRACE}	{
	printf("LBRACE ");
}
{RBRACE} 	{
	printf("RBRACE ");
	
}


"break"                 {
    printf("BREAK "); 
}
"case"                  {
    printf("CASE "); 
}
"char"                  {
    printf("CHAR "); 
}
"const"                 {
    printf("CONST "); 
}
"continue"              {
    printf("CONTINUE "); 
}
"default"               {
    printf("DEFAULT "); 
}
"do"                    {
    printf("DO "); 
}
"double"                {
    printf("DOUBLE "); 
}
"else"                  {
    printf("ELSE "); 
}
"enum"                  {
    printf("ENUM "); 
}
"extern"                {
    printf("EXTERN "); 
}
"float"                 {
    printf("FLOAT "); 
}
"goto"                  {
    printf("GOTO "); 
}
"if"                    {
    printf("IF "); 
}
"inline"                {
    printf("INLINE "); 
}
"int"                   {
    printf("INT "); 
}
"long"                  {
    printf("LONG "); 
}
"register"              {
    printf("REGISTER "); 
}
"restrict"              {
    printf("RESTRICT "); 
}
"return"                {
    printf("RETURN "); 
}
"short"                 {
    printf("SHORT "); 
}
"signed"                {
    printf("SIGNED "); 
}
"sizeof"                {
    printf("SIZEOF "); 
}
"static"                {
    printf("STATIC "); 
}
"struct"                {
    printf("STRUCT "); 
}
"switch"                {
    printf("SWITCH "); 
}
"typedef"               {
    printf("TYPEDEF "); 
}
"union"                 {
    printf("UNION "); 
}
"unsigned"              {
    printf("UNSIGNED "); 
}
"void"                  {
    printf("VOID "); 
}
"volatile"              {
    printf("VOLATILE "); 
}
"while"                 {
    printf("WHILE "); 
}
"_Alignas"              {
    printf("ALIGNAS "); 
}
"_Alignof"              {
    printf("ALIGNOF "); 
}
"_Atomic"               {
    printf("ATOMIC "); 
}
"_Bool"                 {
    printf("BOOL "); 
}
"_Complex"              {
    printf("COMPLEX "); 
}
"_Generic"              {
    printf("GENERIC "); 
}
"_Imaginary"            {
    printf("IMAGINARY "); 
}
"_Noreturn"             {printf("NORETURN "); }
"_Static_assert"        {
    printf("STATIC_ASSERT "); 
}
"_Thread_local"         {
    printf("THREAD_LOCAL "); 
}
"("                     {
    printf("LPAREN "); 
}
")"                     {
    printf("RPAREN "); 
}
"."                     {
    printf("DOT "); 
}
"->"                    {
    printf("ARROW "); 
}
"++"                    {
    printf("DBL_PLUS "); 
}
"--"                    {
    printf("DBL_MINUS "); 
}
"&"                     {
    printf("AMPERSAND "); 
}
"*"                     {
    printf("ASTERISK "); 
}
"+"                     {
    printf("PLUS "); 
}
"-"                     {
    printf("MINUS "); 
}
"!"                     {
    printf("EXCLAMATION "); 
}
"/"                     {
    printf("SLASH "); 
}
"%"                     {
    printf("PERCENT "); 
}
"<<"                    {
    printf("LSHIFT "); 
}
">>"                    {
    printf("RSHIFT "); 
}
"<"                     {
    printf("LS "); 
}
">"                     {
    printf("GR "); 
}
"<="                    {
    printf("LE "); 
}
">="                    {
    printf("GE "); 
}
"=="                    {
    printf("EQ "); 
}
"!="                    {
    printf("NE "); 
}
"&&"                    {
    printf("LOG_AND "); 
}
"?"                     {
    printf("QUESTION "); 
}
":"                     {
    printf("COLON "); 
}
";"                     {
    printf("SEMICOLON "); 
}
"..."                   {
    printf("ELLIPSIS "); 
}
"="                     {
    printf("ASSIGN "); 
}
"*="                    {
    printf("MUL_ASSIGN "); 
}
"/="                    {
    printf("DIV_ASSIGN "); 
}
"%="                    {
    printf("MOD_ASSIGN "); 
}
"-="                    {
    printf("SUB_ASSIGN "); 
}
"<<="                   {
    printf("LEFT_ASSIGN "); 
}
">>="                   {
    printf("RIGHT_ASSIGN "); 
}
"&="                    {
    printf("AND_ASSIGN "); 
}
","                     {
    printf("COMMA "); 
}
"auto"			{
	 printf("AUTO "); 
}
EXIT_SUCCESS		{
	 printf("RETURN_MESSAGE "); }
 
"for"			{
	 printf("FOR "); 
}
 
 
"+="			{
	 printf("ADD_ASSIGN "); 
}
"printf"			{
	 printf("PRINT "); }
	
"puts" 			{
	 printf("PUTS "); }
 
"malloc"			{
	 printf("MALLOC "); 
}
"#ifdef"			{
	 printf("IFDEF "); 
}
[a-z]+		        {
	 printf("<%s>",yytext); 
}
[ ]+	{
if (yyleng > 1) {
  printf("WS{%d} ", yyleng);
} else {
  printf("WS ");
}
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

