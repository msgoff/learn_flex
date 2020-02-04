/*
Hermes flex lexicon version 0.9.12, 2006-11-12
author Romeo Anghelache http://romeo.roua.org
released under GNU GPL
*/


%{
#ifdef WIN32
#include <windows.h>
#pragma warning(disable : 4996)
#define _CRT_SECURE_NO_DEPRECATE
#endif
#include <stdio.h>
#include <string.h>
#include "hermes.tab.h"
extern void selectFont(unsigned long fnum);
int len=0;
int maxfonts=0;
int width=0;
int dropN=0;
int spacing=0;//set if spacing modifier, unset if combining
unsigned long inputlines=0;
extern int BigEndian;
extern int fakesp;
extern int inhibitspace;
extern int mathmode;
extern int mathBox;
extern int infhp;
extern int pHints;
extern int inTable;
extern int noDVIY;
char lastToken[512];
void track(char* tokenString);
extern int maxFontNr;
extern int DEBUG;
const int SPACEWIDTH=50000;
enum dimension {h,v,w,x,y,z,r} postype;
struct position{
	int h;
	int v;
	int w;
	int x;
	int y;
	int z;
	struct position * next;
}cur_pos={0,0,0,0,0,0,NULL},* stack=NULL;
void push();
void pop();
void clearStack();
void init_pos();
%}



ANY		(.|\n)

S		[ ]

EndLine		{S}endline{S}

/****begin ZBL specifics****/
BMATHICS	{S}mathics:{S}
EMATHICS {S}:mathics{S}
BICSIDX	{S}icsidx:{S}
EICSIDX {S}:icsidx{S}
BICSDESC	{S}icsdesc:{S}
EICSDESC {S}:icsdesc{S}
BMATVERW	{S}matverw:{S}
EMATVERW {S}:matverw{S}
BMATHICSSUB	{S}mathicssub:{S}
EMATHICSSUB {S}:mathicssub{S}

BPUBLISHED	{S}published:{S}
EPUBLISHED {S}:published{S}
BENTRY	{S}entry:{S}
EENTRY	{S}:entry{S}
/****end of ZBL specifics****/

/***AMS specific***/
BEQTAG	{S}eqtag:{S}
EEQTAG	{S}:eqtag{S}
BBINOM	{S}binom:{S}
EBINOM	{S}:binom{S}
BBINOMUP {S}binomup:{S}
EBINOMUP {S}:binomup{S}
BBINOMDOWN {S}binomdown:{S}
EBINOMDOWN {S}:binomdown{S}

/***end of AMS specific***/

BMBOX	{S}mbox:{S}
EMBOX	{S}:mbox{S}
BFBOX	{S}fbox:{S}
EFBOX	{S}:fbox{S}
BTBOX	{S}tbox:{S}
ETBOX {S}:tbox{S}



EQNO		{S}eqno{S}
LEQNO		{S}leqno{S}
REQNO		{S}reqno{S}


BSP			{S}sp:{S}
ESP			{S}:sp{S}
SBCHAR		{S}sbchar{S}
BSB			{S}sb:{S}
ESB			{S}:sb{S}
LT	 		{S}lt{S}
GT 			{S}gt{S}

ARCCOS			{S}arccos{S}
ARCSIN			{S}arcsin{S}
ARCTAN			{S}arctan{S}
ARG				{S}arg{S}
COS				{S}cos{S}
COSH			{S}cosh{S}
COT				{S}cot{S}
COTH			{S}coth{S}
CSC				{S}csc{S}
DEG				{S}deg{S}
DET				{S}det{S}
DIM				{S}dim{S}
EXP				{S}exp{S}
GCD				{S}gcd{S}
HOM				{S}hom{S}
INF				{S}inf{S}
KER				{S}ker{S}
LG				{S}lg{S}
LIM				{S}lim{S}
LIMINF			{S}liminf{S}
LIMSUP			{S}limsup{S}
LN				{S}ln{S}
LOG				{S}log{S}
MAX				{S}max{S}
MIN				{S}min{S}
PR				{S}Pr{S}
SEC				{S}sec{S}
SIN				{S}sin{S}
SINH			{S}sinh{S}
SUP				{S}sup{S}
TAN				{S}tan{S}
TANH			{S}tanh{S}

/**** LaTeX and misc ***/

BRoot		{S}Root:{S}
Root		{S}Root{S}
ERoot		{S}:Root{S}

/****** MathML content TeX macros ******/
/* arbitrary functions */
Bfunc		{S}func:{S}
Bfarg		{S}farg:{S}
Efarg		{S}:farg{S}
Efunc		{S}:func{S}

/* basic elements */
BCompose	{S}Compose:{S}
Compose		{S}Compose{S}
ECompose	{S}:Compose{S}
BInverse	{S}Inverse:{S}
Inverse		{S}Inverse{S}
EInverse	{S}:Inverse{S}
Ident		{S}Ident{S}
BDomain		{S}Domain:{S}
EDomain		{S}:Domain{S}
BCodomain		{S}Codomain:{S}
ECodomain		{S}:Codomain{S}
BImage		{S}Image:{S}
EImage		{S}:Image{S}

/*	arithmetic, algebra, logic	*/

BQuotient	{S}Quotient:{S}
Quotient	{S}Quotient{S}
EQuotient	{S}:Quotient{S}

BMaxl		{S}Maxl:{S}
EMaxl		{S}:Maxl{S}
BMaxc		{S}Maxc:{S}
EMaxc		{S}:Maxc{S}
BCond		{S}Cond:{S}
ECond		{S}:Cond{S}
BVar		{S}Var:{S}
EVar		{S}:Var{S}
BExpr		{S}Expr:{S}
EExpr		{S}:Expr{S}
BMinl		{S}Minl:{S}
BMinc		{S}Minc:{S}
EMinl		{S}:Minl{S}
EMinc		{S}:Minc{S}

BPlus		{S}Plus:{S}
Plus		{S}Plus{S}
EPlus		{S}:Plus{S}
BMinus		{S}Minus:{S}
Minus		{S}Minus{S}
EMinus		{S}:Minus{S}
BTimes		{S}Times:{S}
Times		{S}Times{S}
ETimes		{S}:Times{S}
BPower		{S}Power:{S}
Power		{S}Power{S}
EPower		{S}:Power{S}

BFactorial	{S}Factorial:{S}
Factorial	{S}Factorial{S}
EFactorial	{S}:Factorial{S}


BRem		{S}Mod:{S}
Rem			{S}Mod{S}
ERem		{S}:Mod{S}
REM			{S}mod{S}


BGcd			{S}Gcd:{S}
EGcd			{S}:Gcd{S}
BLcm			{S}Lcm:{S}
ELcm			{S}:Lcm{S}
LCM				{S}lcm{S}
BRe			{S}Re:{S}
ERe			{S}:Re{S}
BIm			{S}Im:{S}
EIm			{S}:Im{S}

AND			{S}and{S}
BLand		{S}Land:{S}
Land		{S}Land{S}
ELand		{S}:Land{S}

OR			{S}or{S}
BLor		{S}Lor:{S}
Lor			{S}Lor{S}
ELor		{S}:Lor{S}

XOR			{S}xor{S}
BXor		{S}Xor:{S}
Xor			{S}Xor{S}
EXor		{S}:Xor{S}

BNot		{S}Not:{S}
ENot		{S}:Not{S}

BImplies	{S}Implies:{S}
Implies		{S}Implies{S}
EImplies	{S}:Implies{S}

BForall		{S}Forall:{S}
EForall		{S}:Forall{S}
BExists		{S}Exists:{S}
EExists		{S}:Exists{S}
BAssert		{S}Assert:{S}
EAssert		{S}:Assert{S}


Babs		{S}abs:{S}
Eabs		{S}:abs{S}

Bconjugate	{S}conjugate:{S}
Econjugate	{S}:conjugate{S}
BArg		{S}Arg:{S}
EArg		{S}:Arg{S}

Bfloor		{S}floor:{S}
Efloor		{S}:floor{S}
Bceil		{S}ceil:{S}
Eceil		{S}:ceil{S}

BFactor		{S}Factor:{S}
Factor		{S}Factor{S}
EFactor		{S}:Factor{S}

/*	relations	*/

BEqual		{S}Eq:{S}
Equal			{S}Eq{S}
EEqual		{S}:Eq{S}
BNequal		{S}Neq:{S}
Nequal		{S}Neq{S}
ENequal		{S}:Neq{S}
BLequal		{S}Leq:{S}
Lequal		{S}Leq{S}
ELequal		{S}:Leq{S}
BGequal		{S}Geq:{S}
Gequal		{S}Geq{S}
EGequal		{S}:Geq{S}
BEquiv		{S}Equiv:{S}
Equiv		{S}Equiv{S}
EEquiv		{S}:Equiv{S}
BApprox		{S}Approx:{S}
Approx		{S}Approx{S}
EApprox		{S}:Approx{S}
BGthan		{S}Gt:{S}
Gthan		{S}Gt{S}
EGthan		{S}:Gt{S}
BLthan		{S}Lt:{S}
Lthan		{S}Lt{S}
ELthan		{S}:Lt{S}

/*	calculus and vector calculus	*/
BInt		{S}Int:{S}
EInt		{S}:Int{S}
BIntll		{S}Intll:{S}
EIntll		{S}:Intll{S}
BIntul		{S}Intul:{S}
EIntul		{S}:Intul{S}
BIntarg		{S}Intarg:{S}
EIntarg		{S}:Intarg{S}
BIntbe		{S}Intbe:{S}
EIntbe		{S}:Intbe{S}


BDiff		{S}Diff:{S}
EDiff		{S}:Diff{S}
BDiffbe		{S}Diffbe:{S}
EDiffbe		{S}:Diffbe{S}
BDiffdeg		{S}Diffdeg:{S}
EDiffdeg		{S}:Diffdeg{S}
BDiffarg		{S}Diffarg:{S}
EDiffarg		{S}:Diffarg{S}

BDivt			{S}Divt:{S}
BDivs			{S}Divs:{S}
EDiv			{S}:Div{S}
BGradt		{S}Gradt:{S}
BGrads		{S}Grads:{S}
EGrad		{S}:Grad{S}
BCurlt		{S}Curlt:{S}
BCurls		{S}Curls:{S}
ECurl		{S}:Curl{S}
BLaplacian	{S}Laplacian:{S}
ELaplacian	{S}:Laplacian{S}

/*	theory of sets	*/
BSubset		{S}Subset:{S}
Subset		{S}Subset{S}
ESubset		{S}:Subset{S}
BNotsubset		{S}Notsubset:{S}
Notsubset		{S}Notsubset{S}
ENotsubset		{S}:Notsubset{S}

BSubseteq		{S}Subseteq:{S}
Subseteq		{S}Subseteq{S}
ESubseteq		{S}:Subseteq{S}
BNotsubseteq		{S}Notsubseteq:{S}
Notsubseteq		{S}Notsubseteq{S}
ENotsubseteq		{S}:Notsubseteq{S}

BSetl		{S}Setl:{S}
ESetl		{S}:Setl{S}
BSetc		{S}Setc:{S}
ESetc		{S}:Setc{S}

BListl		{S}Listl:{S}
EListl		{S}:Listl{S}
BListc		{S}Listc:{S}
EListc		{S}:Listc{S}

BUnion		{S}Union:{S}
Union		{S}Union{S}
EUnion		{S}:Union{S}

BIntersect		{S}Intersect:{S}
Intersect		{S}Intersect{S}
EIntersect		{S}:Intersect{S}

BIn		{S}In:{S}
In		{S}In{S}
EIn		{S}:In{S}

BNotin		{S}NotIn:{S}
Notin		{S}NotIn{S}
ENotin		{S}:NotIn{S}

BSetdiff		{S}Setdiff:{S}
Setdiff		{S}Setdiff{S}
ESetdiff		{S}:Setdiff{S}

BCard		{S}Card:{S}
ECard		{S}:Card{S}
BCartesian		{S}Cartesian:{S}
Cartesian		{S}Cartesian{S}
ECartesian		{S}:Cartesian{S}

/* sequences and series */
BSum		{S}Sum:{S}
ESum		{S}:Sum{S}
BSumll		{S}Sumll:{S}
ESumll		{S}:Sumll{S}
BSumul		{S}Sumul:{S}
ESumul		{S}:Sumul{S}
BSumarg		{S}Sumarg:{S}
ESumarg		{S}:Sumarg{S}

BProd		{S}Prod:{S}
EProd		{S}:Prod{S}
BProdll		{S}Prodll:{S}
EProdll		{S}:Prodll{S}
BProdul		{S}Produl:{S}
EProdul		{S}:Produl{S}
BProdarg		{S}Prodarg:{S}
EProdarg		{S}:Prodarg{S}

BLimit		{S}Limit:{S}
ELimit		{S}:Limit{S}
BLimitarg		{S}Limitarg:{S}
ELimitarg		{S}:Limitarg{S}

