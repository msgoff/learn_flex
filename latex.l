%{

/*
definitions are sourced from 
CFITSIO Lexical Parser


*/
%}

bit             ([bB][01xX]+)
oct             ([oO][01234567xX]+)
hex             ([hH][0123456789aAbBcCdDeEfFxX]+)
integer         [0-9]+
boolean         (t|f|T|F)
real            ([0-9]*"."[0-9]+)|([0-9]*"."*[0-9]+[eEdD][+-]?[0-9]+)|([0-9]*".")
constant        ("#"[a-zA-Z0-9_]+)|("#""$"[^\n]*"$")
string          ([\"][^\"\n]*[\"])|([\'][^\'\n]*[\'])
variable        ([a-zA-Z_][a-zA-Z0-9_]*)|("$"[^$\n]*"$")
function        [a-zA-Z][a-zA-Z0-9]+"("
intcast         ("(int)"|"(INT)")
fltcast         ("(float)"|"(FLOAT)"|"(double)"|"(DOUBLE)")
power           ("^"|"**")
not             ("!"|".not."|".NOT."|"not."|"NOT.")
or              ("||"|".or."|".OR."|"or."|"OR.")
and             ("&&"|".and."|".AND."|"and."|"AND.")
equal           ("=="|".eq."|".EQ."|"eq."|"EQ.")
not_equal       ("!="|".ne."|".NE."|"ne."|"NE.")
greater         (">"|".gt."|".GT."|"gt."|"GT.")
lesser          ("<"|".lt."|".LT."|"lt."|"LT.")
greater_eq      (">="|"=>"|".ge."|".GE."|"ge."|"GE.")
lesser_eq       ("<="|"=<"|".le."|".LE."|"le."|"LE.")
nl              \n
%%



%%

