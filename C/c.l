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

keywords	"break"|"case"|"continue"|"default"|"do"|"else"|"for"|"goto"|"if"|"return"|"sizeof"|"switch"|"while"
qualifiers	"const"|"inline"|"long"|"register"|"restrict"|"short"|"signed"|"unsigned"|"volatile"


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

^"#"[ \t]*(define|ifndef|if|IF|endif).* {
	printf("%s\n",yytext);
}

{LBRACE}	{
	printf("LBRACE ");
}
{RBRACE} 	{
	printf("RBRACE ");
	
}



'auto'		printf("AUTO ");

'break'		printf("BREAK ");

'case'		printf("CASE ");

'char'		printf("CHAR ");

'const'		printf("CONST ");

'continue'		printf("CONTINUE ");

'default'		printf("DEFAULT ");

'do'		printf("DO ");

'double'		printf("DOUBLE ");

'else'		printf("ELSE ");

'enum'		printf("ENUM ");

'extern'		printf("EXTERN ");

'float'		printf("FLOAT ");

'for'		printf("FOR ");

'goto'		printf("GOTO ");

'if'		printf("IF ");

'inline'		printf("INLINE ");

'int'		printf("INT ");

'long'		printf("LONG ");

'register'		printf("REGISTER ");

'restrict'		printf("RESTRICT ");

'return'		printf("RETURN ");

'short'		printf("SHORT ");


'signed'		printf("SIGNED ");


'sizeof'		printf("SIZEOF ");


'static'		printf("STATIC ");


'struct'		printf("STRUCT ");


'switch'		printf("SWITCH ");


'typedef'		printf("TYPEDEF ");


'union'		printf("UNION ");


'unsigned'		printf("UNSIGNED ");


'void'		printf("VOID ");


'volatile'		printf("VOLATILE ");


'while'		printf("WHILE ");


'_Alignas'		printf("ALIGNAS ");


'_Alignof'		printf("ALIGNOF ");


'_Atomic'		printf("ATOMIC ");


'_Bool'		printf("BOOL ");


'_Complex'		printf("COMPLEX ");


'_Generic'		printf("GENERIC ");


'_Imaginary'		printf("IMAGINARY ");


'_Noreturn'		printf("NORETURN ");


'_Static_assert'		printf("STATICASSERT ");


'_Thread_local'		printf("THREADLOCAL ");




'<'		printf("LESS ");


'<='		printf("LESSEQUAL ");


'>'		printf("GREATER ");


'>='		printf("GREATEREQUAL ");


'<<'		printf("LEFTSHIFT ");


'>>'		printf("RIGHTSHIFT ");




'++'		printf("PLUSPLUS ");


'-'		printf("MINUS ");


'--'		printf("MINUSMINUS ");


'*'		printf("STAR ");


'%'		printf("MOD ");



'^'		printf("CARET ");


'!'		printf("NOT ");


','		printf("COMMA ");


'='		printf("ASSIGN ");




'%='		printf("MODASSIGN ");


'+='		printf("PLUSASSIGN ");


'-='		printf("MINUSASSIGN ");


'<<='		printf("LEFTSHIFTASSIGN ");


'>>='		printf("RIGHTSHIFTASSIGN ");


'&='		printf("ANDASSIGN ");


'^='		printf("XORASSIGN ");


'|='		printf("ORASSIGN ");


'=='		printf("EQUAL ");


'!='		printf("NOTEQUAL ");


'->'		printf("ARROW ");


'.'		printf("DOT ");


'...'		printf("ELLIPSIS ");
        





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
")"                     {
    printf("RPAREN "); 
}
"("                     {
    printf("LPAREN "); 
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
[0-9]	{
	printf("DIGIT ");
}

\n+	{
if (yyleng > 1) {
  printf("NEWLINE{%d}\n ", yyleng);
} else {
  printf("NEWLINE\n ");
}
}
\t	{
	printf("TAB ");
}
[a-zA-Z_]+		        {
	 printf("<%s> ",yytext); 
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

%%


int main(int argc, char** argv){
  curfilename = argv[1];
  printf("%s\n",curfilename);
  yyin = fopen(argv[1], "r");
  yylex();

  return 0;
}