BTendsto		{S}Tendsto:{S}
Tendsto		{S}Tendsto{S}
ETendsto		{S}:Tendsto{S}

/* elementary functions */
BSin		{S}Sin:{S}
ESin		{S}:Sin{S}
BCos		{S}Cos:{S}
ECos		{S}:Cos{S}
BTan		{S}Tan:{S}
ETan		{S}:Tan{S}
BSec		{S}Sec:{S}
ESec		{S}:Sec{S}
BCsc		{S}Csc:{S}
ECsc		{S}:Csc{S}
BCot		{S}Cot:{S}
ECot		{S}:Cot{S}
BSinh	{S}Sinh:{S}
ESinh	{S}:Sinh{S}
BCosh	{S}Cosh:{S}
ECosh	{S}:Cosh{S}
BTanh	{S}Tanh:{S}
ETanh	{S}:Tanh{S}
BSech	{S}Sech:{S}
Sech	{S}Sech{S}
ESech	{S}:Sech{S}
BCsch	{S}Csch:{S}
Csch	{S}Csch{S}
ECsch	{S}:Csch{S}
BCoth	{S}Coth:{S}
ECoth	{S}:Coth{S}

BArccos 	{S}Arccos:{S}
EArccos 	{S}:Arccos{S}
BArccosh 	{S}Arccosh:{S}
Arccosh		{S}Arccosh{S}
EArccosh 	{S}:Arccosh{S}
BArcsin 	{S}Arcsin:{S}
EArcsin		{S}:Arcsin{S}



BArccot		{S}Arccot:{S}
Arccot		{S}Arccot{S}
EArccot		{S}:Arccot{S}
BArccoth	{S}Arccoth:{S}
Arccoth		{S}Arccoth{S}
EArccoth	{S}:Arccoth{S}

BArccsc		{S}Arccsc:{S}
Arccsc		{S}Arccsc{S}
EArccsc		{S}:Arccsc{S}
BArccsch	{S}Arccsch:{S}
Arccsch		{S}Arccsch{S}
EArccsch	{S}:Arccsch{S}

BArcsec		{S}Arcsec:{S}
Arcsec		{S}Arcsec{S}
EArcsec		{S}:Arcsec{S}
BArcsech		{S}Arcsech:{S}
Arcsech		{S}Arcsech{S}
EArcsech		{S}:Arcsech{S}
BArcsinh		{S}Arcsinh:{S}
Arcsinh		{S}Arcsinh{S}
EArcsinh		{S}:Arcsinh{S}
BArctan		{S}Arctan:{S}
EArctan		{S}:Arctan{S}
BArctanh		{S}Arctanh:{S}
Arctanh		{S}Arctanh{S}
EArctanh		{S}:Arctanh{S}

BExp		{S}Exp:{S}
EExp		{S}:Exp{S}
BLog		{S}Log:{S}
ELog		{S}:Log{S}
BLg			{S}Lg:{S}
ELg			{S}:Lg{S}
BLn			{S}Ln:{S}
ELn			{S}:Ln{S}

/*	statistics	*/

BMean		{S}Mean:{S}
EMean		{S}:Mean{S}
BSDev		{S}Sdev:{S}
ESDev		{S}:Sdev{S}
BVariance		{S}Variance:{S}
Variance		{S}Variance{S}
EVariance		{S}:Variance{S}
BMedian		{S}Median:{S}
Median		{S}Median{S}
EMedian		{S}:Median{S}
BMode		{S}Mode:{S}
Mode		{S}Mode{S}
EMode		{S}:Mode{S}

BMoment		{S}Moment:{S}
EMoment		{S}:Moment{S}
BMomentDeg	{S}Momentdeg:{S}
EMomentDeg	{S}:Momentdeg{S}
BMomentArg	{S}Momentarg:{S}
EMomentArg	{S}:Momentarg{S}
BMomenta	{S}Momenta:{S}
EMomenta	{S}:Momenta{S}
BMabout		{S}Mabout:{S}
EMabout		{S}:Mabout{S}

/*	linear algebra	*/
BVector		{S}Vector:{S}
EVector		{S}:Vector{S}
BMatrix		{S}Matrix:{S}
EMatrix		{S}:Matrix{S}

BTranspose	{S}Transpose:{S}
ETranspose	{S}:Transpose{S}
BDet		{S}Det:{S}
EDet		{S}:Det{S}
BSelector	{S}Selector:{S}
ESelector	{S}:Selector{S}
SelectorMatrix	{S}SelectorMatrix{S}

BVectorProduct	{S}VectorProduct:{S}
VectorProduct	 {S}VectorProduct{S}
EVectorProduct	{S}:VectorProduct{S}

BScalarProduct	{S}ScalarProduct:{S}
ScalarProduct	{S}ScalarProduct{S}
EScalarProduct	{S}:ScalarProduct{S}

BOuterProduct	{S}OuterProduct:{S}
OuterProduct	{S}OuterProduct{S}
EOuterProduct	{S}:OuterProduct{S}


/* constants and symbols */
Integers		{S}Integers{S}
Naturals		{S}Naturals{S}
Rationals		{S}Rationals{S}
Reals			{S}Reals{S}
Complexes		{S}Complexes{S}
Primes			{S}Primes{S}

ExponentialE	{S}ExpE{S}
ImaginaryI		{S}ImI{S}
NotANumber		{S}NaN{S}
True			{S}True{S}
False			{S}False{S}
Emptyset		{S}Emptyset{S}
PiCst			{S}PiCst{S}
EulerGamma		{S}EulerGamma{S}
Infty			{S}Infty{S}

/*		extras	*/
Trace			{S}Trace{S}

/*		DVI commands	*/

SET1		\x80
SET2		\x81
SET3		\x82
SET4		\x83

SET_RULE	\x84

PUT1		\x85
PUT2		\x86
PUT3		\x87
PUT4		\x88

PUT_RULE	\x89

NOP		\x8A
BOP		\x8B
EOP		\x8C
PUSH		\x8D
POP		\x8E

RIGHT1		\x8F
RIGHT2		\x90
RIGHT3		\x91
RIGHT4		\x92

W0		\x93
W1		\x94
W2		\x95
W3		\x96
W4		\x97

X0		\x98
X1		\x99
X2		\x9A
X3		\x9B
X4		\x9C

DOWN1		\x9D
DOWN2		\x9E
DOWN3		\x9F
DOWN4		\xA0

Y0		\xA1
Y1		\xA2
Y2		\xA3
Y3		\xA4
Y4		\xA5

Z0		\xA6
Z1		\xA7
Z2		\xA8
Z3		\xA9
Z4		\xAA

FNT_NUM		[\xAB-\xEA]

FNT1		\xEB
FNT2		\xEC
FNT3		\xED
FNT4		\xEE

XXX1		\xEF
XXX2		\xF0
XXX3		\xF1
XXX4		\xF2

FNT_DEF1	\xF3
FNT_DEF2	\xF4
FNT_DEF3	\xF5
FNT_DEF4	\xF6

PRE		\xF7
POST		\xF8
POST_POST	\xF9

%x arg_signed1
%x arg_signed2
%x arg_signed3
%x arg_signed4

%x arg_signed_v

%x arg_unsigned
%x arg_set

%x arg_fnum_k1
%x arg_fnum_k2
%x arg_fnum_k3
%x arg_fnum_k4

%x arg_fdef_k1
%x arg_fdef_k2
%x arg_fdef_k3
%x arg_fdef_k4

%x arg_fdef_csd
%x arg_fdef_a
%x arg_fdef_l
%x arg_fdef_s

%x argpre
%x argpre_k

%x argk1
%x argk2
%x argk3
%x argk4

%x ignore
%x ignoreN

%x xxxtoken
%option nounput

%%

{SET1}		{len=1;BEGIN(arg_set);track("SET1");return SET;}
{SET2}		{len=2;BEGIN(arg_set);}
{SET3}		{len=3;BEGIN(arg_set);}
{SET4}		{len=4;BEGIN(arg_set);}

{SET_RULE}	{len=8;BEGIN(ignoreN);}

{PUT1}		{len=1;BEGIN(ignoreN);}
{PUT2}		{len=2;BEGIN(ignoreN);}
{PUT3}		{len=3;BEGIN(ignoreN);}
{PUT4}		{len=4;BEGIN(ignoreN);}

{PUT_RULE}	{len=8;BEGIN(ignoreN);}

{NOP}		{}
{BOP}		{init_pos();len=44;BEGIN(ignoreN);}
{EOP}		{if(stack){perror("the stack should be empty but it is not");exit(EXIT_FAILURE);}}
{PUSH}		{push();}
{POP}		{pop();}


{RIGHT1}	{postype=r;BEGIN(arg_signed1);}
{RIGHT2}	{postype=r;BEGIN(arg_signed2);}
{RIGHT3}	{postype=r;BEGIN(arg_signed3);}
{RIGHT4}	{postype=r;BEGIN(arg_signed4);}

{W0}		{cur_pos.h+=cur_pos.w; 
						if(cur_pos.w>SPACEWIDTH) if(!inhibitspace) fakesp=0;
						inhibitspace=0;
			}
{W1}		{postype=w;BEGIN(arg_signed1);}
{W2}		{postype=w;BEGIN(arg_signed2);}
{W3}		{postype=w;BEGIN(arg_signed3);}
{W4}		{postype=w;BEGIN(arg_signed4);}

{X0}		{cur_pos.h+=cur_pos.x;if (cur_pos.x>SPACEWIDTH) fakesp=0;}
{X1}		{postype=x;BEGIN(arg_signed1);}
{X2}		{postype=x;BEGIN(arg_signed2);}
{X3}		{postype=x;BEGIN(arg_signed3);}
{X4}		{postype=x;BEGIN(arg_signed4);}

{DOWN1}		{postype=v;BEGIN(arg_signed1);}
{DOWN2}		{postype=v;BEGIN(arg_signed2);}
{DOWN3}		{postype=v;BEGIN(arg_signed3);}
{DOWN4}		{postype=v;BEGIN(arg_signed4);}

{Y0}		{cur_pos.v+=cur_pos.y;if (cur_pos.y>SPACEWIDTH && !mathmode && !noDVIY) {track("DVIY(y0)");return DVIY;}}
{Y1}		{postype=y;BEGIN(arg_signed1);}
{Y2}		{postype=y;BEGIN(arg_signed2);}
{Y3}		{postype=y;BEGIN(arg_signed3);}
{Y4}		{postype=y;BEGIN(arg_signed4);}

{Z0}		{cur_pos.v+=cur_pos.z;if (cur_pos.y>SPACEWIDTH && !mathmode && !noDVIY) {track("DVIY(z0)");return DVIY;}}
{Z1}		{postype=z;BEGIN(arg_signed1);}
{Z2}		{postype=z;BEGIN(arg_signed2);}
{Z3}		{postype=z;BEGIN(arg_signed3);}
{Z4}		{postype=z;BEGIN(arg_signed4);}

{FNT_NUM}	{
			unsigned long test=(unsigned char)(*yytext)-171;
			selectFont(test);
			if (!mathmode && pHints) {track("FontChange");return FontChange;};
		}

{FNT1}		{BEGIN(arg_fnum_k1);}
{FNT2}		{BEGIN(arg_fnum_k2);}
{FNT3}		{BEGIN(arg_fnum_k3);}
{FNT4}		{BEGIN(arg_fnum_k4);}

<arg_fnum_k1>{ANY}		{
			unsigned long fontn=(unsigned char)(*yytext);
			selectFont(fontn);
			BEGIN(0);
			}

<arg_fnum_k2>{ANY}{2}		{
			unsigned long fontn;
			fontn=(yytext[0]<<8)+yytext[1];
			selectFont(fontn);
			BEGIN(0);
			}

<arg_fnum_k3>{ANY}{3}		{
			unsigned long fontn;
			fontn=(yytext[0]<<16)+(yytext[1]<<8)+yytext[2];
			selectFont(fontn);
			BEGIN(0);
			}

<arg_fnum_k4>{ANY}{4}		{
			unsigned long fontn=(int)(*yytext);
			fontn=(yytext[0]<<24)+(yytext[1]<<16)+(yytext[2]<<8)+yytext[3];
			selectFont(fontn);
			len=12;BEGIN(arg_fdef_csd);
			}

{XXX1}		{BEGIN(argk1);}
{XXX2}		{BEGIN(argk2);}
{XXX3}		{BEGIN(argk3);}
{XXX4}		{BEGIN(argk4);}

{FNT_DEF1}	{BEGIN(arg_fdef_k1);}
{FNT_DEF2}	{BEGIN(arg_fdef_k2);}
{FNT_DEF3}	{BEGIN(arg_fdef_k3);}
{FNT_DEF4}	{BEGIN(arg_fdef_k4);}

{PRE}			{BEGIN(argpre);}
{POST}		{BEGIN(ignore);return END;}
{POST_POST}	{}


<arg_signed1>{ANY}	{
				int temp=(char)(*yytext);
				int n=temp;
				BEGIN(0);
				switch(postype){
					case h:
						cur_pos.h+=n;
						break;
					case v:
						cur_pos.v+=n;
						break;
					case w:
						cur_pos.w=n;
						cur_pos.h+=n;
						if(n>SPACEWIDTH) if(!inhibitspace) fakesp=0;
						inhibitspace=0;
						break;
					case x:
						cur_pos.x=n;
						cur_pos.h+=n;
						if (n>SPACEWIDTH) fakesp=0;
						break;
					case y:
						cur_pos.y=n;
						cur_pos.v+=n;
						if (n>SPACEWIDTH && !mathmode && !noDVIY) {track("DVIY(y1)");return DVIY;};
						break;
					case z:
						cur_pos.z=n;
						cur_pos.v+=n;
						if (n>SPACEWIDTH && !mathmode && !noDVIY) {track("DVIY(z1)");return DVIY;};
						break;
					case r:
						if(n>SPACEWIDTH) if(!inhibitspace) fakesp=0;
						inhibitspace=0;
						break;
				}
			}
<arg_signed2>{ANY}{2}	{
				char temp[2];
				int n;
				if (!BigEndian){
					temp[0]=yytext[1];temp[1]=yytext[0];
				}else{
					temp[0]=yytext[0];temp[1]=yytext[1];
				}
				n=*((short int*) temp);
				BEGIN(0);
				switch(postype){
					case h:
						cur_pos.h+=n;
						break;
					case v:
						cur_pos.v+=n;
						break;
					case w:
						cur_pos.w=n;
						cur_pos.h+=n;
						if(n>SPACEWIDTH) if(!inhibitspace) fakesp=0;
						inhibitspace=0;
						break;
					case x:
						cur_pos.x=n;
						cur_pos.h+=n;
						if (n>SPACEWIDTH) fakesp=0;
						break;
					case y:
						cur_pos.y=n;
						cur_pos.v+=n;
						if (n>SPACEWIDTH && !mathmode && !noDVIY) {track("DVIY(y2)");return DVIY;};
						break;
					case z:
						cur_pos.z=n;
						cur_pos.v+=n;
						if (n>SPACEWIDTH && !mathmode && !noDVIY) {track("DVIY(z2)");return DVIY;};
						break;
					case r:
						if(n>SPACEWIDTH) if(!inhibitspace) fakesp=0;
						inhibitspace=0;
						break;
				}
			}
<arg_signed3>{ANY}{3}	{
				char temp[4];
				int n;
				if (!BigEndian){
					temp[0]=yytext[2];
					temp[1]=yytext[1];
					temp[2]=yytext[0];
					if (yytext[0]&(1<<7)) temp[3]=0xFF;
						else temp[3]=0;
				}else{
					temp[1]=yytext[0];
					temp[2]=yytext[1];
					temp[3]=yytext[2];
					if (yytext[0]&(1<<7)) temp[0]=0xFF;
						else temp[0]=0;
				}
				n=*((int*)temp);
				BEGIN(0);
				switch(postype){
					case h:
						cur_pos.h+=n;
						break;
					case v:
						cur_pos.v+=n;
						if (n>10*SPACEWIDTH && !mathmode &&!inTable && !noDVIY) {track("DVIY(down3)");return DVIY;}
						else {
							if (n>SPACEWIDTH) fakesp=0;
						}
						break;
					case w:
						cur_pos.w=n;
						cur_pos.h+=n;
						if(n>SPACEWIDTH) if(!inhibitspace) fakesp=0;
						inhibitspace=0;
						break;
					case x:
						cur_pos.x=n;
						cur_pos.h+=n;
						if (n>SPACEWIDTH) fakesp=0;
						break;
					case y:
						cur_pos.y=n;
						cur_pos.v+=n;
						if (n>SPACEWIDTH && !mathmode &&!inTable && !noDVIY) {track("DVIY(y3)");return DVIY;};
						break;
					case z:
						cur_pos.z=n;
						cur_pos.v+=n;
						if (n>SPACEWIDTH && !mathmode &&!inTable && !noDVIY) {track("DVIY(z3)");return DVIY;};
						break;
					case r:
						if(n>SPACEWIDTH) if(!inhibitspace) fakesp=0;
						inhibitspace=0;
						break;
				}
			}
<arg_signed4>{ANY}{4}	{
				char temp[4];
				int n;
				if (!BigEndian){
					temp[0]=yytext[3];
					temp[1]=yytext[2];
					temp[2]=yytext[1];
					temp[3]=yytext[0];
				}else{
					temp[0]=yytext[0];
					temp[1]=yytext[1];
					temp[2]=yytext[2];
					temp[3]=yytext[3];
				}
				n=*((int*) temp);
				BEGIN(0);
				switch(postype){
					case h:
						cur_pos.h+=n;
						break;
					case v:
						cur_pos.v+=n;
						break;
					case w:
						cur_pos.w=n;
						cur_pos.h+=n;
						if(n>SPACEWIDTH) if(!inhibitspace) fakesp=0;
						inhibitspace=0;
						break;
					case x:
						cur_pos.x=n;
						cur_pos.h+=n;
						if (n>SPACEWIDTH) fakesp=0;
						break;
					case y:
						cur_pos.y=n;
						cur_pos.v+=n;
						if (n>SPACEWIDTH && !mathmode && !noDVIY) {track("DVIY(y4)");return DVIY;};
						break;
					case z:
						cur_pos.z=n;
						cur_pos.v+=n;
						if (n>SPACEWIDTH && !mathmode && !noDVIY) {track("DVIY(z4)");return DVIY;};
						break;
					case r:
						if(n>SPACEWIDTH) if(!inhibitspace) fakesp=0;
						inhibitspace=0;
						break;
				}
			}

<arg_signed_v>{ANY}	{
			len--;
				if (!len) {
				BEGIN(0);
				if ((signed int)(*yytext) > 0) {;}
				}
				else yymore();
			}

<arg_unsigned>{ANY}	{len--;if (!len) BEGIN(0);}
<arg_set>{ANY}	{len--;if (!len) BEGIN(0); return ANY;}//XXX to be extended for SETx>1

<arg_fdef_k1>{ANY}		{len=12;BEGIN(arg_fdef_csd);}

<arg_fdef_k2>{ANY}{2}		{len=12;BEGIN(arg_fdef_csd);}

<arg_fdef_k3>{ANY}{3}		{len=12;BEGIN(arg_fdef_csd);}

<arg_fdef_k4>{ANY}{4}		{len=12;BEGIN(arg_fdef_csd);}

<arg_fdef_csd>{ANY}		{len--;if (len==0) BEGIN(arg_fdef_a);}

<arg_fdef_a>{ANY}		{
			len=(unsigned char)(*yytext);
			BEGIN(arg_fdef_l);
			}

<arg_fdef_l>{ANY}		{
			len+=(unsigned char)(*yytext);
			if (len) BEGIN(arg_fdef_s);
			else BEGIN(0);//XXX flag as error?
			}

<arg_fdef_s>{ANY}		{
			len--;
			//strcat((*pfont)[maxfonts].s,yytext);
			if (!len)
				{
				maxfonts++;
				if (maxfonts>maxFontNr)
					{printf("error:\nthe postamble says %d fonts are defined, got more instead:%d\nquitting\n",maxFontNr,maxfonts); 
				exit(EXIT_FAILURE);}
				BEGIN(0);
				}
			}

<argpre>{ANY}{13}	{BEGIN(argpre_k);}

<argpre_k>{ANY}		{
			len=(unsigned char)(*yytext);
			if (len) BEGIN(ignoreN);
			else BEGIN(0);
			}

<argk1>{ANY}		{
			len=(unsigned char)(*yytext);
			if (len) BEGIN(xxxtoken);
			else BEGIN(0);
			}

<argk2>{ANY}{2}		{
			char temp[2];
			if (!BigEndian){
				temp[0]=yytext[1];
				temp[1]=yytext[0];
			}else{
				temp[0]=yytext[0];
				temp[1]=yytext[1];
			}
			len=*((unsigned short int*) temp);
			if (len) BEGIN(xxxtoken);
			else BEGIN(0);
			}

<argk3>{ANY}{3}		{
			char temp[4];
			if (!BigEndian){
				temp[0]=yytext[2];
				temp[1]=yytext[1];
				temp[2]=yytext[0];
				temp[3]=0;
			}else{
				temp[0]=0;
				temp[1]=yytext[0];
				temp[2]=yytext[1];
				temp[3]=yytext[2];
			}
			len=*((int*) temp);
			if (len) BEGIN(xxxtoken);
			else BEGIN(0);
			}

<argk4>{ANY}{4}		{
			char temp[4];
			if (!BigEndian){
				temp[0]=yytext[3];
				temp[1]=yytext[2];
				temp[2]=yytext[1];
				temp[3]=yytext[0];
			}else{
				temp[0]=yytext[0];
				temp[1]=yytext[1];
				temp[2]=yytext[2];
				temp[3]=yytext[3];
			}
			len=*((int*) temp);
			if (len) BEGIN(xxxtoken);
			else BEGIN(0);
			}

<ignore>{ANY}		{}
<ignoreN>{ANY}		{
			len--;
			if (!len)	BEGIN(0);
			}

<xxxtoken>{S}ignore{S} 		{BEGIN(0);track(NULL);}//ignored 
<xxxtoken>{S}limits{S} 		{BEGIN(0);track(NULL);}//ignored 

<xxxtoken>{S}bigsqcup{S} 		{BEGIN(0);track(NULL);return BIGSQCUP;}
<xxxtoken>{S}bigsqcap{S} 		{BEGIN(0);track(NULL);return BIGSQCAP;}

<xxxtoken>{S}Left:{S} 		{BEGIN(0);track(NULL);return BLeft;}
<xxxtoken>{S}:Left{S} 		{BEGIN(0);track(NULL);return ELeft;}
<xxxtoken>{S}Right:{S} 		{BEGIN(0);track(NULL);return BRight;}
<xxxtoken>{S}:Right{S} 		{BEGIN(0);track(NULL);return ERight;}

<xxxtoken>{S}bra:{S} 		{BEGIN(0);return BBra;}
<xxxtoken>{S}:bra{S} 		{BEGIN(0);return EBra;}
<xxxtoken>{S}ket:{S} 		{BEGIN(0);return BKet;}
<xxxtoken>{S}:ket{S} 		{BEGIN(0);return EKet;}
<xxxtoken>{S}notin{S} 		{BEGIN(0);track(NULL);return NOTIN;}

<xxxtoken>{BPlus} 		{BEGIN(0);return BPlus;}
<xxxtoken>{Plus} 		{BEGIN(0);dropN=1;return Plus;}
<xxxtoken>{EPlus} 		{BEGIN(0);return EPlus;}
<xxxtoken>{BMinus} 		{BEGIN(0);return BMinus;}
<xxxtoken>{Minus} 		{BEGIN(0);dropN=1;return Minus;}
<xxxtoken>{EMinus} 		{BEGIN(0);return EMinus;}

<xxxtoken>{BEqual} 		{BEGIN(0);return BEqual;}
<xxxtoken>{Equal} 		{BEGIN(0);return Equal;}
<xxxtoken>{EEqual} 		{BEGIN(0);return EEqual;}
<xxxtoken>{BNequal} 		{BEGIN(0);return BNequal;}
<xxxtoken>{Nequal} 		{BEGIN(0);return Nequal;}
<xxxtoken>{ENequal} 		{BEGIN(0);return ENequal;}
<xxxtoken>{BLequal} 		{BEGIN(0);return BLequal;}
<xxxtoken>{Lequal} 		{BEGIN(0);return Lequal;}
<xxxtoken>{ELequal} 		{BEGIN(0);return ELequal;}
<xxxtoken>{BGequal} 		{BEGIN(0);return BGequal;}
<xxxtoken>{Gequal} 		{BEGIN(0);return Gequal;}
<xxxtoken>{EGequal} 		{BEGIN(0);return EGequal;}

<xxxtoken>{BEquiv} 		{BEGIN(0);return BEquiv;}
<xxxtoken>{Equiv} 		{BEGIN(0);return Equiv;}
<xxxtoken>{EEquiv} 		{BEGIN(0);return EEquiv;}
<xxxtoken>{BApprox} 		{BEGIN(0);return BApprox;}
<xxxtoken>{Approx} 		{BEGIN(0);return Approx;}
<xxxtoken>{EApprox} 		{BEGIN(0);return EApprox;}

<xxxtoken>{BGthan}			{BEGIN(0);return BGthan;}
<xxxtoken>{Gthan}			{BEGIN(0);return Gthan;}
<xxxtoken>{EGthan}			{BEGIN(0);return EGthan;}
<xxxtoken>{BLthan}			{BEGIN(0);return BLthan;}
<xxxtoken>{Lthan}			{BEGIN(0);return Lthan;}
<xxxtoken>{ELthan}			{BEGIN(0);return ELthan;}

<xxxtoken>{BTimes} 		{BEGIN(0);return BTimes;}
<xxxtoken>{Times} 		{BEGIN(0);return Times;}
<xxxtoken>{ETimes} 		{BEGIN(0);return ETimes;}
<xxxtoken>{BRoot}			{BEGIN(0);track(NULL);return BRoot;}
<xxxtoken>{Root} 			{BEGIN(0);track(NULL);return Root;}
<xxxtoken>{ERoot}			{BEGIN(0);track(NULL);return ERoot;}

<xxxtoken>{BPower} 		{BEGIN(0);return BPower;}
<xxxtoken>{Power} 		{BEGIN(0);return Power;}
<xxxtoken>{EPower} 		{BEGIN(0);return EPower;}
<xxxtoken>{BSP} 			{BEGIN(0);return BSP;}
<xxxtoken>{ESP} 			{BEGIN(0);return ESP;}
<xxxtoken>{BSB} 			{BEGIN(0);return BSB;}
<xxxtoken>{SBCHAR} 			{BEGIN(0);return SBCHAR;}
<xxxtoken>{ESB} 			{BEGIN(0);return ESB;}

<xxxtoken>{ARCCOS}		{BEGIN(0);dropN=6;return ARCCOS;}
<xxxtoken>{ARCSIN}		{BEGIN(0);dropN=6;return ARCSIN;}
<xxxtoken>{ARCTAN}		{BEGIN(0);dropN=6;return ARCTAN;}
<xxxtoken>{ARG}		{BEGIN(0);dropN=3;return ARG;}
<xxxtoken>{COS}		{BEGIN(0);dropN=3;return COS;}
<xxxtoken>{COSH}		{BEGIN(0);dropN=4;return COSH;}
<xxxtoken>{COT}		{BEGIN(0);dropN=3;return COT;}
<xxxtoken>{COTH}		{BEGIN(0);dropN=4;return COTH;}
<xxxtoken>{CSC}		{BEGIN(0);dropN=3;return CSC;}
<xxxtoken>{DEG}		{BEGIN(0);dropN=3;return DEG;}
<xxxtoken>{DET}		{BEGIN(0);dropN=3;return DET;}
<xxxtoken>{DIM}		{BEGIN(0);dropN=3;return DIM;}
<xxxtoken>{EXP}		{BEGIN(0);dropN=3;return EXP;}
<xxxtoken>{GCD}		{BEGIN(0);dropN=3;return GCD;}
<xxxtoken>{BGcd}		{BEGIN(0);return BGcd;}
<xxxtoken>{EGcd}		{BEGIN(0);return EGcd;}
<xxxtoken>{BLcm}		{BEGIN(0);return BLcm;}
<xxxtoken>{LCM}		{BEGIN(0);dropN=3;return LCM;}
<xxxtoken>{ELcm}		{BEGIN(0);return ELcm;}
<xxxtoken>{BRe}		{BEGIN(0);return BRe;}
<xxxtoken>{ERe}		{BEGIN(0);return ERe;}
<xxxtoken>{BIm}		{BEGIN(0);return BIm;}
<xxxtoken>{EIm}		{BEGIN(0);return EIm;}

<xxxtoken>{HOM}		{BEGIN(0);dropN=3;return HOM;}
<xxxtoken>{INF}		{BEGIN(0);dropN=3;return INF;}
<xxxtoken>{KER}		{BEGIN(0);dropN=3;return KER;}
<xxxtoken>{LG}		{BEGIN(0);dropN=2;return LG;}
<xxxtoken>{LIM}		{BEGIN(0);dropN=3;return LIM;}
<xxxtoken>{LIMINF}		{BEGIN(0);dropN=6;return LIMINF;}
<xxxtoken>{LIMSUP}		{BEGIN(0);dropN=6;return LIMSUP;}
<xxxtoken>{LN}		{BEGIN(0);dropN=2;return LN;}
<xxxtoken>{LOG}		{BEGIN(0);dropN=3;return LOG;}
<xxxtoken>{MAX}		{BEGIN(0);dropN=3;return MAX;}
<xxxtoken>{MIN}		{BEGIN(0);dropN=3;return MIN;}
<xxxtoken>{PR}		{BEGIN(0);dropN=2;return PR;}
<xxxtoken>{SEC}		{BEGIN(0);dropN=3;return SEC;}
<xxxtoken>{SIN}		{BEGIN(0);dropN=3;return SIN;}
<xxxtoken>{SINH}		{BEGIN(0);dropN=4;return SINH;}
<xxxtoken>{SUP}		{BEGIN(0);dropN=3;return SUP;}
<xxxtoken>{TAN}		{BEGIN(0);dropN=3;return TAN;}
<xxxtoken>{TANH}		{BEGIN(0);dropN=4;return TANH;}

<xxxtoken>{Bfunc}	{BEGIN(0);return Bfunc;}
<xxxtoken>{Bfarg}	{BEGIN(0);return Bfarg;}
<xxxtoken>{Efarg}	{BEGIN(0);return Efarg;}
<xxxtoken>{Efunc}	{BEGIN(0);return Efunc;}

<xxxtoken>{BCompose}	{BEGIN(0);return BCompose;}
<xxxtoken>{Compose}	{BEGIN(0);return Compose;}
<xxxtoken>{ECompose}	{BEGIN(0);return ECompose;}
<xxxtoken>{S}Interval:{S}	{BEGIN(0);track(NULL);return BInterval;}
<xxxtoken>{S}Interval{S}	{BEGIN(0);track(NULL);return Interval;}
<xxxtoken>{S}:Interval{S}	{BEGIN(0);track(NULL);return EInterval;}
<xxxtoken>{BInverse}	{BEGIN(0);return BInverse;}
<xxxtoken>{Inverse}	{BEGIN(0);return Inverse;}
<xxxtoken>{EInverse}	{BEGIN(0);return EInverse;}
<xxxtoken>{Ident}	{BEGIN(0);dropN=2;return Ident;}
<xxxtoken>{BDomain}	{BEGIN(0);dropN=6;return BDomain;}
<xxxtoken>{EDomain}	{BEGIN(0);return EDomain;}
<xxxtoken>{BCodomain}	{BEGIN(0);dropN=8;return BCodomain;}
<xxxtoken>{ECodomain}	{BEGIN(0);return ECodomain;}
<xxxtoken>{BImage}	{BEGIN(0);dropN=5;return BImage;}
<xxxtoken>{EImage}	{BEGIN(0);return EImage;}
<xxxtoken>{S}amsCases:{S}	{BEGIN(0);track(NULL);return BAmsCases;}
<xxxtoken>{S}:amsCases{S}	{BEGIN(0);track(NULL);return EAmsCases;}
<xxxtoken>{S}cases:{S}	{BEGIN(0);track(NULL);return BCases;}
<xxxtoken>{S}:cases{S}	{BEGIN(0);track(NULL);return ECases;}


<xxxtoken>{BQuotient}		{BEGIN(0);return BQuotient;}
<xxxtoken>{Quotient}		{BEGIN(0);return Quotient;}
<xxxtoken>{EQuotient}		{BEGIN(0);return EQuotient;}

<xxxtoken>{BFactorial}		{BEGIN(0);return BFactorial;}
<xxxtoken>{Factorial}		{BEGIN(0);return Factorial;}
<xxxtoken>{EFactorial}		{BEGIN(0);return EFactorial;}

<xxxtoken>{S}Frac:{S} 			{BEGIN(0);track(NULL);return BFrac;}
<xxxtoken>{S}Fracn{S} 			{BEGIN(0);track(NULL);return Fracn;}
<xxxtoken>{S}Fracd{S} 			{BEGIN(0);track(NULL);return Fracd;}
<xxxtoken>{S}:Frac{S} 			{BEGIN(0);track(NULL);return EFrac;}


<xxxtoken>{BMaxl}		{BEGIN(0);return BMaxl;}
<xxxtoken>{BMaxc}		{BEGIN(0);return BMaxc;}
<xxxtoken>{BCond}		{BEGIN(0);return BCond;}
<xxxtoken>{ECond}		{BEGIN(0);return ECond;}
<xxxtoken>{BVar}		{BEGIN(0);return BVar;}
<xxxtoken>{EVar}		{BEGIN(0);return EVar;}
<xxxtoken>{BExpr}		{BEGIN(0);return BExpr;}
<xxxtoken>{EExpr}		{BEGIN(0);return EExpr;}
<xxxtoken>{EMaxl}		{BEGIN(0);return EMaxl;}
<xxxtoken>{EMaxc}		{BEGIN(0);return EMaxc;}
<xxxtoken>{BMinl}		{BEGIN(0);return BMinl;}
<xxxtoken>{BMinc}		{BEGIN(0);return BMinc;}
<xxxtoken>{EMinl}		{BEGIN(0);return EMinl;}
<xxxtoken>{EMinc}		{BEGIN(0);return EMinc;}

<xxxtoken>{BRem}			{BEGIN(0);return BRem;}
<xxxtoken>{Rem}			{BEGIN(0);return Rem;}
<xxxtoken>{ERem}			{BEGIN(0);return ERem;}
<xxxtoken>{REM}			{BEGIN(0);dropN=3;return REM;}
<xxxtoken>{S}pmod:{S}			{BEGIN(0);dropN=4;return BPMOD;}
<xxxtoken>{S}:pmod{S}			{BEGIN(0);dropN=1;return EPMOD;}

<xxxtoken>{AND}			{BEGIN(0);return AND;}
<xxxtoken>{BLand}			{BEGIN(0);return BLand;}
<xxxtoken>{Land}			{BEGIN(0);return Land;}
<xxxtoken>{ELand}			{BEGIN(0);return ELand;}

<xxxtoken>{OR}			{BEGIN(0);return OR;}
<xxxtoken>{BLor}			{BEGIN(0);return BLor;}
<xxxtoken>{Lor}			{BEGIN(0);return Lor;}
<xxxtoken>{ELor}			{BEGIN(0);return ELor;}

<xxxtoken>{XOR}			{BEGIN(0);dropN=3;return XOR;}
<xxxtoken>{BXor}			{BEGIN(0);return BXor;}
<xxxtoken>{Xor}			{BEGIN(0);return Xor;}
<xxxtoken>{EXor}			{BEGIN(0);return EXor;}

<xxxtoken>{BNot}			{BEGIN(0);dropN=1;return BNot;}
<xxxtoken>{ENot}			{BEGIN(0);return ENot;}


<xxxtoken>{BImplies}			{BEGIN(0);return BImplies;}
<xxxtoken>{Implies}			{BEGIN(0);return Implies;}
<xxxtoken>{EImplies}			{BEGIN(0);return EImplies;}

<xxxtoken>{BForall}		{BEGIN(0);dropN=1;return BForall;}
<xxxtoken>{EForall}		{BEGIN(0);return EForall;}
<xxxtoken>{BAssert}		{BEGIN(0);return BAssert;}
<xxxtoken>{EAssert}		{BEGIN(0);return EAssert;}
<xxxtoken>{BExists}		{BEGIN(0);dropN=1;return BExists;}
<xxxtoken>{EExists}		{BEGIN(0);return EExists;}

<xxxtoken>{Babs}		{BEGIN(0);return Babs;}
<xxxtoken>{Eabs}		{BEGIN(0);return Eabs;}
<xxxtoken>{Bconjugate}		{BEGIN(0);return Bconjugate;}
<xxxtoken>{Econjugate}		{BEGIN(0);return Econjugate;}
<xxxtoken>{BArg}		{BEGIN(0);dropN=3;return BArg;}
<xxxtoken>{EArg}		{BEGIN(0);return EArg;}


<xxxtoken>{Bfloor}		{BEGIN(0);return Bfloor;}
<xxxtoken>{Efloor}		{BEGIN(0);return Efloor;}
<xxxtoken>{Bceil}		{BEGIN(0);return Bceil;}
<xxxtoken>{Eceil}		{BEGIN(0);return Eceil;}

<xxxtoken>{BFactor}			{BEGIN(0);return BFactor;}
<xxxtoken>{Factor}			{BEGIN(0);return Factor;}
<xxxtoken>{EFactor}			{BEGIN(0);return EFactor;}

<xxxtoken>{BInt}			{BEGIN(0);return BInt;}
<xxxtoken>{EInt}			{BEGIN(0);return EInt;}
<xxxtoken>{BIntll}			{BEGIN(0);return BIntll;}
<xxxtoken>{EIntll}			{BEGIN(0);return EIntll;}
<xxxtoken>{BIntul}			{BEGIN(0);return BIntul;}
<xxxtoken>{EIntul}			{BEGIN(0);return EIntul;}
<xxxtoken>{BIntarg}			{BEGIN(0);return BIntarg;}
<xxxtoken>{EIntarg}			{BEGIN(0);return EIntarg;}
<xxxtoken>{BIntbe}			{BEGIN(0);return BIntbe;}
<xxxtoken>{EIntbe}			{BEGIN(0);return EIntbe;}

<xxxtoken>{BDiff}			{BEGIN(0);return BDiff;}
<xxxtoken>{EDiff}			{BEGIN(0);return EDiff;}
<xxxtoken>{BDiffbe}			{BEGIN(0);return BDiffbe;}
<xxxtoken>{EDiffbe}			{BEGIN(0);return EDiffbe;}
<xxxtoken>{BDiffdeg}		{BEGIN(0);return BDiffdeg;}
<xxxtoken>{EDiffdeg}		{BEGIN(0);return EDiffdeg;}
<xxxtoken>{BDiffarg}		{BEGIN(0);return BDiffarg;}
<xxxtoken>{EDiffarg}		{BEGIN(0);return EDiffarg;}


<xxxtoken>{BSum}			{BEGIN(0);return BSum;}
<xxxtoken>{ESum}			{BEGIN(0);return ESum;}
<xxxtoken>{BSumll}			{BEGIN(0);return BSumll;}
<xxxtoken>{ESumll}			{BEGIN(0);return ESumll;}
<xxxtoken>{BSumul}			{BEGIN(0);return BSumul;}
<xxxtoken>{ESumul}			{BEGIN(0);return ESumul;}
<xxxtoken>{BSumarg}			{BEGIN(0);return BSumarg;}
<xxxtoken>{ESumarg}			{BEGIN(0);return ESumarg;}

<xxxtoken>{BProd}			{BEGIN(0);return BProd;}
<xxxtoken>{EProd}			{BEGIN(0);return EProd;}
<xxxtoken>{BProdll}			{BEGIN(0);return BProdll;}
<xxxtoken>{EProdll}			{BEGIN(0);return EProdll;}
<xxxtoken>{BProdul}			{BEGIN(0);return BProdul;}
<xxxtoken>{EProdul}			{BEGIN(0);return EProdul;}
<xxxtoken>{BProdarg}			{BEGIN(0);return BProdarg;}
<xxxtoken>{EProdarg}			{BEGIN(0);return EProdarg;}

<xxxtoken>{BLimit}			{BEGIN(0);return BLimit;}
<xxxtoken>{ELimit}			{BEGIN(0);return ELimit;}
<xxxtoken>{BLimitarg}			{BEGIN(0);return BLimitarg;}
<xxxtoken>{ELimitarg}			{BEGIN(0);return ELimitarg;}

<xxxtoken>{BTendsto}			{BEGIN(0);return BTendsto;}
<xxxtoken>{Tendsto}			{BEGIN(0);dropN=1;return Tendsto;}
<xxxtoken>{ETendsto}			{BEGIN(0);return ETendsto;}

<xxxtoken>{BDivt}				{BEGIN(0);dropN=3;return BDivt;}
<xxxtoken>{BDivs}				{BEGIN(0);dropN=2;return BDivs;}
<xxxtoken>{EDiv}				{BEGIN(0);return EDiv;}
<xxxtoken>{BGradt}			{BEGIN(0);dropN=4;return BGradt;}
<xxxtoken>{BGrads}			{BEGIN(0);dropN=1;return BGrads;}
<xxxtoken>{EGrad}			{BEGIN(0);return EGrad;}
<xxxtoken>{BCurlt}			{BEGIN(0);dropN=4;return BCurlt;}
<xxxtoken>{BCurls}			{BEGIN(0);dropN=2;return BCurls;}
<xxxtoken>{ECurl}			{BEGIN(0);return ECurl;}
<xxxtoken>{BLaplacian}		{BEGIN(0);dropN=1;return BLaplacian;}
<xxxtoken>{ELaplacian}		{BEGIN(0);return ELaplacian;}

<xxxtoken>{BSubset}			{BEGIN(0);return BSubset;}
<xxxtoken>{Subset}			{BEGIN(0);return Subset;}
<xxxtoken>{ESubset}			{BEGIN(0);return ESubset;}
<xxxtoken>{BNotsubset}			{BEGIN(0);return BNotsubset;}
<xxxtoken>{Notsubset}			{BEGIN(0);return Notsubset;}
<xxxtoken>{ENotsubset}			{BEGIN(0);return ENotsubset;}

<xxxtoken>{BSubseteq}			{BEGIN(0);return BSubseteq;}
<xxxtoken>{Subseteq}			{BEGIN(0);return Subseteq;}
<xxxtoken>{ESubseteq}			{BEGIN(0);return ESubseteq;}
<xxxtoken>{BNotsubseteq}			{BEGIN(0);return BNotsubseteq;}
<xxxtoken>{Notsubseteq}			{BEGIN(0);return Notsubseteq;}
<xxxtoken>{ENotsubseteq}			{BEGIN(0);return ENotsubseteq;}

<xxxtoken>{BSetl}			{BEGIN(0);return BSetl;}
<xxxtoken>{ESetl}			{BEGIN(0);return ESetl;}
<xxxtoken>{BSetc}			{BEGIN(0);return BSetc;}
<xxxtoken>{ESetc}			{BEGIN(0);return ESetc;}

<xxxtoken>{BListl}			{BEGIN(0);return BListl;}
<xxxtoken>{EListl}			{BEGIN(0);return EListl;}
<xxxtoken>{BListc}			{BEGIN(0);return BListc;}
<xxxtoken>{EListc}			{BEGIN(0);return EListc;}

<xxxtoken>{BUnion}			{BEGIN(0);return BUnion;}
<xxxtoken>{Union}			{BEGIN(0);return Union;}
<xxxtoken>{EUnion}			{BEGIN(0);return EUnion;}

<xxxtoken>{BIntersect}			{BEGIN(0);return BIntersect;}
<xxxtoken>{Intersect}			{BEGIN(0);return Intersect;}
<xxxtoken>{EIntersect}			{BEGIN(0);return EIntersect;}

<xxxtoken>{BIn}			{BEGIN(0);return BIn;}
<xxxtoken>{In}			{BEGIN(0);return In;}
<xxxtoken>{EIn}			{BEGIN(0);return EIn;}

<xxxtoken>{BNotin}			{BEGIN(0);return BNotin;}
<xxxtoken>{Notin}			{BEGIN(0);return Notin;}
<xxxtoken>{ENotin}			{BEGIN(0);return ENotin;}

<xxxtoken>{BSetdiff}		{BEGIN(0);return BSetdiff;}
<xxxtoken>{Setdiff}		{BEGIN(0);return Setdiff;}
<xxxtoken>{ESetdiff}		{BEGIN(0);return ESetdiff;}

<xxxtoken>{BCard}		{BEGIN(0);return BCard;}
<xxxtoken>{ECard}		{BEGIN(0);return ECard;}

<xxxtoken>{BCartesian}		{BEGIN(0);return BCartesian;}
<xxxtoken>{Cartesian}		{BEGIN(0);return Cartesian;}
<xxxtoken>{ECartesian}		{BEGIN(0);return ECartesian;}

<xxxtoken>{BSin}		{BEGIN(0);return BSin;}
<xxxtoken>{ESin}		{BEGIN(0);return ESin;}
<xxxtoken>{BCos}		{BEGIN(0);return BCos;}
<xxxtoken>{ECos}		{BEGIN(0);return ECos;}
<xxxtoken>{BTan}		{BEGIN(0);return BTan;}
<xxxtoken>{ETan}		{BEGIN(0);return ETan;}
<xxxtoken>{BSec}		{BEGIN(0);return BSec;}
<xxxtoken>{ESec}		{BEGIN(0);return ESec;}
<xxxtoken>{BCsc}		{BEGIN(0);return BCsc;}
<xxxtoken>{ECsc}		{BEGIN(0);return ECsc;}
<xxxtoken>{BCot}		{BEGIN(0);return BCot;}
<xxxtoken>{ECot}		{BEGIN(0);return ECot;}
<xxxtoken>{BSinh}		{BEGIN(0);return BSinh;}
<xxxtoken>{ESinh}		{BEGIN(0);return ESinh;}
<xxxtoken>{BCosh}		{BEGIN(0);return BCosh;}
<xxxtoken>{ECosh}		{BEGIN(0);return ECosh;}
<xxxtoken>{BTanh}		{BEGIN(0);return BTanh;}
<xxxtoken>{ETanh}		{BEGIN(0);return ETanh;}
<xxxtoken>{BSech}		{BEGIN(0);return BSech;}
<xxxtoken>{Sech}			{BEGIN(0);dropN=4;return Sech;}
<xxxtoken>{ESech}		{BEGIN(0);return ESech;}
<xxxtoken>{BCsch}		{BEGIN(0);return BCsch;}
<xxxtoken>{Csch}			{BEGIN(0);dropN=4;return Csch;}
<xxxtoken>{ECsch}		{BEGIN(0);return ECsch;}
<xxxtoken>{BCoth}		{BEGIN(0);return BCoth;}
<xxxtoken>{ECoth}		{BEGIN(0);return ECoth;}

<xxxtoken>{BArccos}		{BEGIN(0);return BArccos;}
<xxxtoken>{EArccos}		{BEGIN(0);return EArccos;}
<xxxtoken>{BArccosh}		{BEGIN(0);return BArccosh;}
<xxxtoken>{Arccosh}		{BEGIN(0);return Arccosh;}
<xxxtoken>{EArccosh}		{BEGIN(0);return EArccosh;}
<xxxtoken>{BArcsin}		{BEGIN(0);return BArcsin;}
<xxxtoken>{EArcsin}		{BEGIN(0);return EArcsin;}



<xxxtoken>{BArccot}		{BEGIN(0);return BArccot;}
<xxxtoken>{Arccot}		{BEGIN(0);dropN=6;return Arccot;}
<xxxtoken>{EArccot}		{BEGIN(0);return EArccot;}
<xxxtoken>{BArccoth}		{BEGIN(0);return BArccoth;}
<xxxtoken>{Arccoth}		{BEGIN(0);dropN=7;return Arccoth;}
<xxxtoken>{EArccoth}		{BEGIN(0);return EArccoth;}

<xxxtoken>{BArccsc}		{BEGIN(0);return BArccsc;}
<xxxtoken>{Arccsc}		{BEGIN(0);dropN=6;return Arccsc;}
<xxxtoken>{EArccsc}		{BEGIN(0);return EArccsc;}
<xxxtoken>{BArccsch}		{BEGIN(0);return BArccsch;}
<xxxtoken>{Arccsch}		{BEGIN(0);dropN=7;return Arccsch;}
<xxxtoken>{EArccsch}		{BEGIN(0);return EArccsch;}

<xxxtoken>{BArcsec}		{BEGIN(0);return BArcsec;}
<xxxtoken>{Arcsec}		{BEGIN(0);dropN=6;return Arcsec;}
<xxxtoken>{EArcsec}		{BEGIN(0);return EArcsec;}

<xxxtoken>{BArcsech}		{BEGIN(0);return BArcsech;}
<xxxtoken>{Arcsech}		{BEGIN(0);dropN=7;return Arcsech;}
<xxxtoken>{EArcsech}		{BEGIN(0);return EArcsech;}
<xxxtoken>{BArcsinh}		{BEGIN(0);return BArcsinh;}
<xxxtoken>{Arcsinh}		{BEGIN(0);dropN=7;return Arcsinh;}
<xxxtoken>{EArcsinh}		{BEGIN(0);return EArcsinh;}
<xxxtoken>{BArctanh}		{BEGIN(0);return BArctanh;}
<xxxtoken>{Arctanh}		{BEGIN(0);dropN=7;return Arctanh;}
<xxxtoken>{EArctanh}		{BEGIN(0);return EArctanh;}
<xxxtoken>{BArctan}		{BEGIN(0);return BArctan;}
<xxxtoken>{EArctan}		{BEGIN(0);return EArctan;}

<xxxtoken>{BExp}		{BEGIN(0);return BExp;}
<xxxtoken>{EExp}		{BEGIN(0);return EExp;}
<xxxtoken>{BLog}		{BEGIN(0);return BLog;}
<xxxtoken>{ELog}		{BEGIN(0);return ELog;}
<xxxtoken>{BLg}		{BEGIN(0);return BLg;}
<xxxtoken>{ELg}		{BEGIN(0);return ELg;}
<xxxtoken>{BLn}		{BEGIN(0);return BLn;}
<xxxtoken>{ELn}		{BEGIN(0);return ELn;}

<xxxtoken>{BMean}			{BEGIN(0);dropN=1;return BMean;}
<xxxtoken>{EMean}			{BEGIN(0);dropN=1;return EMean;}
<xxxtoken>{BSDev}			{BEGIN(0);return BSDev;}
<xxxtoken>{ESDev}			{BEGIN(0);return ESDev;}
<xxxtoken>{BVariance}			{BEGIN(0);return BVariance;}
<xxxtoken>{Variance}			{BEGIN(0);return Variance;}
<xxxtoken>{EVariance}			{BEGIN(0);return EVariance;}
<xxxtoken>{BMedian}			{BEGIN(0);return BMedian;}
<xxxtoken>{Median}			{BEGIN(0);dropN=6;return Median;}
<xxxtoken>{EMedian}			{BEGIN(0);return EMedian;}
<xxxtoken>{BMode}			{BEGIN(0);return BMode;}
<xxxtoken>{Mode}			{BEGIN(0);dropN=4;return Mode;}
<xxxtoken>{EMode}			{BEGIN(0);return EMode;}

<xxxtoken>{BMoment}			{BEGIN(0);dropN=1;return BMoment;}
<xxxtoken>{EMoment}			{BEGIN(0);dropN=1;return EMoment;}
<xxxtoken>{BMomentDeg}			{BEGIN(0);return BMomentDeg;}
<xxxtoken>{EMomentDeg}			{BEGIN(0);return EMomentDeg;}
<xxxtoken>{BMomentArg}			{BEGIN(0);return BMomentArg;}
<xxxtoken>{EMomentArg}			{BEGIN(0);return EMomentArg;}
<xxxtoken>{BMomenta}			{BEGIN(0);dropN=1;return BMomenta;}
<xxxtoken>{EMomenta}			{BEGIN(0);dropN=1;return EMomenta;}
<xxxtoken>{BMabout}			{BEGIN(0);return BMabout;}
<xxxtoken>{EMabout}			{BEGIN(0);return EMabout;}

<xxxtoken>{BVector}			{BEGIN(0);return BVector;}
<xxxtoken>{EVector}			{BEGIN(0);return EVector;}
<xxxtoken>{BMatrix}			{BEGIN(0);return BMatrix;}
<xxxtoken>{EMatrix}			{BEGIN(0);return EMatrix;}
<xxxtoken>{S}matrix:{S}			{BEGIN(0);track(NULL);return BMATRIX;}
<xxxtoken>{S}:matrix{S}			{BEGIN(0);track(NULL);return EMATRIX;}
<xxxtoken>{S}pmatrix:{S}			{BEGIN(0);track(NULL);dropN=1;}//dropN=1 means 
<xxxtoken>{S}:pmatrix{S}			{BEGIN(0);track(NULL);dropN=1;}//forget about the parentheses

<xxxtoken>{BTranspose}			{BEGIN(0);return BTranspose;}
<xxxtoken>{ETranspose}			{BEGIN(0);return ETranspose;}
<xxxtoken>{BDet}			{BEGIN(0);return BDet;}
<xxxtoken>{EDet}			{BEGIN(0);return EDet;}
<xxxtoken>{BSelector}			{BEGIN(0);return BSelector;}
<xxxtoken>{SelectorMatrix}			{BEGIN(0);return SelectorMatrix;}
<xxxtoken>{ESelector}			{BEGIN(0);return ESelector;}

<xxxtoken>{BVectorProduct}			{BEGIN(0);return BVectorProduct;}
<xxxtoken>{VectorProduct}			{BEGIN(0);return VectorProduct;}
<xxxtoken>{EVectorProduct}			{BEGIN(0);return EVectorProduct;}

<xxxtoken>{BScalarProduct}			{BEGIN(0);return BScalarProduct;}
<xxxtoken>{ScalarProduct}			{BEGIN(0);return ScalarProduct;}
<xxxtoken>{EScalarProduct}			{BEGIN(0);return EScalarProduct;}

<xxxtoken>{BOuterProduct}			{BEGIN(0);return BOuterProduct;}
<xxxtoken>{OuterProduct}			{BEGIN(0);return OuterProduct;}
<xxxtoken>{EOuterProduct}			{BEGIN(0);return EOuterProduct;}

<xxxtoken>{Integers}			{BEGIN(0);dropN=1;return Integers;}
<xxxtoken>{Naturals}			{BEGIN(0);dropN=1;return Naturals;}
<xxxtoken>{Rationals}			{BEGIN(0);dropN=1;return Rationals;}
<xxxtoken>{Reals}				{BEGIN(0);dropN=1;return Reals;}
<xxxtoken>{Complexes}			{BEGIN(0);dropN=1;return Complexes;}
<xxxtoken>{Primes}				{BEGIN(0);dropN=1;return Primes;}

<xxxtoken>{ExponentialE}		{BEGIN(0);dropN=1;return ExponentialE;}
<xxxtoken>{ImaginaryI}			{BEGIN(0);dropN=1;return ImaginaryI;}
<xxxtoken>{NotANumber}			{BEGIN(0);dropN=3;return NotANumber;}
<xxxtoken>{True}				{BEGIN(0);dropN=4;return True;}
<xxxtoken>{False}				{BEGIN(0);dropN=5;return False;}
<xxxtoken>{Emptyset}				{BEGIN(0);dropN=1;return Emptyset;}
<xxxtoken>{PiCst}				{BEGIN(0);dropN=1;return PiCst;}
<xxxtoken>{EulerGamma}			{BEGIN(0);dropN=1;return EulerGamma;}
<xxxtoken>{Infty}				{BEGIN(0);dropN=1;return Infty;}
<xxxtoken>{S}hbar{S}				{BEGIN(0);return HBar;}

<xxxtoken>{S}cdots{S} 			{BEGIN(0);track("cdots");dropN=3;inhibitspace=1;return CDOTS;}
<xxxtoken>{S}ddots{S} 			{BEGIN(0);track("ddots");dropN=3;inhibitspace=1;return DDOTS;}
<xxxtoken>{S}ldots{S} 			{BEGIN(0);track("ldots");dropN=3;inhibitspace=1;return LDOTS;}
<xxxtoken>{S}vdots{S} 			{BEGIN(0);track("vdots");dropN=3;inhibitspace=1;return VDOTS;}

<xxxtoken>{S}eqalign:{S} 			{BEGIN(0);track(NULL);return BEQALIGN;}
<xxxtoken>{S}:eqalign{S} 			{BEGIN(0);track(NULL);return EEQALIGN;}

<xxxtoken>{S}align{S} 			{BEGIN(0);track(NULL);return ALIGN;}
<xxxtoken>{S}mtable:{S} 			{BEGIN(0);track(NULL);return BMTABLE;}
<xxxtoken>{S}:mtable{S} 			{BEGIN(0);track(NULL);return EMTABLE;}
<xxxtoken>{S}array:{S} 			{BEGIN(0);track(NULL);return BARRAY;}
<xxxtoken>{S}:array{S} 			{BEGIN(0);track(NULL);return EARRAY;}
<xxxtoken>{S}eqnarray:{S} 			{BEGIN(0);track(NULL);return BEqnArray;}
<xxxtoken>{S}:eqnarray{S} 			{BEGIN(0);track(NULL);return EEqnArray;}
<xxxtoken>{S}aligned:{S} 			{BEGIN(0);track(NULL);return BAligned;}
<xxxtoken>{S}:aligned{S} 			{BEGIN(0);track(NULL);return EAligned;}
<xxxtoken>{S}align:{S} 			{BEGIN(0);track(NULL);return BAlign;}
<xxxtoken>{S}:align{S} 			{BEGIN(0);track(NULL);return EAlign;}

<xxxtoken>{S}frac:{S} 			{BEGIN(0);track(NULL);return BFRAC;}
<xxxtoken>{S}fracn{S} 			{BEGIN(0);track(NULL);return FRACN;}
<xxxtoken>{S}fracd{S} 			{BEGIN(0);track(NULL);return FRACD;}
<xxxtoken>{S}:frac{S} 			{BEGIN(0);track(NULL);return EFRAC;}
<xxxtoken>{S}over{S} 			{BEGIN(0);track(NULL);return OVER;}
<xxxtoken>{S}choose{S} 			{BEGIN(0);track(NULL);return CHOOSE;}
<xxxtoken>{S}atop{S} 			{BEGIN(0);track(NULL);return ATOP;}
<xxxtoken>{S}buildrel:{S} 			{BEGIN(0);track(NULL);return BBUILDREL;}
<xxxtoken>{S}buildrel{S} 			{BEGIN(0);track(NULL);return BUILDREL;}
<xxxtoken>{S}:buildrel{S} 			{BEGIN(0);track(NULL);return EBUILDREL;}

<xxxtoken>{S}mapsto{S} 		{BEGIN(0);track(NULL);return MAPSTO;}
<xxxtoken>{S}lmapsto{S} 		{BEGIN(0);track(NULL);return LMAPSTO;}
<xxxtoken>{S}models{S} 		{BEGIN(0);track(NULL);return MODELS;}
<xxxtoken>{S}hlarrow{S} 		{BEGIN(0);track(NULL);return HLARROW;}
<xxxtoken>{S}hrarrow{S} 		{BEGIN(0);track(NULL);return HRARROW;}
<xxxtoken>{S}llarrow{S} 		{BEGIN(0);track(NULL);return lLARROW;}
<xxxtoken>{S}lrarrow{S} 		{BEGIN(0);track(NULL);return lRARROW;}
<xxxtoken>{S}Llarrow{S} 		{BEGIN(0);track(NULL);return LLARROW;}
<xxxtoken>{S}Lrarrow{S} 		{BEGIN(0);track(NULL);return LRARROW;}
<xxxtoken>{S}llrarrow{S} 		{BEGIN(0);track(NULL);return lLRARROW;}
<xxxtoken>{S}Llrarrow{S} 		{BEGIN(0);track(NULL);return LLRARROW;}
<xxxtoken>{S}bowtie{S} 		{BEGIN(0);track(NULL);return BOWTIE;}

<xxxtoken>{S}overlarrow:{S} 		{BEGIN(0);track(NULL);return BOVERLARROW;}
<xxxtoken>{S}:overlarrow{S} 		{BEGIN(0);track(NULL);return EOVERLARROW;}
<xxxtoken>{S}underlarrow:{S} 		{BEGIN(0);track(NULL);return BUNDERLARROW;}
<xxxtoken>{S}:underlarrow{S} 		{BEGIN(0);track(NULL);return EUNDERLARROW;}
<xxxtoken>{S}overrarrow:{S} 		{BEGIN(0);track(NULL);return BOVERRARROW;}
<xxxtoken>{S}:overrarrow{S} 		{BEGIN(0);track(NULL);return EOVERRARROW;}
<xxxtoken>{S}underrarrow:{S} 		{BEGIN(0);track(NULL);return BUNDERRARROW;}
<xxxtoken>{S}:underrarrow{S} 		{BEGIN(0);track(NULL);return EUNDERRARROW;}
<xxxtoken>{S}overbrace:{S} 		{BEGIN(0);track(NULL);return BOVERBRACE;}
<xxxtoken>{S}:overbrace{S} 		{BEGIN(0);track(NULL);return EOVERBRACE;}
<xxxtoken>{S}underbrace:{S} 	{BEGIN(0);track(NULL);return BUNDERBRACE;}
<xxxtoken>{S}:underbrace{S} 	{BEGIN(0);track(NULL);return EUNDERBRACE;}
<xxxtoken>{S}widehat:{S} 		{BEGIN(0);track(NULL);return BWIDEHAT;}
<xxxtoken>{S}:widehat{S} 		{BEGIN(0);track(NULL);return EWIDEHAT;}
<xxxtoken>{S}widetilde:{S} 		{BEGIN(0);track(NULL);return BWIDETILDE;}
<xxxtoken>{S}:widetilde{S} 		{BEGIN(0);track(NULL);return EWIDETILDE;}
<xxxtoken>{S}overline:{S} 		{BEGIN(0);track(NULL);return BOVERLINE;}
<xxxtoken>{S}:overline{S} 		{BEGIN(0);track(NULL);return EOVERLINE;}
<xxxtoken>{S}underline:{S} 		{BEGIN(0);track(NULL);return BUNDERLINE;}
<xxxtoken>{S}:underline{S} 		{BEGIN(0);track(NULL);return EUNDERLINE;}
<xxxtoken>{S}dot:{S} 			{BEGIN(0);track(NULL);return BDOT;}
<xxxtoken>{S}:dot{S} 			{BEGIN(0);track(NULL);return EDOT;}

<xxxtoken>{S}mo:{S} 			{BEGIN(0);track(NULL);return BMO;}
<xxxtoken>{S}:mo{S} 			{BEGIN(0);track(NULL);return EMO;}

<xxxtoken>{S}sqrt:{S} 			{BEGIN(0);track(NULL);return BSQRT;}
<xxxtoken>{S}:sqrt{S} 			{BEGIN(0);track(NULL);return ESQRT;}

<xxxtoken>{S}root:{S}			{BEGIN(0);track(NULL);return BROOT;}
<xxxtoken>{S}root{S} 			{BEGIN(0);track(NULL);return ROOT;}
<xxxtoken>{S}:root{S}			{BEGIN(0);track(NULL);return EROOT;}

<xxxtoken>{S}dmath:{S}		 	{BEGIN(0);track(NULL);return DMATHB;}
<xxxtoken>{S}:dmath{S} 			{BEGIN(0);track(NULL);return DMATHE;}
<xxxtoken>{S}imath:{S}		 	{BEGIN(0);track(NULL);return IMATHB;}
<xxxtoken>{S}:imath{S} 			{BEGIN(0);track(NULL);return IMATHE;}

<xxxtoken>{EQNO} 			{BEGIN(0);track(NULL);return EQNO;}
<xxxtoken>{LEQNO} 			{BEGIN(0);track(NULL);return LEQNO;}
<xxxtoken>{REQNO} 			{BEGIN(0);track(NULL);return REQNO;}

<xxxtoken>{S}item{S} 		{BEGIN(0);track(NULL);return Item;}
<xxxtoken>{S}list:{S} 		{BEGIN(0);track(NULL);return BList;}
<xxxtoken>{S}:list{S} 		{BEGIN(0);track(NULL);return EList;}
<xxxtoken>{S}label:{S} 		{BEGIN(0);track(NULL);return BLabel;}
<xxxtoken>{S}:label{S} 		{BEGIN(0);track(NULL);return ELabel;}

<xxxtoken>{BENTRY} 		{BEGIN(0);track(NULL);return BENTRY;}
<xxxtoken>{EENTRY} 		{BEGIN(0);track(NULL);return EENTRY;}

<xxxtoken>{BEQTAG} 		{BEGIN(0);track(NULL);return BEQTAG;}
<xxxtoken>{EEQTAG} 		{BEGIN(0);track(NULL);return EEQTAG;}
<xxxtoken>{BBINOM} 		{BEGIN(0);track(NULL);return BBINOM;}
<xxxtoken>{EBINOM} 		{BEGIN(0);track(NULL);return EBINOM;}
<xxxtoken>{BBINOMUP} 		{BEGIN(0);track(NULL);return BBINOMUP;}
<xxxtoken>{EBINOMUP} 		{BEGIN(0);track(NULL);return EBINOMUP;}
<xxxtoken>{BBINOMDOWN} 		{BEGIN(0);track(NULL);return BBINOMDOWN;}
<xxxtoken>{EBINOMDOWN} 		{BEGIN(0);track(NULL);return EBINOMDOWN;}


<xxxtoken>{S}title:{S} 		{BEGIN(0);track(NULL);return BTITLE;}
<xxxtoken>{S}:title{S} 		{BEGIN(0);track(NULL);return ETITLE;}
<xxxtoken>{S}author:{S} 		{BEGIN(0);track(NULL);return BAUTHOR;}
<xxxtoken>{S}:author{S} 		{BEGIN(0);track(NULL);return EAUTHOR;}
<xxxtoken>{S}name:{S} 		{BEGIN(0);track(NULL);return BName;}
<xxxtoken>{S}:name{S} 		{BEGIN(0);track(NULL);return EName;}
<xxxtoken>{S}cauthor:{S} 		{BEGIN(0);track(NULL);return BCAuthor;}
<xxxtoken>{S}:cauthor{S} 		{BEGIN(0);track(NULL);return ECAuthor;}
<xxxtoken>{S}comment:{S}		{BEGIN(0);track(NULL);return BComment;}
<xxxtoken>{S}:comment{S}		{BEGIN(0);track(NULL);return EComment;}
<xxxtoken>{S}date:{S} 		{BEGIN(0);track(NULL);return BDATE;}
<xxxtoken>{S}:date{S} 		{BEGIN(0);track(NULL);return EDATE;}
<xxxtoken>{S}today:{S} 		{BEGIN(0);track(NULL);return BDATE;}
<xxxtoken>{S}:today{S} 		{BEGIN(0);track(NULL);return EDATE;}
<xxxtoken>{S}thanks:{S} 		{BEGIN(0);track(NULL);return BTHANKS;}
<xxxtoken>{S}:thanks{S} 		{BEGIN(0);track(NULL);return ETHANKS;}
<xxxtoken>{S}dedicatory:{S} 		{BEGIN(0);track(NULL);return BDedicatory;}
<xxxtoken>{S}:dedicatory{S} 		{BEGIN(0);track(NULL);return EDedicatory;}
<xxxtoken>{S}url:{S} 		{BEGIN(0);track(NULL);return BURL;}
<xxxtoken>{S}:url{S} 		{BEGIN(0);track(NULL);return EURL;}
<xxxtoken>{S}email:{S} 		{BEGIN(0);track(NULL);return BEMAIL;}
<xxxtoken>{S}:email{S} 		{BEGIN(0);track(NULL);return EEMAIL;}
<xxxtoken>{S}affiliation:{S} 		{BEGIN(0);track(NULL);return BAffiliation;}
<xxxtoken>{S}:affiliation{S} 		{BEGIN(0);track(NULL);return EAffiliation;}
<xxxtoken>{S}address:{S} 		{BEGIN(0);track(NULL);return BAddress;}
<xxxtoken>{S}:address{S} 		{BEGIN(0);track(NULL);return EAddress;}
<xxxtoken>{S}caddress:{S} 		{BEGIN(0);track(NULL);return BCAddress;}
<xxxtoken>{S}:caddress{S} 		{BEGIN(0);track(NULL);return ECAddress;}

<xxxtoken>{S}Keywords:{S} 		{BEGIN(0);track(NULL);return BKeywords;}
<xxxtoken>{S}:Keywords{S} 		{BEGIN(0);track(NULL);return EKeywords;}
<xxxtoken>{S}PACS:{S} 		{BEGIN(0);track(NULL);return BPACS;}
<xxxtoken>{S}:PACS{S} 		{BEGIN(0);track(NULL);return EPACS;}
<xxxtoken>{S}SubjectClass:{S} 		{BEGIN(0);track(NULL);return BSubjectClass;}
<xxxtoken>{S}:SubjectClass{S} 		{BEGIN(0);track(NULL);return ESubjectClass;}


<xxxtoken>{S}headline:{S} 	{BEGIN(0);track(NULL);return BHEADLINE;}
<xxxtoken>{S}:headline{S} 	{BEGIN(0);track(NULL);return EHEADLINE;}
<xxxtoken>{S}footline:{S} 	{BEGIN(0);track(NULL);return BFOOTLINE;}
<xxxtoken>{S}:footline{S} 	{BEGIN(0);track(NULL);return EFOOTLINE;}

<xxxtoken>{S}Env:@pmatrix@:Begin{S} {BEGIN(0);track(NULL);}//ignore
<xxxtoken>{S}Env:@pmatrix@:End{S} {BEGIN(0);track(NULL);}//ignore
<xxxtoken>{S}Env:@split@:Begin{S} {BEGIN(0);track(NULL);}//ignore
<xxxtoken>{S}Env:@split@:End{S} {BEGIN(0);track(NULL);}//ignore
<xxxtoken>{S}Env:@aligned@:Begin{S} {BEGIN(0);track(NULL);}//ignore
<xxxtoken>{S}Env:@aligned@:End{S} {BEGIN(0);track(NULL);}//ignore
<xxxtoken>{S}Env:@gathered@:Begin{S} {BEGIN(0);track(NULL);}//ignore
<xxxtoken>{S}Env:@gathered@:End{S} {BEGIN(0);track(NULL);}//ignore
<xxxtoken>{S}Env:@equation\*?@:Begin{S} {BEGIN(0);track(NULL);}//ignore
<xxxtoken>{S}Env:@equation\*?@:End{S} {BEGIN(0);track(NULL);}//ignore
<xxxtoken>{S}Env:@eqnarray\*?@:Begin{S} {BEGIN(0);track(NULL);}//ignore
<xxxtoken>{S}Env:@eqnarray\*?@:End{S} {BEGIN(0);track(NULL);}//ignore
<xxxtoken>{S}Env:@minipage@:Begin{S} {BEGIN(0);track(NULL);}//ignore
<xxxtoken>{S}Env:@minipage@:End{S} {BEGIN(0);track(NULL);}//ignore
<xxxtoken>{S}Env:@table@:Begin{S} {BEGIN(0);track(NULL);}//ignore
<xxxtoken>{S}Env:@table@:End{S} {BEGIN(0);track(NULL);}//ignore
<xxxtoken>{S}Env:@tabular@:Begin{S} {BEGIN(0);track(NULL);}//ignore
<xxxtoken>{S}Env:@tabular@:End{S} {BEGIN(0);track(NULL);}//ignore
<xxxtoken>{S}Env:@abstract@:Begin{S} {BEGIN(0);track(NULL);}//ignore
<xxxtoken>{S}Env:@abstract@:End{S} {BEGIN(0);track(NULL);}//ignore
<xxxtoken>{S}Env:@section@:Begin{S} {BEGIN(0);track(NULL);}//ignore
<xxxtoken>{S}Env:@section@:End{S} {BEGIN(0);track(NULL);}//ignore
<xxxtoken>{S}Env:@thebibliography@:Begin{S} {BEGIN(0);track(NULL);}//ignore
<xxxtoken>{S}Env:@thebibliography@:End{S} {BEGIN(0);track(NULL);}//ignore
<xxxtoken>{S}Env:@figure\*?@:Begin{S} {BEGIN(0);track(NULL);}//ignore
<xxxtoken>{S}Env:@figure\*?@:End{S} {BEGIN(0);track(NULL);}//ignore
<xxxtoken>{S}Env:@array@:Begin{S} {BEGIN(0);track(NULL);}//ignore
<xxxtoken>{S}Env:@array@:End{S} {BEGIN(0);track(NULL);}//ignore
<xxxtoken>{S}Env:@document@:Begin{S} {BEGIN(0);track(NULL);}//ignore
<xxxtoken>{S}Env:@[^@]*@:Begin{S} 	{BEGIN(0);track(NULL);if (!mathmode) return BEnv;}
<xxxtoken>{S}Env:@[^@]*@:End{S} 	{BEGIN(0);track(NULL);if (!mathmode) return EEnv;}

<xxxtoken>{S}Abstract:{S} 	{BEGIN(0);track(NULL);return BAbstract;}
<xxxtoken>{S}:Abstract{S} 	{BEGIN(0);track(NULL);return EAbstract;}
<xxxtoken>{S}AbsLang:@[^@]*@:AbsLang{S} 	{BEGIN(0);track(NULL);return AbsLang;}
<xxxtoken>{S}:en:Abstract{S} 	{BEGIN(0);track(NULL);return EAbstract;}

<xxxtoken>{S}float:{S} {BEGIN(0);track(NULL);return BFloat;}//ignore
<xxxtoken>{S}:float{S} {BEGIN(0);track(NULL);return EFloat;}//ignore
<xxxtoken>{S}ftype:[^:]*:ftype{S} 	{BEGIN(0);track(NULL); return FType;}//ignore
<xxxtoken>{S}fopt:[^:]*:fopt{S} 	{BEGIN(0);track(NULL);return FOption;}
<xxxtoken>{S}aopt:[^:]*:aopt{S} 	{BEGIN(0);track(NULL);return AOption;}
<xxxtoken>{S}tabularx:{S} 	{BEGIN(0);track(NULL);inTable=1;return BTabularx;}
<xxxtoken>{S}:tabularx{S} 	{BEGIN(0);track(NULL);inTable=0;return ETabularx;}
<xxxtoken>{S}tabular:{S} 	{BEGIN(0);track(NULL);inTable=1;return BTabular;}
<xxxtoken>{S}:tabular{S} 	{BEGIN(0);track(NULL);inTable=0;return ETabular;}
<xxxtoken>{S}longTable:{S} 	{BEGIN(0);track(NULL);inTable=1;return BLTable;}
<xxxtoken>{S}:longTable{S} 	{BEGIN(0);track(NULL);inTable=0;return ELTable;}
<xxxtoken>{S}ltbody:{S} 	{BEGIN(0);track(NULL);inTable=1;return BLTBody;}
<xxxtoken>{S}:ltbody{S} 	{BEGIN(0);track(NULL);inTable=0;return ELTBody;}
<xxxtoken>{S}mcol:{S} 	{BEGIN(0);track(NULL);return BMultiColumn;}
<xxxtoken>{S}:mcol{S} 	{BEGIN(0);track(NULL);return EMultiColumn;}
<xxxtoken>{S}mcoln:@[^@]*@:mcoln{S} 	{BEGIN(0);track(NULL);return MultiColumnNumber;}
<xxxtoken>{S}mcolf:[^:]*:mcolf{S} 	{BEGIN(0);track(NULL);return MultiColumnFormat;}

<xxxtoken>{S}span{S} 	{BEGIN(0);track(NULL);return SPAN;}
<xxxtoken>{S}tabcr{S} 	{BEGIN(0);track(NULL);return TABCR;}
<xxxtoken>{S}hline{S} 	{BEGIN(0);track(NULL);return HLINE;}
<xxxtoken>{S}equation:{S} 	{BEGIN(0);track(NULL);mathmode=1;return DMATHB;}//BEnvEquation
<xxxtoken>{S}:equation{S} 	{BEGIN(0);track(NULL);return DMATHE;mathmode=0;}//EEnvEquation
<xxxtoken>{S}casesrow:{S} 	{BEGIN(0);track(NULL);return BCasesRow;}
<xxxtoken>{S}:casesrow{S} 	{BEGIN(0);track(NULL);return ECasesRow;}
<xxxtoken>{S}split:{S} 	{BEGIN(0);track(NULL);return BSplit;}
<xxxtoken>{S}:split{S} 	{BEGIN(0);track(NULL);return ESplit;}
<xxxtoken>{S}eqnum:{S} 	{BEGIN(0);track(NULL);return BEqNum;}
<xxxtoken>{S}:eqnum{S} 	{BEGIN(0);track(NULL);return EEqNum;}
<xxxtoken>{S}file:{S} 	{BEGIN(0);track(NULL);return Bfile;}
<xxxtoken>{S}:file{S} 	{BEGIN(0);track(NULL);return Efile;}

<xxxtoken>{S}bibliography:{S} 	{BEGIN(0);track(NULL);return BBibliography;}
<xxxtoken>{S}:bibliography{S} 	{BEGIN(0);track(NULL);return EBibliography;}

<xxxtoken>{S}foot:{S} 	{BEGIN(0); {track(NULL);return BFoot;}}
<xxxtoken>{S}:foot{S} 	{BEGIN(0); {track(NULL);return EFoot;}}
<xxxtoken>{S}head:{S} 	{BEGIN(0); {track(NULL);return BHead;}}
<xxxtoken>{S}:head{S} 	{BEGIN(0); {track(NULL);return EHead;}}
<xxxtoken>{S}page:{S} 	{BEGIN(0); {track(NULL);return BPage;}}
<xxxtoken>{S}:page{S} 	{BEGIN(0); {track(NULL);return EPage;}}

<xxxtoken>{S}sectMark:{S} 	{BEGIN(0);track(NULL);return BSectMark;}
<xxxtoken>{S}:sectMark{S} 	{BEGIN(0);track(NULL);return ESectMark;}
<xxxtoken>{S}sectType:[^:]*:sectType{S} 	{BEGIN(0);track(NULL);return SectType;}
<xxxtoken>{S}sectLabel:{S} 	{BEGIN(0);track(NULL);return BSectLabel;}
<xxxtoken>{S}:sectLabel{S} 	{BEGIN(0);track(NULL);return ESectLabel;}
<xxxtoken>{S}SECTLABEL:{S} 	{BEGIN(0);track(NULL);return BSectLabel;}
<xxxtoken>{S}:SECTLABEL{S} 	{BEGIN(0);track(NULL);return ESectLabel;}
<xxxtoken>{S}sectTitle:{S} 	{BEGIN(0);track(NULL);return BSectTitle;}
<xxxtoken>{S}:sectTitle{S} 	{BEGIN(0);track(NULL);return ESectTitle;}
<xxxtoken>{S}SECTTITLE:{S} 	{BEGIN(0);track(NULL);return BSectTitle;}//because \MakeUppercase does it in specials too :)
<xxxtoken>{S}:SECTTITLE{S} 	{BEGIN(0);track(NULL);return ESectTitle;}

<xxxtoken>{S}Background:@[^@]*@:Background{S} 	{BEGIN(0);track(NULL);return BackgroundColor;}

<xxxtoken>{S}Id:@[^@]*@:Id{S} 	{BEGIN(0);track(NULL);return Id;}
<xxxtoken>{S}caption:{S} 	{BEGIN(0);track(NULL);return BCaption;}
<xxxtoken>{S}:caption{S} 	{BEGIN(0);track(NULL);return ECaption;}
<xxxtoken>{S}ltcaption:{S} 	{BEGIN(0);track(NULL);return BLTCaption;}
<xxxtoken>{S}:ltcaption{S} 	{BEGIN(0);track(NULL);return ELTCaption;}
<xxxtoken>{S}figtag:{S} 	{BEGIN(0);track(NULL);return BFigureTag;}
<xxxtoken>{S}:figtag{S} 	{BEGIN(0);track(NULL);return EFigureTag;}
<xxxtoken>{S}figFileName:{S}[^ ]*{S}:figFileName{S} 	{BEGIN(0);track(NULL);return FigureFileName;}
<xxxtoken>{S}epsfigFileName:{S}[^ ]*{S}:epsfigFileName{S} 	{BEGIN(0);track(NULL);return EPSFigureFileName;}

<xxxtoken>{S}Sref:@[^@]*@:Sref{S} 		{BEGIN(0);track(NULL);return Ref;}
<xxxtoken>{S}Ref:{S} 		{BEGIN(0);track(NULL);return BRef;}
<xxxtoken>{S}:Ref{S} 		{BEGIN(0);track(NULL);return ERef;}
<xxxtoken>{S}citeSRef:@[^@]*@:citeSRef{S} 		{BEGIN(0);track(NULL);return CiteSRef;}
<xxxtoken>{S}citeLabel:{S} 		{BEGIN(0);track(NULL);return BCiteLabel;}
<xxxtoken>{S}:citeLabel{S} 		{BEGIN(0);track(NULL);return ECiteLabel;}
<xxxtoken>{S}cite:{S} 		{BEGIN(0);track(NULL);return BCite;}
<xxxtoken>{S}:cite{S} 		{BEGIN(0);track(NULL);return ECite;}
<xxxtoken>{S}fnmark:{S} 	{BEGIN(0);track(NULL);return BFootnoteMark;}
<xxxtoken>{S}:fnmark{S} 	{BEGIN(0);track(NULL);return EFootnoteMark;}
<xxxtoken>{S}footnote:{S} 	{BEGIN(0);track(NULL);return BFootnote;}
<xxxtoken>{S}:footnote{S} 	{BEGIN(0);track(NULL);return EFootnote;}

<xxxtoken>{S}spacing{S}	 	{BEGIN(0);track(NULL);noDVIY=1;spacing=1;}
<xxxtoken>{S}SPACING{S}	 	{BEGIN(0);track(NULL);noDVIY=1;spacing=1;}
<xxxtoken>{S}textaccent{S}	 	{BEGIN(0);track(NULL);inhibitspace=1;noDVIY=1;return TACCENT;}
<xxxtoken>{S}textaccentunder{S}	 	{BEGIN(0);track(NULL);inhibitspace=1;noDVIY=1;return TACCENTU;}
<xxxtoken>{S}mathaccent{S} 		{BEGIN(0);track(NULL);return MACCENT;}

<xxxtoken>{S}IdLine:{S}		{BEGIN(0);track(NULL);return BIdLine;}
<xxxtoken>{S}:IdLine{S}		{BEGIN(0);track(NULL);return EIdLine;}
<xxxtoken>{S}DOI:{S}		{BEGIN(0);track(NULL);return BDOI;}
<xxxtoken>{S}:DOI{S}		{BEGIN(0);track(NULL);return EDOI;}
<xxxtoken>{S}Copyright:{S}		{BEGIN(0);track(NULL);return BCopyright;}
<xxxtoken>{S}:Copyright{S}		{BEGIN(0);track(NULL);return ECopyright;}
<xxxtoken>{S}Location:{S}		{BEGIN(0);track(NULL);return BLocation;}
<xxxtoken>{S}:Location{S}		{BEGIN(0);track(NULL);return ELocation;}
<xxxtoken>{S}Journal:{S}		{BEGIN(0);track(NULL);return BJournal;}
<xxxtoken>{S}:Journal{S}		{BEGIN(0);track(NULL);return EJournal;}
<xxxtoken>{S}Logo:{S}		{BEGIN(0);track(NULL);return BLogo;}
<xxxtoken>{S}:Logo{S}		{BEGIN(0);track(NULL);return ELogo;}
<xxxtoken>{S}Branch:{S}		{BEGIN(0);track(NULL);return BBranch;}
<xxxtoken>{S}:Branch{S}		{BEGIN(0);track(NULL);return EBranch;}


<xxxtoken>{S}cr{S}			{BEGIN(0);track(NULL);return CR;}
<xxxtoken>{EndLine}			{BEGIN(0);inputlines++;}

<xxxtoken>{BMATHICS}		{BEGIN(0);track(NULL);return BMATHICS;}
<xxxtoken>{EMATHICS}		{BEGIN(0);track(NULL);return EMATHICS;}
<xxxtoken>{BICSIDX}		{BEGIN(0);track(NULL);return BICSIDX;}
<xxxtoken>{EICSIDX}		{BEGIN(0);track(NULL);return EICSIDX;}
<xxxtoken>{BICSDESC}	{BEGIN(0);track(NULL);return BICSDESC;}
<xxxtoken>{EICSDESC}	{BEGIN(0);track(NULL);return EICSDESC;}
<xxxtoken>{BMATVERW}	{BEGIN(0);track(NULL);return BMATVERW;}
<xxxtoken>{EMATVERW}	{BEGIN(0);track(NULL);return EMATVERW;}
<xxxtoken>{BMATHICSSUB}	{BEGIN(0);track(NULL);return BMATHICSSUB;}
<xxxtoken>{EMATHICSSUB}	{BEGIN(0);track(NULL);return EMATHICSSUB;}

<xxxtoken>{BMBOX}		{BEGIN(0);track(NULL);return BMBOX;}
<xxxtoken>{EMBOX}		{BEGIN(0);track(NULL);return EMBOX;}
<xxxtoken>{BFBOX}		{BEGIN(0);track(NULL);return BFBOX;}
<xxxtoken>{EFBOX}		{BEGIN(0);track(NULL);return EFBOX;}
<xxxtoken>{BTBOX}		{BEGIN(0);track(NULL);return BTBOX;}
<xxxtoken>{ETBOX}		{BEGIN(0);track(NULL);return ETBOX;}
<xxxtoken>{BPUBLISHED}		{BEGIN(0);track(NULL);return BPUBLISHED;}
<xxxtoken>{EPUBLISHED}		{BEGIN(0);track(NULL);return EPUBLISHED;}

<xxxtoken>{Trace}		{BEGIN(0);track(NULL);dropN=2;return Trace;}

<xxxtoken>{S}par{S}		{BEGIN(0);track(NULL); if (!mathmode && !noDVIY) return PAR;}
<xxxtoken>{S}space{S}		{BEGIN(0);track(NULL); return SPACE;}


<xxxtoken>ps: 		{len-=3;BEGIN(ignoreN);}//Postscript hints, ignored 
<xxxtoken>! 		{len--;BEGIN(ignoreN);}//Postscript hints, ignored 
<xxxtoken>papersize= 		{len-=strlen("papersize=");BEGIN(ignoreN);}//Postscript hints, ignored 
<xxxtoken>PSfile= 		{len-=strlen("PSfile=");BEGIN(ignoreN);}//Postscript hints, ignored 

<xxxtoken>{ANY}			{
							if (len>1){len--; yymore();}
							else{
								fprintf(stderr,"\nerror:\nthe following \\special token has been received:\n%s\nit's not yet supported, ignoring...\n",yytext);
								BEGIN(0);
							}
						}

{ANY}			{	
						if (dropN) dropN--;
						else{
							inhibitspace=0;
							return ANY;
						}
					}

%%


void push(){
	if (stack==NULL){
		stack=malloc (sizeof(struct position));
		if(stack==NULL) {perror("cannot stack the positions, exiting");exit(EXIT_FAILURE);}
		if (stack){
		(*stack).h=cur_pos.h;(*stack).v=cur_pos.v;(*stack).w=cur_pos.w;
		(*stack).x=cur_pos.x;(*stack).y=cur_pos.y;(*stack).z=cur_pos.z;
		(*stack).next=NULL;
		}
	}else{
		struct position *newstack=malloc(sizeof(struct position));
		cur_pos.next=stack;
		memcpy(newstack,&cur_pos,sizeof(struct position));
		stack=newstack;
	}
};
void pop(){
	struct position *oldstack;
	if (stack==NULL){
	perror("cannot pop from empty stack, dying");exit(EXIT_FAILURE);
	}
	if ((*stack).next){
		memcpy(&cur_pos,stack,sizeof(struct position));
		oldstack=stack;
		stack=(*oldstack).next;
		free(oldstack);
	}else{
		memcpy(&cur_pos,stack,sizeof(struct position));
		free(stack);stack=NULL;
	}
};

void clearStack(){
	struct position *temp=NULL;
	if (stack){
		while((temp=(*stack).next)){
			free(stack);stack=temp;
		}
		free(stack);stack=NULL;
	}
};


void init_pos(){
if (stack) clearStack();
cur_pos.h=0;cur_pos.v=0;cur_pos.w=0;
cur_pos.x=0;cur_pos.y=0;cur_pos.z=0;
cur_pos.next=NULL;
};


void track(char* tokenString){
	if (DEBUG){
		if (tokenString) strcpy(lastToken,tokenString);
		else	strcpy(lastToken,yytext);
	}
}
