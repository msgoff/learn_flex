/*
Hermes bison grammar version 0.9.12, 2006-11-12
author Romeo Anghelache http://romeo.roua.org
released under GNU GPL
*/

%{

#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
#include <string.h>
#include <ctype.h>
const char * VERSION="0.9.12";
const char * DATE="2006-10-06";
const char * DESCRIPTION="http://hermes.roua.org/";
extern char* yytext;
extern FILE* yyin;
extern FILE* yyout;
extern int yylex();
int yyerror(char*msg);
void showcontext();
int BigEndian=0; 
#define LIMIT 100000
#ifdef WIN32
#pragma warning(disable : 4996)
#define _CRT_SECURE_NO_DEPRECATE
#endif
void p(char*s);
struct{
	unsigned int mag;
	unsigned int num;
	unsigned int den;
}scale;

int DEBUG=0;
int INFER_CONTENT=0;
int maxFontNr=0;
int fakesp=1;
int inhibitspace=0;
char *doc_math;
char *doc_text;
int mathText=0;
int mathOp=0;
int pHints=1;//switch for presentation hints (welformedness-glue)
int pHint=0;//set if a pHint is opened
extern int spacing;	//choose modifier/combining version
int hasSections=0;
int inBibliography=0;
int inCitation=0;
int length=0;
char fname[512];
extern char lastToken[512];//last token received before an error happens
extern void clearStack();
extern int inputlines;
int mathmode=0;		//if in text it's 0
int mathblock=0;	//'display mode' flag
int mathBox=0;		//set if inside a math box
int infhp=0;			//inside footer or header
int mDelimiter=0;	//a manual left or right, e.g. \left] 
#define DEPTH 10 //max depth level of a (m)table cell containing parenthesized math
signed int Wraps[DEPTH];	//number of parentheses currently open at the current depth level
unsigned int depth=0;	//depth level of a mtable cell containing parenthesized math
void wrap(int open);	//pop phantom parentheses to keep the math cell well-formed

int decorated=0;	//set if an operator is sup/sub'ed
unsigned int blockthis=0xFFFF;//use this to stop TeX construction of big delimiters
int canbreak=1;
int noDVIY=0;
int inTable=0;
char id[512]="";
char label[512]="";
char* content(char*from,char*what, char*bas, char*eas);
void InferContent();
void printFigureFileName();
void printEPSFigureFileName();
void printEnvType();
void printId();
void printOption();
void printFType();
void printAbsLang();
void printBkgColor();
void printRef();
void printSectType();
void printCiteSRef();

char* Insert(char*at,char*what);
char* MatchTagLeft(char*from, char*what);
char* MatchTagRight(char*from);
char* SkipBracketsLeft(char*from);
char* SkipBracketsRight(char*from);
char* MoveLeft(char*where,char*temp);
char* IndentContainer(char*pos,int* spaces,int start);
int IsMMLContainerEnd(char*at);
int IsMMLContainerStart(char*at);
int IsMMLConstant(char*at);
void flushMath();
void flushText();
void AddPHint(int StartOrEnd);
void Clean(char*from,char*what,int how);
void pretty(char*s,int eraseBrackets);
void die(char* text);
void fixIds();
void fixLabels();
void fixBackParsedPrimitive(const char* what);

//font mapping
int fontsMissing=0;

//encodings from ftp://tug.ctan.org/pub/tex-archive/info/fontname/fontname.html
void mapFonts(int check);
void fontMap7t();	//OT1+
void fontMap7tp();	//OT1+ (pound for dollar)
void fontMap7tt();	//OT1+
void fontMap7ttp();	//OT1+ (pound for dollar)
void fontMap8a();//standard
void fontMapDvips();
void fontMap8r();//TeXBase1
void fontMap8t();//Cork
void fontMap8c();//TS1
void fontMap8q();
void fontMap8y();//TeXnANSI
void fontMap8z();//OT1+ISO Latin2, XL2
void fontMap8u();//OT1+ISO Latin2 typewriter, XT2
void fontMapMathExt();
void fontMapMathExtA();
void fontMapMathSymbol();//msy
void fontMapMathSymbolC();
void fontMapCmTeX();
void fontMapMathItalic();//mi
void fontMapMathItalicA();
void fontMapMsam();//AMSa
void fontMapMsbm();//AMSb
void fontMapLasy();
void fontMapWasy();
void fontMap7c();//fraktur

struct _Font{
	void (*map)();
	unsigned int number;
	char name[10];
	char size[3];
	
	enum{
		serif,
		sans,
		monospace,
		cursive,
		fantasy,
		fraktur,
		doubleStruck, 
	}family;
	
	enum{
		normal,
		smallCaps
	}variant;
	
	enum{
		upright,
		italic, 
		oblique
	}style;
	
	enum{
		hairline, 				//a
		extraLight, 			//j
		light, 						//l
		book, 						//k
		normalWeight, 		//r
		medium,						//m
		demiBold, 				//d
		semiBold, 				//s
		bold, 						//b
		extraBold, 				//x
		heavy, 						//h
		black, 						//c
		ultraBlack, 			//u
		poster						//p
	}weight;
	
	enum{
		ultraCompressed,	//u
		ultraCondensed, 	//o
		extraCondensed, 	//q
		compressed, 			//p
		condensed,				//c
		thin, 						//t
		narrow, 					//n
		regularWidth, 		//r
		extended, 				//x
		expanded, 				//e
		extraExpanded, 		//v
		wide 							//w
	}width;

}theFont;

struct _Font (*pFont)[];
void selectFont(unsigned int fnum);

unsigned int combiningUnicode=0;
void saveAccent(char accent);
void saveAccentUnder(char accent);
char* ul2utf8(unsigned int unicode);
void pmt(unsigned int unicode);
void precomposedNegative(unsigned int single, unsigned int composed);
enum{
	mi, //presentation math identifier -> <mi> default variant
	mo,			////presentation math operatorr -> <mo> normal variant
	mn,			//<mn>
	ld,			//left delimiter
	rd,			//right delimiter
	ld_b,		//left delimiter begin (bigg  delimiters)
	rd_b,
	ld_x,		//left delimiter extend (bigg)
	rd_x,
	ld_e,		//left delimiter end	(bigg)
	rd_e
}pMathType;





void beginSuperScript();
void beginSubScript();
void endSubScript();
void endSuperScript();
void endover();
void endMAccent();
void fixDigits();
void contractTextAccent();
int hbrace=0;
%}

%token		ANY SET END

%token		DVIY PAR FontChange SPACE

%token		CR BLeft ELeft BRight ERight LeftNull RightNull
%token 		BTBOX ETBOX BMBOX EMBOX BFBOX EFBOX BPUBLISHED	EPUBLISHED 
%token		BMATHICS	EMATHICS BICSIDX	EICSIDX	BICSDESC	EICSDESC BMATVERW EMATVERW	BMATHICSSUB	EMATHICSSUB 
%token		BackgroundColor
%token		POST_POST
%token		BENTRY EENTRY 
%token 		BTITLE ETITLE BAUTHOR EAUTHOR BName EName BDATE EDATE BTHANKS ETHANKS MAKETITLE
%token		BComment EComment BCAuthor ECAuthor BSubjectClass ESubjectClass BDedicatory EDedicatory
%token 		BURL EURL BEMAIL EEMAIL BAffiliation EAffiliation BAddress EAddress BCAddress ECAddress
%token 		BKeywords EKeywords BPACS EPACS
%token 		BIdLine EIdLine BDOI EDOI BCopyright ECopyright BLocation ELocation BJournal EJournal BLogo ELogo BBranch EBranch

%token 		BEQTAG EEQTAG
%token 		BBINOM EBINOM BBINOMUP EBINOMUP	BBINOMDOWN EBINOMDOWN
%token		BHEADLINE EHEADLINE BFOOTLINE EFOOTLINE
%token		BEnv EEnv BAbstract EAbstract AbsLang
%token		Item BList EList BLabel ELabel
%token		BBibliography EBibliography BBibLabel EBibLabel 
%token		BSectMark ESectMark SectType BSectLabel ESectLabel BSectTitle ESectTitle
%token		BCaption ECaption BFigureTag EFigureTag FigureFileName EPSFigureFileName
%token		Id BRef Ref ERef BCite ECite BCiteLabel ECiteLabel CiteSRef
%token		BFootnoteMark EFootnoteMark BFootnote EFootnote
%token		BFloat EFloat FType 
%token		BTabular ETabular BTabularx ETabularx FOption AOption BLTable ELTable BLTBody ELTBody BLTCaption ELTCaption 
%token		TABCR HLINE SPAN BMultiColumn EMultiColumn MultiColumnNumber MultiColumnFormat
%token		TACCENT TACCENTU MACCENT 
%token		BIGSQCUP BIGSQCAP
%token		IMATHB IMATHE DMATHB DMATHE 
%token		Bfile Efile
%token		EQNO LEQNO REQNO BEqNum EEqNum BFoot EFoot BHead EHead BPage EPage
%token		ALIGN BMTABLE EMTABLE BARRAY EARRAY BEqnArray EEqnArray BAligned EAligned BAlign EAlign BEQALIGN EEQALIGN 
%token		BSplit ESplit 

%token		BSP ESP BPower Power EPower
%token		BSB ESB SBCHAR

%token		LT GT NEQ

%token		ARCCOS ARCSIN ARCTAN ARG COS COSH COT COTH CSC DEG
%token		DET DIM EXP GCD HOM INF KER LG LIM LIMINF LIMSUP LN LOG
%token		MAX MIN PR SEC SIN SINH SUP TAN TANH
%token		CDOTS DDOTS LDOTS VDOTS
%token		BFRAC FRACN FRACD EFRAC OVER CHOOSE ATOP BBUILDREL BUILDREL EBUILDREL
%token		MAPSTO LMAPSTO MODELS HLARROW HRARROW lLARROW LLARROW lRARROW LRARROW lLRARROW LLRARROW BOWTIE
%token		BOVERLARROW EOVERLARROW BOVERRARROW EOVERRARROW 
%token		BUNDERLARROW EUNDERLARROW BUNDERRARROW EUNDERRARROW 
%token		BOVERBRACE EOVERBRACE BUNDERBRACE EUNDERBRACE 
%token		BWIDEHAT EWIDEHAT BWIDETILDE EWIDETILDE 
%token		BDOT EDOT BOVERLINE EOVERLINE BUNDERLINE EUNDERLINE 
%token		BMO EMO
%token		BSQRT SQRT ESQRT BROOT ROOT EROOT BRoot Root ERoot BSqrt ESqrt

/****** MathML content TeX macros ******/

/* arbitrary functions */
%token		Bfunc Bfarg Efarg Efunc

/* basic elements */
%token		BInterval Interval EInterval	BCompose Compose ECompose BInverse Inverse EInverse Ident
%token		BDomain EDomain	BCodomain ECodomain	BImage EImage
%token		BAmsCases EAmsCases BCases ECases BCasesRow ECasesRow

/*new elements*/
%token		BBra EBra BKet EKet NOTIN

/*	arithmetic, algebra, logic	*/
%token		BPlus Plus EPlus BMinus Minus EMinus BTimes Times ETimes

%token 	BQuotient Quotient EQuotient
%token 	BFactorial Factorial EFactorial
%token 	BFrac Fracn Fracd EFrac
%token 	BMaxl BMaxc EMaxl EMaxc BVar EVar BCond ECond	BExpr EExpr BMinl BMinc EMinl EMinc
%token	BRem Rem ERem REM BPMOD EPMOD BGcd EGcd BLcm ELcm LCM BRe ERe BIm EIm
%token	AND BLand Land ELand OR BLor Lor ELor XOR BXor Xor EXor BNot ENot BImplies Implies EImplies


%token	BForall EForall	BAssert EAssert BExists EExists

%token	Babs Eabs
%token	Bconjugate Econjugate BArg EArg	Bfloor Efloor Bceil Eceil
%token	BFactor Factor EFactor

/* relations */
%token		BEqual Equal EEqual BNequal Nequal ENequal BLequal Lequal ELequal BGequal Gequal EGequal
%token		BEquiv Equiv EEquiv BApprox Approx EApprox BGthan Gthan EGthan BLthan Lthan ELthan

/* 	calculus and vector calculus 	*/
%token BInt EInt BIntll EIntll BIntul EIntul BIntarg EIntarg BIntbe EIntbe
%token BDiff EDiff BDiffbe EDiffbe BDiffdeg EDiffdeg BDiffarg EDiffarg
%token BDivs BDivt EDiv BGradt BGrads EGrad BCurlt BCurls ECurl BLaplacian ELaplacian

/*	sequences and series	*/
%token BSum ESum BSumll ESumll BSumul ESumul BSumarg ESumarg
%token BProd EProd BProdll EProdll BProdul EProdul BProdarg EProdarg
%token BLimit ELimit BLimitarg ELimitarg BTendsto Tendsto ETendsto

/* set theory	*/
%token BSetl ESetl BSetc ESetc
%token BSubset Subset ESubset BSubseteq Subseteq ESubseteq
%token BNotsubset Notsubset ENotsubset BNotsubseteq Notsubseteq ENotsubseteq
%token BListl EListl BListcarg EListcarg BListc EListc
%token BUnion Union EUnion BIntersect Intersect EIntersect BIn In EIn BNotin Notin ENotin
%token BSetdiff Setdiff ESetdiff BCard ECard BCartesian Cartesian ECartesian

/* elementary functions	*/
%token BSin ESin BCos ECos BTan ETan BSec ESec BCsc ECsc BCot ECot
%token BSinh ESinh BCosh ECosh	BTanh ETanh BSech Sech ESech BCsch Csch ECsch BCoth ECoth

%token BArccos EArccos BArccosh Arccosh EArccosh BArcsin EArcsin BArctan EArctan
%token BArccot Arccot EArccot BArccoth Arccoth EArccoth
%token BArccsc Arccsc EArccsc BArccsch Arccsch EArccsch BArcsec Arcsec EArcsec
%token BArcsech Arcsech EArcsech BArcsinh Arcsinh EArcsinh BArctanh Arctanh EArctanh
%token BLn ELn BLog ELog BLg ELg BExp EExp


/* statistics	*/

%token BMean EMean BSDev ESDev BVariance Variance EVariance
%token BMedian Median EMedian BMode Mode EMode
%token BMoment EMoment BMomentDeg EMomentDeg BMomentArg EMomentArg BMomenta EMomenta BMabout EMabout

/*	linear algebra	*/
%token BMATRIX EMATRIX BVector EVector BMatrix EMatrix BTranspose ETranspose BDet EDet
%token BSelector SelectorMatrix ESelector
%token BVectorProduct VectorProduct EVectorProduct
%token BScalarProduct ScalarProduct EScalarProduct
%token BOuterProduct OuterProduct EOuterProduct


/*	constants	*/
%token Integers Naturals Rationals Reals Complexes Primes EPrimes
%token ExponentialE ImaginaryI NotANumber True False Emptyset PiCst EulerGamma Infty HBar

/*	extras	*/
%token Trace

%left CR ALIGN 

%%

Document: document END {flushText();};

document: |	document input ;


input:
	environment
	| 	
	BAbstract {
	 	AddPHint(0);
	 	p("<abstract>\n");
	 	AddPHint(1);
	 	} 
	 	document {
	 	AddPHint(0);
	 	p("</abstract>\n");
	 	AddPHint(1);
	 	} 
 	EAbstract
	|
	AbsLang {
			printAbsLang();
		} 
	| 
	BRef {AddPHint(0);pHints=0;noDVIY=1;p("<ref>");} 
		Ref  {printRef();p("<pref>");} 
		document 
	ERef {p("</pref></ref>");noDVIY=0;pHints=1;AddPHint(1);}
	|
	BEqNum {p("<label>");mathText=1;}
		document
	EEqNum {mathText=0;p("</label>");}
	|
	BCite
		{AddPHint(0);pHints=0;inCitation=1;p("<cite>");}
		CiteSRef {printCiteSRef();}
		citelabels
	ECite {p("</cite>");pHints=1;AddPHint(1);inCitation=0;}
	| 
		BSectMark 
			{
				AddPHint(0);noDVIY=1;
				if (!hasSections)	hasSections=1;
				else p("</section>\n");
				p("<section>\n");
			} 
		sectionmark 
		ESectMark {noDVIY=0;AddPHint(1);} 
	|
		Id {AddPHint(0);printId();AddPHint(1);} 
	|
		BackgroundColor {printBkgColor();} 
	| 
	BBibliography 
		{
		AddPHint(0);
		p("\n<bibliography>\n");
		AddPHint(1);
		inBibliography=1;} 
		document 
	EBibliography 
		{
		AddPHint(0);
		p("\n</bibliography>\n");
		AddPHint(1);
		inBibliography=0;
		}
	| 
		Item {AddPHint(0);p("\n</item>\n<item>");AddPHint(1);}
	| 
		BList {noDVIY=1;AddPHint(0);p("\n<list>\n");} optId Item
			{p("\n<item>\n");AddPHint(1);noDVIY=0;} 
			document 
		EList 
			{AddPHint(0);p("\n</item>\n</list>\n");AddPHint(1);}
	|
		BLabel
			{AddPHint(0);p("<label>\n");AddPHint(1);} 
			document 
		ELabel 
			{AddPHint(0);p("\n</label>\n");AddPHint(1);}
	| 
		BMBOX 
			{if (mathmode && !mathOp) {mathBox++;mathText=1;p("<mtext>");}} 
		document 
			{if (mathmode && !mathOp) {p("</mtext>");mathBox--;mathText=0;}} 
		EMBOX 
	
	| fhp  
	| text
	| math  {AddPHint(0);flushText(); if(!mathBox) flushMath();AddPHint(1);} 
	| caption
	| IMATHB {if (!mathBox) {mathmode=0;mathText=0;}} IMATHE
	| Bfile {pHints=0;p("<file>");} document Efile {p("</file>");pHints=1;} 
	| BUNDERLINE 
			{mathmode=0;mathText=0;AddPHint(0);p("<underline>");AddPHint(1);} 
		document 
		EUNDERLINE 
			{AddPHint(0);p("</underline>");AddPHint(1);} 
	| ltable
	| tabular
	| IMATHB mathmode_off tabular document IMATHE
	| footnote 
	| figureTag
	| FigureFileName {printFigureFileName();}
	| EPSFigureFileName {printEPSFigureFileName();}
	| float
	| mcol
;

float: 
	BFloat {AddPHint(0);p("<float>\n");}
	FType {printFType();}
	optFOption {AddPHint(1);}
	document
	EFloat {AddPHint(0);p("</float>\n");AddPHint(1);}
;


optId: | 
		Id {
			AddPHint(0);
			if (inBibliography) {
				p("\n</item>\n<item>");
			}
			printId();
			AddPHint(1);
		}
;

environment:
	BEnv
		{AddPHint(0);p("<env>\n");printEnvType();AddPHint(1);}
		document
	EEnv
		{AddPHint(0);p("</env>\n");AddPHint(1);}
;

sectionmark:
	SectType	{printSectType();AddPHint(1);}
	optId
	BSectLabel	
		label
	ESectLabel	
	BSectTitle	{AddPHint(0);p("<title>");AddPHint(1);} 
		document
	ESectTitle	{AddPHint(0);p("</title>");noDVIY=1;} 
;

label: |	
	{AddPHint(0);p("<label>");AddPHint(1);noDVIY=1;}  
	document input 
	{AddPHint(0);p("</label>");AddPHint(1);noDVIY=1;} 
;

footnote:	
	BFootnoteMark  
		{canbreak=0; AddPHint(0);pHints=0;p("<fnmark>");} 
	document 
	EFootnoteMark 
		{p("</fnmark>\n");pHints=1;AddPHint(1);canbreak=1;} 
	|
	BFootnote mathmode_off 
		{canbreak=0;AddPHint(0);p("<footnote>");AddPHint(1);}  
	document 
	EFootnote 
		{AddPHint(0);p("\n</footnote>\n");AddPHint(1);canbreak=1;} 
;


caption: 
	BCaption
	{mathmode=0;pHints=1;AddPHint(0);canbreak=0;p("\n<caption>\n");AddPHint(1);} 
	document 
	ECaption 
	{AddPHint(0);p("\n</caption>\n");noDVIY=0;canbreak=1;AddPHint(1);}
;

figureTag: 
	BFigureTag 
	document 
	EFigureTag
;

ltable: 
	BLTable 		
	ltcore 
	ELTable
;

ltcore:
	ltcaption optId CR 
		{AddPHint(0);inTable=1;p("<tabular>\n");} 
		tcore 
		{p("</tabular>\n");AddPHint(1);inTable=0;}
	|
	ltcore ltcaption optId CR 
		{AddPHint(0);inTable=1;p("<tabular>\n");}  
		tcore 
		{p("</tabular>");AddPHint(1);inTable=0;}
;

ltcaption: 
	BLTCaption
	{pHints=1;AddPHint(0);canbreak=0;p("\n<caption>\n");AddPHint(1);} 
	document 
	ELTCaption 
	{AddPHint(0);p("\n</caption>\n");canbreak=1;AddPHint(1);}
;


tabular:	
	BTabular 
	{AddPHint(0);inTable=1;noDVIY=1;p("<tabular>\n");} 
	IMATHB BARRAY optAOption tcore EARRAY IMATHE 
	ETabular 
	{p("</tabular>\n");AddPHint(1);inTable=0;noDVIY=0;} 
	|
	BTabularx {AddPHint(0);inTable=1;noDVIY=1;p("\n<tabular>\n");} 
	IMATHB	mathmode_off optAOption 
	tcore 
	{p("\n</tabular>\n");AddPHint(1);inTable=0;noDVIY=1;} IMATHE ETabularx mathmode_off {noDVIY=0;} 
	 
;


optFOption:| FOption{printOption();}
;

optAOption:| AOption{printOption();}
;


tcore: 
	xrow 
	| 
	tcore  xrow 
;

xrow: 
	HLINE CR CR 
	| 
	HLINE CR 
	| 
	{p("<tr>\n<td>");pHints=1;AddPHint(1);noDVIY=0;} row {AddPHint(0);p("\n</td>\n</tr>\n");noDVIY=1;}
;


row: ecell
	|
	cells ecell
;

cells: cell | cells cell ;

cell:document ALIGN {AddPHint(0);p("\n</td>\n<td>\n");AddPHint(1);}
;

ecell: document  CR
;


mcol: BMultiColumn MultiColumnNumber MultiColumnFormat document EMultiColumn 
;

text:
	accent
	| ANY {theFont.map();}
	| SBCHAR {p("_");inhibitspace=1;}
	| DVIY {fakesp=0;p("<dviy/>");}
	| headline
	|	SET ANY { theFont.map();}
	| SPACE {p(" ");}
	| 
	BMATHICS 
			{AddPHint(0);pHints=0;p("<ics>");} 
		document 
			{p("</ics>");pHints=1;AddPHint(1);}
	EMATHICS
	| 
	BMATVERW 
		{AddPHint(0);p("<matverw>");AddPHint(1);} 
		document 
		{AddPHint(0);p("</matverw>\n");AddPHint(1);}
	EMATVERW 
	| 
	BMATHICSSUB 
		{AddPHint(0);p("<zwigeb>\n");AddPHint(1);} 
		document 
		{AddPHint(0);p("</zwigeb>\n");AddPHint(1);}
	EMATHICSSUB 
	| 
	BAUTHOR {
		canbreak=0;	mathmode=0;AddPHint(0);
		p("\n<author>");
		AddPHint(1);
		} 
		document {
		AddPHint(0);
		p("\n</author>");canbreak=1;
		AddPHint(1);
		} 
	EAUTHOR 
	| 
	BCAuthor {mathmode=0;
		canbreak=0;	AddPHint(0);
		p("<cauthor>\n");
		AddPHint(1);
		} 
		document {
		AddPHint(0);
		p("</cauthor>\n");canbreak=1;
		AddPHint(1);
		}
	ECAuthor
	| 
	BENTRY 
		{AddPHint(0);canbreak=0;p("<number>\n");AddPHint(1);} 
		document 
		{AddPHint(0);p("</number>\n");canbreak=1;AddPHint(1);} 
	EENTRY
	| 
	BTBOX 
		{AddPHint(0);p("");AddPHint(1);} 
		document 
		{AddPHint(0);p("");AddPHint(1);} 
	ETBOX 
	| 
	BPUBLISHED 
		{mathmode=0;AddPHint(0);p("<published>");AddPHint(1);} 
		document 
		{AddPHint(0);p("</published>\n");AddPHint(1);} 
	EPUBLISHED 
	| 
	BComment 
		{AddPHint(0);p("<comment>\n");AddPHint(1);} 
		document 
		{AddPHint(0);p("</comment>\n");AddPHint(1);} 
	EComment
	| 
	PAR 
		{AddPHint(0);p("");AddPHint(1);}
	| 
	BTITLE 
		{mathmode=0;canbreak=0;AddPHint(0);p("\n<title>");AddPHint(1);} 
		document 
		{AddPHint(0);p("</title>\n");canbreak=1;AddPHint(1);}
	ETITLE 
	| 
	BDATE {mathmode=0;
		AddPHint(0);p("\n<date>");AddPHint(1);} 
		document 
		{AddPHint(0);p("</date>");	AddPHint(1);} 
	EDATE 
	| 
	BSubjectClass
		{AddPHint(0);p("<subjectClass>");AddPHint(1);} 
		document 
		{AddPHint(0);p("</subjectClass>\n");AddPHint(1);} 
	ESubjectClass  
	|
	BDedicatory
		{AddPHint(0);p("<dedicatory>");AddPHint(1);} 
		document 
		{AddPHint(0);p("</dedicatory>\n");AddPHint(1);} 
	EDedicatory
	| 
	BTHANKS 
		{AddPHint(0);p("<thanks>");AddPHint(1);} 
		document 
		{AddPHint(0);p("</thanks>\n");AddPHint(1);} 
	ETHANKS  
	| 
	BURL 
		{mathmode=0;canbreak=0;AddPHint(0);pHints=0;p("<vaddress>");} 
		document 
		{canbreak=1;p("</vaddress>\n");pHints=1;AddPHint(1);} 
	EURL
	| 
	BEMAIL 
		{mathmode=0;canbreak=0;AddPHint(0);pHints=0;p("<email>");} 
		document 
		{canbreak=1;p("</email>\n");pHints=1;AddPHint(1);} 
	EEMAIL
	| 
	BAffiliation 
		{mathmode=0;AddPHint(0);p("<affiliation>");AddPHint(1);} 
		document 
		{AddPHint(0);p("</affiliation>");AddPHint(1);} 
	EAffiliation
	| 
	BAddress
		{mathmode=0;AddPHint(0);p("<address>");AddPHint(1);} 
		document 
		{AddPHint(0);p("</address>");AddPHint(1);} 
	EAddress
	| 
	BCAddress
		{mathmode=0;AddPHint(0);p("<caddress>");AddPHint(1);} 
		document 
		{AddPHint(0);p("</caddress>");AddPHint(1);} 
	ECAddress
	| 
	IMATHB BAUTHOR 
		{
		mathmode=0;canbreak=0;AddPHint(0);
		p("\n<author>");	AddPHint(1);
		} 
		document 
		{
		AddPHint(0);p("\n</author>");
		canbreak=1;AddPHint(1);
		} 
	EAUTHOR IMATHE 
	|
	BName
		{
		mathmode=0;canbreak=0;AddPHint(0);
		p("\n<name>");	AddPHint(1);
		} 
		document 
		{
		AddPHint(0);p("</name>");
		canbreak=1;AddPHint(1);
		} 
	EName
	| 
	FontChange {AddPHint(0);AddPHint(1);}
	|
	BKeywords 
		{AddPHint(0);pHints=0;p("<keywords>");}
	document 
		{p("</keywords>");pHints=1;AddPHint(1);} 
	EKeywords
	|
	BPACS 
		{AddPHint(0);pHints=0;p("<PACS>");}
	document 
		{p("</PACS>");pHints=1;AddPHint(1);} 
	EPACS
	|
	BIdLine
		{AddPHint(0);p("<idline>");AddPHint(1);}
	document 
		{AddPHint(0);p("</idline>");AddPHint(1);} 
	EIdLine
	|
	BDOI
		{AddPHint(0);pHints=0;p("<doi>");}
	document 
		{p("</doi>");pHints=1;AddPHint(1);} 
	EDOI
	|
	BCopyright
		{pHints=1;AddPHint(0);p("\n<copyright>");AddPHint(1);}
	document 
		{pHints=1;AddPHint(0);p("</copyright>\n");AddPHint(1);} 
	ECopyright
	|
	BLocation
		{AddPHint(0);pHints=0;p("<location>");}
	document 
		{p("</location>");pHints=1;AddPHint(1);} 
	ELocation
	|
	BJournal
		{AddPHint(0);p("<journal>");AddPHint(1);}
	document 
		{AddPHint(0);p("</journal>");AddPHint(1);} 
	EJournal
	|
	BLogo
		{pHints=1;AddPHint(0);p("<logo>");AddPHint(1);}
	document 
		{AddPHint(0);p("</logo>");pHints=1;AddPHint(1);} 
	ELogo
	|
	BBranch
		{pHints=1;AddPHint(0);p("\n<branch>");AddPHint(1);}
	document 
		{AddPHint(0);p("</branch>\n");pHints=1;AddPHint(1);} 
	EBranch
	|
	BFBOX {p("<fbox>");} document {p("</fbox>");} EFBOX 
;

headline:
	BHEADLINE 
		{AddPHint(0);p("<headline>");AddPHint(1);} 
		document 
		{AddPHint(0);p("</headline>");AddPHint(1);} 
	EHEADLINE
	|
	BFOOTLINE 
		{AddPHint(0);p("<footline>");AddPHint(1);} 
		document 
		{AddPHint(0);p("</footline>");AddPHint(1);} 
	EFOOTLINE
;

fhp:
	BFoot {
		mathmode=0;infhp=1;p("<foot>");
	} headerfooter 
	EFoot {
		p("</foot>");infhp=0;
	} 
	| 
	BHead {
		mathmode=0;infhp=1;p("<head>");
	} headerfooter 
	EHead {
		p("</head>");infhp=0;
	}
	| 
	BPage {
		mathmode=0;pHints=0;	infhp=1;	p("<page nr=\"");
	} document 
	EPage {
		p("\"/>");infhp=0;pHints=1;
	}
;


headerfooter:
	| text headerfooter
	| 
	BPage 
		{mathmode=0;pHints=0; canbreak=0;infhp=1;p("<page nr=\"");} 
		document 
		{p("\"/>");canbreak=1;infhp=0;pHints=1;}  
	EPage 
	headerfooter 
;

citelabels: | BCiteLabel {p("<pref>");} document ECiteLabel {p("</pref>");} citelabels
;


dvi:	| dvi DVIY {fakesp=0;p("<dviy/>");}
;


accent: TACCENT happenings ANY {saveAccent(*yytext);} text {contractTextAccent();inhibitspace=0;noDVIY=0;}
			| TACCENT happenings SET ANY {theFont.map();inhibitspace=0;noDVIY=0;}
			| TACCENTU text ANY {saveAccentUnder(*yytext);contractTextAccent();inhibitspace=0;noDVIY=0;} 
			| MACCENT happenings ANY {saveAccent(*yytext);} text {contractTextAccent();inhibitspace=0;}
;

happenings:
	| 
	BLabel 
		{AddPHint(0);p("\n<label>");AddPHint(1);} 
		document 
		{AddPHint(0);p("</label>\n");pHints=1;AddPHint(1);} 
	ELabel 
	|	FontChange {AddPHint(0);AddPHint(1);} 
;

mathmode_on:{
	if (mathBox && mathText) {p("</mtext>"); mathText=0;} 
	mathmode=1;
	}
;
mathmode_off:{ 
	if (mathBox) {p("<mtext>"); mathText=1;}
	else mathmode=0;
	}
;

math:	IMATHB mathmode_on  {mathblock=0;} phints
			formula 
		IMATHE mathmode_off 
		| 
		DMATHB mathmode_on  {mathblock=1;} phints
			formula 
		DMATHE {if (Wraps[depth]) wrap(0); Wraps[depth]=0;} mathmode_off 
		| ams_align
		| mtable
		| eqnarray
		| mathArray
		| align
;


phints: |FontChange {AddPHint(0);AddPHint(1);};
ams_align: 
		DMATHB mathmode_on {mathblock=1;} CR  {p("<mtr><mtd>");} optheadline
		cams_align 
		CR optheadline DMATHE {p("</mtd></mtr>");} mathmode_off  
;


optheadline:| mathmode_off headline mathmode_on optheadline ;
cams_align: amscells  
	| cams_align CR optheadline {p("</mtd></mtr><mtr><mtd>");}  cams_align 
;
amscells:
	optEqno IMATHB expression optalign IMATHE optEqno
	|
	amscells IMATHB expression optalign IMATHE optEqno ;

optalign:| ALIGN {p("</mtd><mtd>");}|CR;


optEqno:|phints eqno ;

eqno:
		 BEqNum  {p("<label>");mathText=1;} document {mathText=0;p("</label>");} EEqNum 
;

expression:  | formula ;
formula:
		 mtext expression 
		| ops expression
		| function expression
		| 
		IMATHB 	{if (mathBox) {p("<mtext>"); mathText=1;}}
			expression 
		IMATHE 	{if (mathBox && mathText) {p("</mtext>"); mathText=0;}}
		expression
		| DMATHB expression DMATHE expression
		| eqno expression
		| eqtags expression
		| mathML_content expression
		| BFoot {mathmode=0;p("<foot>");} headerfooter EFoot {p("</foot>");mathmode=1;} expression
		| BHead {mathmode=0;p("<head>");} headerfooter EHead {p("</head>");mathmode=1;}  expression
		| BPage {mathmode=0;pHints=0;p("<page nr=\"");} document EPage {p("\"/>");mathmode=1;}  expression
		| mtable expression
		| eqalign expression
		| extensions expression
		| mathmode_off headline mathmode_on expression
		| mathmode_off footnote mathmode_on expression
		| BLeft {mDelimiter=1;p("<mrow>");} 
				expression 
			ELeft {blockthis=0xFFFF;p("<mrow>");mDelimiter=0;Wraps[depth]++;} 
			expression 
		|	BRight {mDelimiter=1;mathmode=1;p("</mrow>");} 
				expression 
			ERight {blockthis=0xFFFF;p("</mrow>");mDelimiter=0;if (Wraps[depth]==0) wrap(-1); else Wraps[depth]--; } 
			expression
		| eqnarray expression
		| align expression
		| aligned expression
		| mathArray expression
		| matrix expression
		| split expression
		| BSP ESP  expression //ignoring vphantoms
		| BSB ESB  expression //ignoring vphantoms
		| Id {printId();} expression
		| OVER {p("<OVER/>");} expression
		| CHOOSE {p("<CHOOSE/>");} expression
		| ATOP {p("<ATOP/>");} expression
		| DVIY expression
		| mcol
;

split: 
		BSplit	split_in_align
		{p("<mtable><mtr>");depth++;}
		almtcore  
  	ESplit {p("</mtr></mtable>");depth--;}
;

split_in_align: | ALIGN IMATHE IMATHB
;


extensions:		BBINOM BBINOMUP {p("<mfrac linethickness=\"0\"><mrow>");} formula EBINOMUP	{p("</mrow><mrow>");} BBINOMDOWN formula EBINOMDOWN {p("</mrow></mfrac>");} EBINOM 
		| BBra ANY {pMathType=ld;pmt(0x2329);} formula EBra ANY {pMathType=rd;pmt('|');}
		| BKet ANY {pMathType=ld;pmt('|');} formula EKet ANY {pMathType=rd;pmt(0x232A);}
		| BPMOD {pMathType=ld;pmt('(');p("<mo>mod</mo>");} formula EPMOD {pMathType=rd;pmt(')');}
;

eqalign: beqalign  cmtable eeqalign;

beqalign: BEQALIGN {mathblock=1;} IMATHB{p("<mtr><mtd>");} expression mtablecolumns  IMATHE ;

eeqalign: IMATHB expression IMATHE EEQALIGN {p("</mtd></mtr>");}  
	| IMATHB expression CR IMATHE EEQALIGN {p("</mtd></mtr>");} 
;

align:
	BAlign {mathmode=1;} DMATHB {p("<mtable><mtr>");depth++;}
	almtcore
	DMATHE EAlign {p("</mtr></mtable>");depth--;mathmode=0;}
;

aligned:
	BAligned {p("<mtable><mtr>");depth++;}
	almtcore
	EAligned {p("</mtr></mtable>");depth--;}
;


eqnarray: 
	BEqnArray {mathmode=1;mathblock=1;p("<mtable>");depth++;}
	DMATHB
	eqnarrayrows
	DMATHE
	EEqnArray {p("</mtable>");mathmode=0;mathblock=0;depth--;}
;

eqnarrayrows: | eqnarrayrows eqnarrayrow 
;

eqnarrayrow:
	IMATHB {p("<mtr><mtd>");wrap(1);} expression opt_ignored_align IMATHE {wrap(0);p("</mtd>");}
	IMATHB {p("<mtd>");wrap(1);} expression opt_ignored_align IMATHE {wrap(0);p("</mtd>");}
	IMATHB {p("<mtd>");wrap(1);} expression opt_ignored_align IMATHE {wrap(0);p("</mtd>");}
	optEqno {p("</mtr>");}

;

opt_ignored_align: |ALIGN
;


mathArray: 
	BARRAY optAOption 
	{p("<mtable><mtr>");depth++;}
	almtcore
	EARRAY {p("</mtr></mtable>");depth--;}
;

almtcore:
	trows 
	|
	DMATHB trows DMATHE  
;

trows: 
	tcell
	| 
	trows tcell 
;
	
tcell:	
	IMATHB {p("<mtd>");wrap(1);}  expression opt_ignored_align IMATHE {wrap(0);p("</mtd>");} 
	|
	IMATHB CR IMATHE optEqno {p("</mtr><mtr>");}
;


mtable: BMTABLE mathmode_on mtable_core EMTABLE {p("</mtd></mtr>");} ;

mtable_core:IMATHB IMATHE bmtable  cmtable emtable IMATHB IMATHE 
|DMATHB bmtable  cmtable emtable DMATHE
;

optfhp:|fhp;

bmtable:  IMATHB{p("<mtr><mtd>");} expression mtablecolumns  IMATHE ;
mtablecolumns: {p("</mtd></mtr><mtr><mtd>");} | ALIGN {p("</mtd><mtd>");} |CR {p("</mtd></mtr><mtr><mtd>");} optEqno;
emtable: IMATHB expression IMATHE  optEqno optfhp ;

cmtable: 	| cmtable mtcell; 

mtcell:IMATHB expression ALIGN IMATHE {p("</mtd><mtd>");}
		|IMATHB expression CR IMATHE {p("</mtd></mtr><mtr><mtd>");} optEqno
;

eqtags:EQNO|LEQNO|REQNO
;


mtext: ANY {theFont.map();}
	| SET ANY {theFont.map();}
	| math_accent
	| HBar  {pMathType=mi;pmt(0x0127);}
	| SBCHAR {pMathType=mo;pmt('_');}
	|	SPACE {pMathType=mo;pmt(' ');}
	| 
		BMBOX 
			{if (!mathOp) {mathBox++;mathText=1;p("<mtext>");}} 
		document 
			{if (!mathOp) {p("</mtext>");mathBox--;mathText=0;}} 
		EMBOX 
	| BFBOX {mathBox++;mathText=1;p("<mtext>");} document {p("</mtext>");mathBox--;mathText=0;} EFBOX 
	| NOTIN IMATHB ANY IMATHE IMATHB ANY IMATHE {pMathType=mo;pmt(0x2209);}
	| LeftNull {p("<mrow><mrow>");}
	| RightNull {p("</mrow></mrow>");}
//	| BTabular IMATHB  mathmode_off document IMATHE mathmode_on ETabular 
	| 
	BCite mathmode_off 
		{AddPHint(0);pHints=0;p("<cite>");} 
		CiteSRef{printCiteSRef();}
		citelabels 
	ECite
		{p("</cite>");pHints=1;AddPHint(1);} mathmode_on
	|
	BRef mathmode_off {AddPHint(0);pHints=0;noDVIY=1;p("<ref>");} 
		Ref  {printRef();p("<pref>");} 
		document 
	ERef {p("</pref></ref>");noDVIY=0;pHints=1;AddPHint(1);} mathmode_on
;


math_accent: MACCENT {p("<mover><mrow>");} mtext {p("</mrow><mrow>");} omtext {p("</mrow>");endMAccent();p("</mover>");}
 	|	BOVERLARROW  {p("<mover accent=\"true\"><mrow>");hbrace=1;} formula EOVERLARROW 
		{hbrace=0;p("</mrow><mo>");p(ul2utf8(0x02190));p("</mo></mover>");} 
 	|	BUNDERLARROW  {p("<munder accentunder=\"true\"><mrow>");hbrace=1;} formula EUNDERLARROW 
		{hbrace=0;p("</mrow><mo>");p(ul2utf8(0x02190));p("</mo></munder>");} 
 	|	BOVERRARROW  {p("<mover accent=\"true\"><mrow>");hbrace=1;} formula EOVERRARROW 
		{hbrace=0;p("</mrow><mo>");p(ul2utf8(0x02192));p("</mo></mover>");} 
 	|	BUNDERRARROW  {p("<munder accentunder=\"true\"><mrow>");hbrace=1;} formula EUNDERRARROW 
		{hbrace=0;p("</mrow><mo>");p(ul2utf8(0x02192));p("</mo></munder>");} 
 	|	BOVERBRACE  {p("<mover accent=\"true\"><mrow>");hbrace=1;} formula EOVERBRACE 
		{hbrace=0;p("</mrow><mo>");p(ul2utf8(0x0FE37));p("</mo></mover>");} 
 	|	BDOT {p("<mover accent=\"true\"><mrow>");hbrace=1;} expression EDOT 
		{hbrace=0;p("</mrow><mo>");p(ul2utf8(0x02d9));p("</mo></mover>");} 
	|	BUNDERBRACE {p("<munder accentunder=\"true\"><mrow>");hbrace=1;} formula EUNDERBRACE 
		{hbrace=0;p("</mrow><mo>");p(ul2utf8(0x0FE38));p("</mo></munder>");} 
	|	BWIDEHAT  {p("<mover accent=\"true\"><mrow>");hbrace=1;} formula EWIDEHAT 
		{hbrace=0;p("</mrow><mo>");p(ul2utf8('^'));p("</mo></mover>");} 
	|	BWIDETILDE {p("<mover accent=\"true\"><mrow>");hbrace=1;} formula EWIDETILDE 
		{hbrace=0;p("</mrow><mo>");p(ul2utf8('~'));p("</mo></mover>");} 
	|	BOVERLINE  {p("<mover accent=\"true\"><mrow>");hbrace=1;} formula EOVERLINE 
		{hbrace=0;p("</mrow><mo>");p(ul2utf8(0x000AF));p("</mo></mover>");} 
	|	BUNDERLINE  {p("<munder accent=\"true\"><mrow>");hbrace=1;} formula EUNDERLINE 
		{hbrace=0;p("</mrow><mo>");p(ul2utf8(0x00332));p("</mo></munder>");} 
	| 	TACCENT dvi ANY {saveAccent(*yytext);} text {contractTextAccent();}
;

omtext: mtext| IMATHB mtext IMATHE|ops;

mml_bdegree:{p("<degree>");};
mml_edegree:{p("</degree>");};

function:
		{p("<mo>");} tex_func {p("</mo>");}
		| {p("<mo>");} extras {p("</mo>");}
		|	BIGSQCAP {pMathType=mo;pmt(0x2A05);}
		|	BIGSQCUP {pMathType=mo;pmt(0x2A06);}
		|	MAPSTO {pMathType=mo;pmt(0x21A6);}
		|	LMAPSTO {pMathType=mo;pmt(0x27FC);}
		|	MODELS {pMathType=mo;pmt(0x22A7);}
		|	HLARROW {pMathType=mo;pmt(0x21A9);}
		|	HRARROW {pMathType=mo;pmt(0x21AA);}
		|	lLARROW {pMathType=mo;pmt(0x27F5);}
		|	LLARROW {pMathType=mo;pmt(0x27F8);}
		|	lRARROW {pMathType=mo;pmt(0x27F6);}
		|	LRARROW {pMathType=mo;pmt(0x27F9);}
		|	lLRARROW {pMathType=mo;pmt(0x27F7);}
		|	LLRARROW {pMathType=mo;pmt(0x27FA);}
		|	BOWTIE {pMathType=mo;pmt(0x22C8);}
;

ld:{p(" LD ");};
rd:{p(" RD ");};

junk:	ANY ;

ops:	{p("<mo>");} symbol {p("</mo>");}
		| tex_sup_op
		| BFRAC {p("<mfrac><mrow>");} expression FRACN {p("</mrow><mrow>");} endfrac 
		| 
			BROOT {p("<mroot><mrow>");}  expression
				ROOT  {p("</mrow><mrow>");} expression 
			EROOT {p("</mrow></mroot>");}
		| BSQRT {p("<msqrt>");} formula {p("</msqrt>");} ESQRT
		| BBUILDREL {p("<mover><mrow>");} expression 
			BUILDREL {p("</mrow><mrow>");} expression 
		EBUILDREL {p("</mrow></mover>");}
		|BMO {decorated=0;mathOp=1;p("<mo>");} formula EMO {mathOp=0;if (!decorated) p("</mo>");}
;


endfrac:OVER FRACD expression EFRAC {p("</mrow></mfrac>");} 
|FRACD expression EFRAC {p("</mrow></mfrac>");}
;

tex_sup_op:
		BSP 
			{
				if (!mathText) {
					if (mathOp && !decorated) p("</mo>");
					beginSuperScript();
				}
			}  
		formula 
			{
				if (!mathText) 
					endSuperScript();
			} 
		ESP
		|
		BSB 
			{
				if (!mathText){ 
					if (mathOp && !decorated) p("</mo>");
					beginSubScript();
				}
			} 
		formula 
			{
				if (!mathText) 
				endSubScript();
			} 
		ESB
;


mathML_content:
		mathML_basic
		|	mathML_relations
		|	mathML_arithmetic_logic
		|	mathML_calculus_vector
		|	mathML_sequences_series
		|	mathML_set_theory
		|	mathML_elementary
		|	mathML_statistics
		|	mathML_linear_algebra
		|	mathML_constants_symbols
;

mathML_basic:
	BInterval mml_binterval {p("<ci>");} formula Interval junk {p("</ci><ci>");} formula EInterval mml_einterval
	|BInverse {p("<apply><inverse/><ci>");} formula Inverse BSP junk junk junk junk ESP EInverse {p("</ci></apply>");}
	|BCompose {p("<apply><compose/><ci>");} formula Compose junk {p("</ci><ci>");} formula ECompose {p("</ci></apply>");}
	|BDomain  {p("<apply><domain/><ci type=\"function\">");} junk formula EDomain junk {p("</ci></apply>");}
	|BCodomain {p("<apply><codomain/><ci type=\"function\">");} junk formula ECodomain junk {p("</ci></apply>");}
	|BImage {p("<apply><image/><ci type=\"function\">");} junk formula EImage junk {p("</ci></apply>");}
	|BAmsCases BLeft optjunks ELeft amscases BRight optjunks ERight EAmsCases 
	|BCases BLeft optjunks ELeft {p("<piecewise>");} cases {p("</piecewise>");}  BRight optjunks ERight ECases 
;


cases: casesrow
	|
	cases casesrow
;

casesrow:
BCasesRow IMATHB 
	{p("<piece><ci>");} formula ALIGN 
	{p("</ci><ci><mtext>");mathBox=mathText=1;} 
	IMATHE document {p("</mtext></ci></piece>");mathBox=mathText=0;} 
	ECasesRow 
;

optjunks:| junks;

amscases: BMTABLE bcases  ccases ecases EMTABLE
|
BARRAY optAOption {p("<piecewise>");} arrcases opt_tail EARRAY {p("</piecewise>");}
;

opt_tail: | IMATHB IMATHE 
;

bcases: IMATHB IMATHE  {p("<piecewise><piece><ci>");} IMATHB expression casescolumns IMATHE;
casescolumns: ALIGN {p("</ci><ci>");} |CR {p("</ci></piece><piece><ci>");};

ecases: IMATHB expression  IMATHE {p("</ci></piece></piecewise>");} IMATHB IMATHE ;

ccases: 	| ccases amsccell; 
			
amsccell:IMATHB expression ALIGN IMATHE {p("</ci><ci>");}
		|IMATHB expression CR IMATHE {p("</ci></piece><piece><ci>");}
		;

arrcase: IMATHB {p("<piece><ci>");} expression ALIGN {p("</ci><ci>");}  IMATHE
	math mathmode_on
	{p("</ci></piece>");}
;

arrcases: 
	arrcase 
	|
	arrcases IMATHB CR IMATHE arrcase 
;


junks: junk| junks junk 
;




mml_binterval:{p("<interval closure=\"-\">");};
mml_einterval:{
	char*temp=strrchr(doc_math,0),*open="open",*closed="closed";
	temp=MatchTagLeft(temp,"<interval");
	if (strchr(temp,'(')) {
		Insert(strchr(temp,'\"')+1,open) ;
		Clean(temp,"<mrow><mo>(</mo><mrow>",1);
	}
	if (strchr(temp,'[')) {
	Insert(strchr(temp,'\"')+1,closed) ;
	Clean(temp,"<mrow><mo>[</mo><mrow>",1);
	}
	if (strchr(temp,')')) {
	Insert(strchr(temp,'-')+1,open) ;
	Clean(temp,"</mrow><mo>)</mo></mrow>",1);
	}
	if (strchr(temp,']')) {
	Insert(strchr(temp,'-')+1,closed) ;
	Clean(temp,"</mrow><mo>]</mo></mrow>",1);
	}
	p("</ci></interval>");
};



mathML_arithmetic_logic:
		BQuotient {p("<apply><quotient/><ci>");} junk formula	Quotient junk {p("</ci><ci>");}	Quotient formula {p("</ci></apply>");} EQuotient junk
		|BFactorial {p("<apply><factorial/><ci>");} ld formula rd Factorial junk EFactorial {p("</ci></apply>");}
		|BFrac {p("<apply><divide><ci>");} formula Fracn {p("</ci><ci>");} EndFrac 
		|BMaxl MAX {p("<apply><max/>");} junk clist EMaxl junk {p("</apply>");}
		|BMaxc MAX {p("<apply><max/>");} BSB bvar ESB junk opt_Expression optjunk condition junk EMaxc {p("</apply>");}
		|BMinl MIN {p("<apply><min/>");} junk clist EMinl junk {p("</apply>");}
		|BMinc MIN {p("<apply><min/>");} BSB bvar ESB junk opt_Expression optjunk condition junk EMinc {p("</apply>");}
		|BPower	{p("<apply><power/><ci>");}  formula Power {p("</ci><ci>");} BSP formula ESP EPower {p("</ci></apply>");}
		|BRem	{p("<apply><rem/><ci>");} formula {p("</ci><ci>");} Rem REM formula ERem {p("</ci></apply>");}
		|BPlus	{p("<apply><plus/><ci>");} formula Plus {p("</ci><ci>");} formula EPlus {p("</ci></apply>");}
		|BMinus	{p("<apply><minus/><ci>");} formula Minus {p("</ci><ci>");} formula EMinus {p("</ci></apply>");}
		|BTimes	{p("<apply><times/><ci>");} formula Times {p("</ci><ci>");} formula ETimes {p("</ci></apply>");}
		|BRoot IMATHB {p("<apply><root/>");} mml_bdegree formula mml_edegree Root {p("<ci>");} IMATHE IMATHB junk formula  stupid_root {p("</ci></apply>");}
		|BSqrt {p("<apply><root/><degree><cn>2</cn></degree><ci>");} ld formula rd {p("</ci></apply>");} ESqrt
		|BGcd	GCD {p("<apply><gcd/><ci>");} formula {p("</ci></apply>");} EGcd
		|BLand	{p("<apply><and/><ci>");}  formula Land junk {p("</ci><ci>");} formula ELand {p("</ci></apply>");}
		|BLor	{p("<apply><or/><ci>");}  formula Lor junk {p("</ci><ci>");} formula ELor {p("</ci></apply>");}
		|BXor	{p("<apply><xor/><ci>");}  formula Xor XOR {p("</ci><ci>");} formula EXor {p("</ci></apply>");}
		|BNot	{p("<apply><not/><ci>");}  formula {p("</ci>");} ENot
		|BImplies	{p("<apply><implies/><ci>");} formula {p("</ci><ci>");} Implies junk formula{p("</ci></apply>");} EImplies
		|BForall {p("<apply><forall/>");} bvar optjunk opt_condition BAssert junk formula EAssert EForall {p("</apply>");}
		|BExists {p("<apply><exists/>");} bvar optjunk opt_condition BAssert junk formula EAssert EExists {p("</apply>");}
		|Babs {p("<apply><abs/><ci>");} junk formula Eabs junk {p("</ci></apply>");}
		|Bconjugate {p("<apply><conjugate/><ci>");} BOVERLINE formula EOVERLINE Econjugate {p("</ci></apply>");}
		|BArg ARG {p("<apply><arg/><ci>");} formula  EArg {p("</ci></apply>");}
		|BRe	junk {p("<apply><real/><ci>");} formula ERe {p("</ci></apply>");}
		|BIm	junk {p("<apply><imaginary/><ci>");} formula EIm {p("</ci></apply>");}
		|BLcm	LCM {p("<apply><lcm/><ci>");} formula {p("</ci></apply>");} ELcm
		|Bfloor junk {p("<apply><floor/><ci>");} formula {p("</ci></apply>");} Efloor junk
		|Bceil junk {p("<apply><ceiling/><ci>");} formula {p("</ci></apply>");} Eceil junk
;


EndFrac:OVER Fracd formula EFrac {p("</ci></apply>");} 
|Fracd formula EFrac {p("</ci></apply>");}
;

stupid_root:
ERoot IMATHE
|
IMATHE ERoot
;

bvar: BVar {p("<bvar>");} clist {p("</bvar>");} EVar fix_bvar
;
opt_Expression: | BExpr {p("<ci>");} formula  {p("</ci>");} EExpr;
condition: BCond {p("<condition>");} formula ECond {p("</condition>");}
;
opt_condition: | condition;



clist: {p(" LIST <ci>");} formula fix_list;
fix_list:
{
	char*temp=strrchr(doc_math,0),*tail,*lock;
	while (temp!=strstr(temp," LIST ")) temp--;
	lock=temp;
	while ((temp=strstr(temp,"<mo>,</mo>"))){
		tail=(char*)malloc(strlen(temp)+1);
		strcpy(tail,temp+strlen("<mo>,</mo>"));
		strcpy(temp,"</ci><ci>");
		strcat(temp,tail);
		free(tail);
	}
	tail=(char*)malloc(strlen(lock)+1);
	strcpy(tail,lock+strlen(" LIST "));
	*lock=0;
	strcpy(lock,tail);
	free(tail);
	p("</ci>");
}
;

fix_bvar:
{
	char*temp=strrchr(doc_math,0),*tail,*lock;
	while (temp!=strstr(temp,"<bvar>")) temp--;
	lock=temp;
	while ((temp=strstr(temp,"</ci><ci>"))){
		if (strstr(temp,"</bvar")){
			tail=(char*)malloc(strlen(temp)+1);
			strcpy(tail,temp+strlen("</ci><ci>"));
			strcpy(temp,"</ci></bvar><bvar><ci>");
			lock=strrchr(temp,0);
			strcat(temp,tail);
			temp=lock;
			free(tail);
		}else break;
	}
}
;

mathML_relations:
	BEqual	{p("<apply><eq/><ci>");}  formula Equal junk {p("</ci><ci>");} formula EEqual {p("</ci></apply>");}
	|BNequal	{p("<apply><neq/><ci>");}  formula Nequal junk junk {p("</ci><ci>");} formula ENequal {p("</ci></apply>");}
	|BLequal	{p("<apply><leq/><ci>");}  formula Lequal junk {p("</ci><ci>");} formula ELequal {p("</ci></apply>");}
	|BGequal	{p("<apply><geq/><ci>");}  formula Gequal junk {p("</ci><ci>");} formula EGequal {p("</ci></apply>");}
	|BEquiv	{p("<apply><equivalent/><ci>");}  formula Equiv junk {p("</ci><ci>");} formula EEquiv {p("</ci></apply>");}
	|BApprox	{p("<apply><approx/><ci>");}  formula Approx junk {p("</ci><ci>");} formula EApprox {p("</ci></apply>");}
	|BGthan	{p("<apply><gt/><ci>");}  formula Gthan junk {p("</ci><ci>");} formula EGthan {p("</ci></apply>");}
	|BLthan	{p("<apply><lt/><ci>");}  formula Lthan junk {p("</ci><ci>");} formula ELthan {p("</ci></apply>");}
	|BFactor {p("<apply><factorof/><ci>");} formula Factor junk {p("</ci><ci>");} formula EFactor {p("</ci></apply>");}
;

mathML_set_theory:
		BSetl junk {p("<set>");} clist ESetl junk {p("</set>");}
		|BSetc junk {p("<set>");} bvar junk condition junk ESetc  {p("</set>");}
		|BListl junk {p("<list>");} clist EListl junk {p("</list>");}
		|BListc junk {p("<list>");} bvar junk condition junk EListc {p("</list>");}
		|BSubset	{p("<apply><prsubset/><ci>");}  formula Subset junk {p("</ci><ci>");} formula ESubset {p("</ci></apply>");}
		|BSubseteq	{p("<apply><subset/><ci>");}  formula Subseteq junk {p("</ci><ci>");} formula ESubseteq {p("</ci></apply>");}
		|BNotsubset	{p("<apply><notprsubset/><ci>");}  formula Notsubset junk {p("</ci><ci>");}  formula ENotsubset {p("</ci></apply>");}
		|BNotsubseteq	{p("<apply><notsubset/><ci>");}  formula Notsubseteq junk {p("</ci><ci>");}  formula ENotsubseteq {p("</ci></apply>");}
		|BUnion	{p("<apply><union/><ci>");}  formula Union junk {p("</ci><ci>");} formula EUnion {p("</ci></apply>");}
		|BIntersect	{p("<apply><intersect/><ci>");}  formula Intersect junk {p("</ci><ci>");} formula EIntersect {p("</ci></apply>");}
		|BIn	{p("<apply><in/><ci>");}  formula In junk{p("</ci><ci>");}formula EIn {p("</ci></apply>");}
		|BNotin	{p("<apply><notin/><ci>");}  formula Notin {p("</ci><ci>");} formula ENotin {p("</ci></apply>");}
		|BSetdiff {p("<apply><setdiff/><ci>");} formula Setdiff junk {p("</ci><ci>");}  formula ESetdiff {p("</ci></apply>");}
		|BCard {p("<apply><card/><ci>");} junk formula ECard junk {p("</ci></apply>");}
		|BCartesian {p("<apply><cartesianproduct/><ci>");} formula Cartesian junk {p("</ci><ci>");}  formula ECartesian {p("</ci></apply>");}
;

mathML_elementary:
		BArccos ARCCOS {p("<apply><arccos/><ci>");} formula {p("</ci></apply>");} EArccos
		|BArccosh Arccosh {p("<apply><arccosh/><ci>");} formula {p("</ci></apply>");} EArccosh
		|BArcsin ARCSIN  {p("<apply><arcsin/><ci>");} formula {p("</ci></apply>");} EArcsin
		|BArcsinh Arcsinh {p("<apply><arcsinh/><ci>");} formula {p("</ci></apply>");} EArcsinh
		|BArctan ARCTAN {p("<apply><arctan/><ci>");} formula {p("</ci></apply>");} EArctan
		|BArctanh Arctanh {p("<apply><arctanh/><ci>");} formula {p("</ci></apply>");} EArctanh
		|BCos COS {p("<apply><cos/><ci>");} formula {p("</ci></apply>");} ECos
		|BCosh COSH {p("<apply><cosh/><ci>");} formula {p("</ci></apply>");} ECosh
		|BCot COT {p("<apply><cot/><ci>");} formula {p("</ci></apply>");} ECot
		|BArccot Arccot {p("<apply><arccot/><ci>");} formula {p("</ci></apply>");} EArccot
		|BCoth COTH {p("<apply><coth/><ci>");} formula {p("</ci></apply>");} ECoth
		|BArccoth Arccoth {p("<apply><arccoth/><ci>");} formula {p("</ci></apply>");} EArccoth
		|BCsc CSC {p("<apply><csc/><ci>");} formula {p("</ci></apply>");} ECsc
		|BArccsc Arccsc {p("<apply><arccsc/><ci>");} formula {p("</ci></apply>");} EArccsc
		|BCsch Csch {p("<apply><csch/><ci>");} formula {p("</ci></apply>");} ECsch
		|BArccsch Arccsch {p("<apply><arccsch/><ci>");} formula {p("</ci></apply>");} EArccsch
		|BExp EXP {p("<apply><exp/><ci>");} formula {p("</ci></apply>");} EExp
		|BLg LG {p("<apply><lg/><logbase><cn>10</cn></logbase><ci>");} formula {p("</ci></apply>");} ELog
		|BLn LN {p("<apply><ln/><ci>");} formula {p("</ci></apply>");} ELn
		|BLog LOG {p("<apply><log/><ci>");} formula {p("</ci></apply>");} ELog
		|BSec SEC {p("<apply><sec/><ci>");} formula {p("</ci></apply>");} ESec
		|BArcsec Arcsec {p("<apply><arcsec/><ci>");} formula {p("</ci></apply>");} EArcsec
		|BSech Sech {p("<apply><sech/><ci>");} formula {p("</ci></apply>");} ESech
		|BArcsech Arcsech {p("<apply><arcsech/><ci>");} formula {p("</ci></apply>");} EArcsech
		|BSin SIN {p("<apply><sin/><ci>");} formula {p("</ci></apply>");} ESin
		|BSinh SINH  {p("<apply><sinh/><ci>");} formula {p("</ci></apply>");} ESinh
		|BTan TAN {p("<apply><tan/><ci>");} formula {p("</ci></apply>");} ETan
		|BTanh TANH {p("<apply><tanh/><ci>");} formula {p("</ci></apply>");} ETanh
;

mathML_statistics:
		BMean {p("<apply><mean/><ci>");} formula EMean {p("</ci></apply>");}
		|BSDev junk junk {p("<apply><sdev/><ci>");} formula  ESDev junk {p("</ci></apply>");}
		|BVariance junk junk {p("<apply><variance/><ci>");} formula Variance junk BSP junk ESP EVariance {p("</ci></apply>");}
		|BMedian {p("<apply><median/><ci>");} Median junk formula EMedian junk {p("</ci></apply>");}
		|BMode {p("<apply><mode/><ci>");} Mode junk formula EMode junk {p("</ci></apply>");}
		|BMoment {p("<apply><moment/><ci>");} formula {p("</ci>");} mml_moment_degree EMoment mml_emoment
		|BMomenta {p("<apply><moment/><ci>");} mml_moment_arg {p("</ci>");} optjunk mml_moment_about mml_moment_degree EMomenta mml_emoment
;

mml_moment_arg:optjunk BMomentArg formula EMomentArg;
mml_moment_about:|BMabout {p("<momentabout><ci>");} formula EMabout optjunk {p("</ci></momentabout>");};
mml_moment_degree:| BMomentDeg {p("<degree>");} BSP  {p("<cn>");} mtext {p("</cn>");} EMomentDeg ESP {p("</degree>");};
mml_emoment:{
	//make the first child the last
	char*temp=strrchr(doc_math,0), *tail,*lock;
	lock=MatchTagLeft(temp,"<apply");temp=NULL;
	if ((temp=strstr(lock,"<momentabout")));
	else temp=strstr(lock,"<degree");
	if (temp){
		tail=(char*)malloc(strlen(temp)+1);
		strcpy(tail,temp);*temp=0;
		lock=strstr(lock,"<ci");
		Insert(lock,tail);
		free(tail);
	}
	p("</apply>");
};

mathML_linear_algebra:
		vector
		|Matrix
		|BDet DET {p("<apply><determinant/><ci>");} formula EDet {p("</ci></apply>");}
		|BTranspose {p("<apply><transpose/><ci type=\"matrix\">");} text BSP junk ESP ETranspose {p("</ci></apply>");}
		|BSelector {p("<apply><selector/>");} selector_content {p("<cn>");} BSB selector ESB ESelector mml_eselector
		|BVectorProduct mml_bapply {p("<vectorproduct/><ci>");} formula VectorProduct junk {p("</ci><ci>");} formula EVectorProduct {p("</ci></apply>");}
		|BScalarProduct mml_bapplyi {p("<scalarproduct/><ci>");} formula ScalarProduct junk  {p("</ci><ci>");} formula EScalarProduct {p("</ci></apply>");}
		|BOuterProduct mml_bapply {p("<outerproduct/><ci>");} formula OuterProduct junk  {p("</ci><ci>");} formula EOuterProduct {p("</ci></apply>");}
;

vector:	BVector {p("<vector><ci>");} optjunk BMATRIX formula EMATRIX optjunk  mml_evector EVector;

Matrix: BMatrix optjunk matrix optjunk EMatrix ;

matrix: bmatrix  cmatrix ematrix;

bmatrix: BMATRIX {p("<matrix><matrixrow><ci>");} IMATHB IMATHE IMATHB expression matrixcolumns  IMATHE ;
matrixcolumns: ALIGN {p("</ci><ci>");} |CR {p("</ci></matrixrow><matrixrow><ci>");};

ematrix: IMATHB expression IMATHE IMATHB IMATHE EMATRIX {p("</ci></matrixrow></matrix>");}  ;

cmatrix: 	| cmatrix matrixcell; 

matrixcell:IMATHB expression ALIGN IMATHE {p("</ci><ci>");}
		|IMATHB expression CR IMATHE {p("</ci></matrixrow><matrixrow><ci>");}
;

selector_content: {p("<ci type=\"vector\">");} text {p("</ci>");}
	| SelectorMatrix {p("<ci type=\"matrix\">");} text {p("</ci>");}
	| vector
	| SelectorMatrix matrix
;
selector: formula ;

optjunk:  | junk optjunk;

mml_evector:{
	char*temp=strrchr(doc_math,0),*lock,*tail;
	temp=MatchTagLeft(temp,"<vector");
	temp=strstr(temp,">");temp++;
	lock=temp;
	//replace <mo>,</mo> with </ci><ci>
	while ((temp=strstr(temp,"<mo>,</mo>"))){
		tail=(char*)malloc(strlen(temp)+1);
		strcpy(tail,temp+strlen("<mo>,</mo>"));
		strcpy(temp,"</ci><ci>");
		strcat(temp,tail);
		free(tail);
	}
	temp=lock;
	while ((temp=strstr(temp,"<mo> CR </mo>"))){
		tail=(char*)malloc(strlen(temp)+1);
		strcpy(tail,temp+strlen("<mo> CR </mo>"));
		strcpy(temp,"</ci><ci>");
		strcat(temp,tail);
		free(tail);
	}
	p("</ci></vector>");
};

mml_eselector:{
	char*temp=strrchr(doc_math,0),*lock,*tail;
	temp=MatchTagLeft(temp,"<apply");
	temp=strstr(temp,">");temp++;
	lock=temp;
	//replace <mo>,</mo> with </cn><cn>
	while ((temp=strstr(temp,"<mo>,</mo>"))){
		tail=(char*)malloc(strlen(temp)+1);
		strcpy(tail,temp+strlen("<mo>,</mo>"));
		strcpy(temp,"</cn><cn>");
		strcat(temp,tail);
		free(tail);
	}
	p("</cn></apply>");
};

mathML_constants_symbols:
	Integers {p("<integers/>");}
	|Naturals {p("<naturalnumbers/>");}
	|Rationals {p("<rationals/>");}
	|Reals {p("<reals/>");}
	|Complexes {p("<complexes/>");}
	|Primes	{p("<primes/>");}
	|ExponentialE {p("<exponentiale/>");}
	|ImaginaryI	{p("<imaginaryi/>");}
	|NotANumber	{p("<notanumber/>");}
	|Emptyset {p("<emptyset/>");}
	|True	{p("<true/>");}
	|False	{p("<false/>");}
	|PiCst	{p("<pi/>");}
	|EulerGamma	{p("<eulergamma/>");}
	|Infty {p("<infinity/>");}
	|Ident {p("<ident/>");}
;


extras:
	Trace	{p("tr");}
;

tex_func:
		 ARCCOS {p("arccos");}
		 |Arccosh {p("arccosh");}
		|ARCSIN   {p("arcsin");}
		|Arcsinh {p("arcsinh");}
		|ARCTAN  {p("arctan");}
		|Arctanh  {p("arctanh");}
		|ARG  {p("arg");}
		|COS  {p("cos");}
		|COSH  {p("cosh");}
		|COT  {p("cot");}
		|Arccot  {p("arccot");}
		|COTH  {p("coth");}
		|Arccoth  {p("arccoth");}
		|CSC  {p("csc");}
		|Arccsc  {p("arccsc");}
		|Csch  {p("csch");}
		|Arccsch  {p("arccsch");}
		|DEG  {p("deg");}
		|DET  {p("det");}
		|DIM  {p("dim");}
		|EXP  {p("exp");}
		|GCD  {p("gcd");}
		|LCM  {p("lcm");}
		|HOM  {p("hom");}
		|INF  {p("inf");}
		|KER  {p("ker");}
		|LG  {p("log");}
		|LIM  {p("lim");}
		|LIMINF {p("liminf");}
		|LIMSUP {p("limsup");}
		|LN  {p("ln");}
		|LOG  {p("log");}
		|MAX  {p("max");}
		|MIN  {p("min");}
		|PR  {p("pr");}
		|SEC  {p("sec");}
		|Arcsec  {p("arcsec");}
		|Sech  {p("sech");}
		|Arcsech  {p("arcsech");}
		|SIN  {p("sin");}
		|SINH  {p("sinh");}
		|SUP  {p("sup");}
		|TAN  {p("tan");}
		|TANH  {p("tanh");}

		|REM  {p("mod");}
		|XOR  {p("xor");}
		
		
;

opt_over:|OVER
;

mathML_calculus_vector:
		BInt {p("<apply><int/>");} mml_Ilimits BIntarg {p("<ci>");} formula EIntarg {p("</ci><bvar><ci>");} BIntbe junk formula EIntbe {p("</ci></bvar>");} flipIntegrand EInt
	 	|BDiff {p("<apply><diff/>");} BFRAC junk mml_diff_degree0 BDiffarg {p("<ci>");} formula EDiffarg FRACN 
		opt_over
		FRACD junk {p("</ci><bvar><ci>");} BDiffbe formula EDiffbe {p("</ci>");} mml_diff_degree {p("</bvar></apply>");} EFRAC EDiff
		|BDivt {p("<apply><divergence/><ci>");} formula EDiv {p("</ci></apply>");}
		|BDivs {p("<apply><divergence/><ci>");} formula EDiv {p("</ci></apply>");}
		|BGradt {p("<apply><grad/><ci>");} formula EGrad {p("</ci></apply>");}
		|BGrads {p("<apply><grad/><ci>");} formula EGrad {p("</ci></apply>");}
		|BCurlt {p("<apply><curl/><ci>");} formula ECurl {p("</ci></apply>");}
		|BCurls {p("<apply><curl/><ci>");} formula ECurl {p("</ci></apply>");}
		|BLaplacian {p("<apply><laplacian/><ci>");} BSP junk ESP formula ELaplacian {p("</ci></apply>");}

;

flipIntegrand:{
	char*temp=strrchr(doc_math,0),*tail;
	while (strstr(temp,"</bvar")!=temp) temp--;
	temp=MatchTagLeft(temp,"<bvar");
	tail=(char*)malloc(strlen(temp)+1);
	strcpy(tail,temp);*temp=0;
	while (strstr(temp,"</ci")!=temp) temp--;
	temp=MatchTagLeft(temp,"<ci");
	Insert(temp,tail);
	free(tail);
	p("</apply>");
}
;

mml_diff_degree0: |
		BDiffdeg BSP junk ESP EDiffdeg
;
mml_diff_degree: |
		BDiffdeg BSP {p("<degree><ci>");} mtext {p("</ci></degree>");} ESP EDiffdeg
;
mathML_sequences_series:
		BSum {p("<apply><sum/>");} mml_Slimits {p("<ci>");} BSumarg formula ESumarg ESum {p("</ci></apply>");}
		|BProd {p("<apply><product/>");} mml_Plimits {p("<ci>");} BProdarg formula EProdarg EProd {p("</ci></apply>");}
		|BLimit {p("<apply><limit/>");} LIM mml_bcondition BSB  formula ESB mml_elimit mml_econdition {p("<ci>");} BLimitarg formula ELimitarg ELimit {p("</ci></apply>");}
		|BTendsto {p("<apply><tendsto/><ci>");} formula {p("</ci><ci>");} Tendsto expression ETendsto {p("</ci></apply>");}
;

mml_Ilimits:	
		|	BSP mml_buplimit BIntul formula EIntul ESP junk mml_euplimit BSB  mml_bllimit BIntll  formula EIntll ESB mml_ellimit
		|junk BSP mml_buplimit BIntul formula EIntul ESP mml_euplimit BSB  mml_bllimit BIntll  formula EIntll ESB mml_ellimit
		|BSB  mml_bllimit BIntll formula EIntll ESB junk mml_ellimit
		|junk BSB  mml_bllimit BIntll formula EIntll ESB mml_ellimit
		|BSP  mml_buplimit BIntul formula EIntul ESP junk mml_euplimit
		|junk BSP  mml_buplimit BIntul formula EIntul ESP mml_euplimit
;

mml_Slimits:	|
		BSP mml_buplimit BSumul formula ESumul ESP junk mml_euplimit BSB  mml_bllimit BSumll  formula ESumll ESB mml_ellimit
		|junk BSP mml_buplimit BSumul formula ESumul ESP mml_euplimit BSB  mml_bllimit BSumll  formula ESumll ESB mml_ellimit
		|junk BSB  mml_bllimit BSumll formula ESumll ESB mml_ellimit
		|BSP  mml_buplimit BSumul formula ESumul ESP junk mml_euplimit
		|junk BSP  mml_buplimit BSumul formula ESumul ESP mml_euplimit
;

mml_Plimits:	|
		BSP mml_buplimit BProdul formula EProdul ESP junk mml_euplimit BSB  mml_bllimit BProdll  formula EProdll ESB mml_ellimit
		|junk BSP mml_buplimit BProdul formula EProdul ESP mml_euplimit BSB  mml_bllimit BProdll  formula EProdll ESB mml_ellimit
		|junk BSB  mml_bllimit BProdll formula EProdll ESB mml_ellimit
		|BSP  mml_buplimit BProdul formula EProdul ESP junk mml_euplimit
		|junk BSP  mml_buplimit BProdul formula EProdul ESP mml_euplimit
;




mml_bcondition:{p("<condition>");};
mml_econdition:{p("</condition>");};
mml_elimit:{
	char*temp=doc_math,*limit,*lock=doc_math,*tail,*bvar;
	while ((temp=strstr(temp,"<limit/>"))) lock=temp++;
	limit=temp=lock;
	limit=strstr(limit,">")+1;
	while ((temp=strstr(temp,"<condition>"))) lock=temp++;
	temp=lock;
	while ((temp=strstr(temp,"<ci"))) lock=temp++;
	temp=lock;
	lock=strstr(temp,"</ci>")+strlen("</ci>");
	tail=(char*)malloc(strlen(lock)+1);
	strcpy(tail,lock);*lock=0;
	bvar=(char*)malloc(strlen(temp)+1);
	strcpy(bvar,temp);
	strcat(temp,tail);free(tail);
	limit=Insert(limit,"<bvar>");
	limit=Insert(limit,bvar);
	Insert(limit,"</bvar>");free(bvar);
};


mml_bllimit:{p("<lowlimit><ci>");};
mml_buplimit:{p("<uplimit><ci>");};
mml_ellimit:{p("</ci></lowlimit>");};
mml_euplimit:{p("</ci></uplimit>");};


symbol:
		CDOTS {p(ul2utf8(0x022EF));}
		|DDOTS {p(ul2utf8(0x022F1));}
		|LDOTS {p(ul2utf8(0x02026));}
		|VDOTS {p(ul2utf8(0x022EE));}
;

mml_bapply: {p("<apply>");};

mml_bapplyi: {
	p("<apply>");
};


%%

int main(int argc, char*argv[])
{
	unsigned int p2post, al,fontIndex,fontNumber;
	unsigned char i,k, endian[5],*temp;
	unsigned char test[512];
	short int j=1;
	doc_math=NULL;
	doc_text=NULL;
	endian[4]=0;//just in case :)
	BigEndian=((char*)&j)[1];
	if (argc==1) {
		printf("Hermes version %s, %s, covered by GNU GPL; description at %s\n\
		usage: hermes name.s.dvi\n", VERSION, DATE, DESCRIPTION);
		exit(EXIT_SUCCESS);
	}
	if(argc>=2){
		yyin=fopen(argv[1],"rb");
		if (yyin==NULL){
			printf("%s not found",argv[1]);
			exit(EXIT_FAILURE);
		}
//		if (argc==3) {INFER_CONTENT=1;}
		//if (argc==3) {DEBUG=1;}
		DEBUG=1;
		fseek(yyin,0,SEEK_SET);
		fread(&i,1,1,yyin);
		if (i!=247){
			fprintf(stderr,"expected the dvi 'pre' command, got %d,\nthis might not be a dvi file, quitting\n",i);
			fclose(yyin);
			exit(EXIT_FAILURE);
		}
		if (!BigEndian){
			for(j=3;j>=0;j--){
				fread(endian+j,1,1,yyin);
			}
			scale.num=*((unsigned int*) endian);
		}else
			fread(&scale.num,4,1,yyin);
		if (!BigEndian){
			for(j=3;j>=0;j--){
				fread(endian+j,1,1,yyin);
			}
			scale.den=*((unsigned int*) endian);
		}else
			fread(&scale.den,4,1,yyin);
		if (!BigEndian){
			for(j=3;j>=0;j--){
				fread(endian+j,1,1,yyin);
			}
			scale.mag=*((unsigned int*) endian);
		}else
			fread(&scale.mag,4,1,yyin);

		fseek(yyin,0,SEEK_END);
		fseek(yyin,-1,SEEK_CUR);
		do{
			fread(&i,1,1,yyin);
			fseek(yyin,-2,SEEK_CUR);
		}while(i==223);
		if (i!=2){
			printf("not prepared for right to left typesetting\n");
			fclose(yyin);
			exit(EXIT_FAILURE);
		}
		fseek(yyin,-3,SEEK_CUR);
		if (!BigEndian){
			for(j=3;j>=0;j--){
				fread(endian+j,1,1,yyin);
			}
			p2post=*((unsigned int*) endian);
		}else
			fread(&p2post,4,1,yyin);

		fseek(yyin,p2post,SEEK_SET);
		fread(&i,1,1,yyin);
		if (i!=248){//DVI POST
			fclose(yyin);
			die("didn't find 'post' where it should be,\nthis input maybe corrupted, ....\n");
		}
		
		//jump to font definitions, count fonts used 
		fseek(yyin,28,SEEK_CUR);
		fread(&i,1,1,yyin);
		maxFontNr=0;
		while(i<=246 && i>=243){//read fontdefs
			fseek(yyin,(i-242)+12,SEEK_CUR);
			fread(&i,1,1,yyin);al=i;
			fread(&i,1,1,yyin);al+=i;
			fread(test,al,1,yyin);
			maxFontNr++;
			fread(&i,1,1,yyin);
		}
		
		
		//allocate space for the font structures
		if (!(pFont=malloc(maxFontNr*sizeof(struct _Font)))) 
			die("not enough memory\n");
	
		//reread the fonts, this time map them
		fseek(yyin,p2post,SEEK_SET);
		fread(&i,1,1,yyin);
		fseek(yyin,28,SEEK_CUR);//jump to font definitions
		fread(&i,1,1,yyin);
		fontsMissing=0;
		fontIndex=0;
		while(i<=246 && i>=243){//read fontdefs
			switch(i){
			case 243:
				fread(&k,1,1,yyin);
				fontNumber=k;
			break;
			case 244:
				fread(&k,1,1,yyin);
				fontNumber=k<<8;
				fread(&k,1,1,yyin);
				fontNumber+=k;
			break;
			case 245:
				fread(&k,1,1,yyin);
				fontNumber=k<<16;
				fread(&k,1,1,yyin);
				fontNumber+=k<<8;
				fread(&k,1,1,yyin);
				fontNumber+=k;
			break;
			case 246:
				fread(&k,1,1,yyin);
				fontNumber=k<<24;
				fread(&k,1,1,yyin);
				fontNumber+=k<<16;
				fread(&k,1,1,yyin);
				fontNumber+=k<<8;
				fread(&k,1,1,yyin);
				fontNumber+=k;
			break;
			}
	
			theFont.number=fontNumber; //save the font number
			
			fseek(yyin,12,SEEK_CUR);
			fread(&i,1,1,yyin);al=i;
			fread(&i,1,1,yyin);al+=i;
			fread(test,al,1,yyin);
			test[al]=0;//make the fontname a C string
			
			temp=strrchr(test,0);	
			while (temp!=test){
				temp--;
				if (!isdigit(*temp))	{temp++;break;}
			}
			if (strlen(temp)){
				strcpy(theFont.size,temp);
				if ((temp=strstr(test,temp))) *temp=0; //drop the design size
			}
			
			strcpy(theFont.name,test);	//save the font name, without design size
			
			mapFonts(0);	//infer a font map based on font name
			if (theFont.map==NULL) {
				fprintf(stderr,"error: font %s not mapped yet\n",theFont.name);
				fontsMissing=1;
			}	else{
				strcpy((*pFont)[fontIndex].name,theFont.name);
				strcpy((*pFont)[fontIndex].size,theFont.size);
				(*pFont)[fontIndex].map=theFont.map;
				(*pFont)[fontIndex].number=theFont.number;
				(*pFont)[fontIndex].width=theFont.width;
				(*pFont)[fontIndex].family=theFont.family;
				(*pFont)[fontIndex].variant=theFont.variant;
				(*pFont)[fontIndex].style=theFont.style;
				(*pFont)[fontIndex].weight=theFont.weight;
				//fprintf(stderr,"font:\nname:%s, size:%s, number:%ld\n",(*pFont)[fontIndex].name,(*pFont)[fontIndex].size,(*pFont)[fontIndex].number);
			}
			fontIndex++;
			fread(&i,1,1,yyin);
		}
				
		fseek(yyin,0,SEEK_SET);
	}
	
		
	if (fontsMissing)	die("some fonts are not mapped yet\n");
	doc_math=(char*)malloc(LIMIT);
	doc_text=(char*)malloc(LIMIT);
	*doc_math=0;*doc_text=0;
	strcpy(fname,argv[1]);
	fprintf(stdout,"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n");
	fprintf(stdout,"<document>\n<generator>\n");
	fprintf(stdout,"<name>Hermes</name>\n");
	fprintf(stdout,"<version>%s</version>\n",VERSION);
	fprintf(stdout,"<date>%s</date>\n",DATE);
	fprintf(stdout,"<license>GNU GPL</license>\n");
	fprintf(stdout,"<description>%s</description>\n",DESCRIPTION);
	fprintf(stdout,"</generator>\n");
	AddPHint(1);
	yyparse ();
	AddPHint(0);
	fprintf(stdout,"</ph>\n");
	if (hasSections)	fprintf(stdout,"</section>");
	fprintf(stdout,"</document>");
 	if(yyin) fclose(yyin);
 	if(yyout) fclose(yyout);
 	if (doc_math) free(doc_math);
 	if (doc_text) free(doc_text);
 	return 0;
}


int yywrap() {
return 1;
}

int yyerror(char* msg) {
	flushText();
	fflush(stdout);

	if (*lastToken)
		fprintf(stderr,"\n\nparsing error:\nlast token received was '%s'\n",lastToken);
 	if (doc_math){
	 	if ( *doc_math) {
	 		fprintf(stderr,"\nmath leftovers:\n'%s'\n",doc_math);
	 	}
		free(doc_math);
	}
//		showcontext();
	fprintf(stderr,"cleaning up...\n");
	if (pFont) free(pFont);
 	clearStack();
	fprintf(stderr,"...bye.\n");
	exit(EXIT_FAILURE);
}

void p(char*s){
	char *temp=doc_text,*lock=doc_text;
	if (!fakesp){
		//doc_text is flushed at each space or 'dviy' encountered
		fakesp=1;
		//rid of hyphenchar
		if (*doc_text){
			lock=temp=strrchr(doc_text,0);
			temp--;lock--;
			if (*temp=='-')*temp=0;
			else{
				if (*temp!=' ' && *temp!='>' && !inCitation) 
					strcat(doc_text," ");
			}
		}
		if (!inhibitspace){
			if(*doc_math && (!mathmode ||mathText) && !mathOp)
				strcat(doc_math," ");
		} else inhibitspace=0;
		fprintf(stdout,"%s",doc_text);
		if (strcmp(s,"<dviy/>")==0){
			if (*lock==' ') {while(*lock==' ')lock--;}
			if (strpbrk(lock,":.!?") && canbreak){
					while(*lock!=' ' && *lock!='>' && lock!=doc_text) {
						lock--;
					}
					if (*lock=='>' || *lock==' ') lock++;
					if ((*lock <'A' || *lock >'Z') && !inTable && !inBibliography) {
						fprintf(stdout,"<br/>\n");
					}
			}
			*doc_text=0;
			return;
		}
		*doc_text=0;
	}
	if ((mathmode || mathText)&& !infhp) strcat(doc_math,s);
	else strcat(doc_text,s);
	//if (strstr(s,"</mtext>")==s) mathText=0;
}



char* MoveLeft(char*where,char*temp)
{
	char*seek,*tail;
	while(temp!=strstr(temp,"</c") && temp!=strstr(temp," RD ") && temp!=strstr(temp," RD </apply>")) temp--;
	if (temp==strstr(temp," RD </apply>")){
		temp=SkipBracketsLeft(temp);
		tail=(char*)malloc(strlen(temp)+1);
		strcpy(tail,temp);*temp=0;
		if (strrchr(where,'<')!=strstr(seek=strrchr(where,'<'),"<c")){
			while(temp!=strstr(temp,"<apply>")) {if (temp==where) break;temp--;}
			if(temp!=where)
				temp=MoveLeft(where,temp=seek);
		}
		strcat(temp,tail);
		free(tail);
	}else{
		if (temp==strstr(temp,"</ci>"))
			temp=MatchTagLeft(temp,"<ci");
		else{
			if (temp==strstr(temp,"</cn>"))
				temp=MatchTagLeft(temp,"<cn");
			else{
				if (temp==strstr(temp," RD ")){
					temp=SkipBracketsLeft(temp);
				}
			}
		}

	}
	return temp;
}


int IsComplete(char*temp){

	if (strstr(temp,"<csymbol")==temp) return 1;

	if (strstr(temp,"<plus/>")==temp) return 1;
	if (strstr(temp,"<minus/>")==temp) return 1;
	if (strstr(temp,"<power/>")==temp) return 1;
	if (strstr(temp,"<eq/>")==temp) return 1;

	if (strstr(temp,"<root/>")==temp) return 1;
	if (strstr(temp,"<gcd/>")==temp) return 1;
	if (strstr(temp,"<lcm/>")==temp) return 1;
	if (strstr(temp,"<not/>")==temp) return 1;
	if (strstr(temp,"<partialdiff/>")==temp) return 1;
	if (strstr(temp,"<real/>")==temp) return 1;
	if (strstr(temp,"<imaginary/>")==temp) return 1;
	if (strstr(temp,"<int/>")==temp) return 1;
	if (strstr(temp,"<diff/>")==temp) return 1;
	if (strstr(temp,"<divergence/>")==temp) return 1;
	if (strstr(temp,"<grad/>")==temp) return 1;
	if (strstr(temp,"<curl/>")==temp) return 1;
	if (strstr(temp,"<laplacian/>")==temp) return 1;
	if (strstr(temp,"<mean/>")==temp) return 1;
	if (strstr(temp,"<sdev/>")==temp) return 1;
	if (strstr(temp,"<variance/>")==temp) return 1;
	if (strstr(temp,"<median/>")==temp) return 1;
	if (strstr(temp,"<mode/>")==temp) return 1;
	if (strstr(temp,"<limit/>")==temp) return 1;
	if (strstr(temp,"<moment/>")==temp) return 1;
	if (strstr(temp,"<sum/>")==temp) return 1;
	if (strstr(temp,"<product/>")==temp) return 1;
	if (strstr(temp,"<limit/>")==temp) return 1;
	if (strstr(temp,"<transpose/>")==temp) return 1;
	if (strstr(temp,"<selector/>")==temp) return 1;
	if (strstr(temp,"<vectorproduct/>")==temp) return 1;
	if (strstr(temp,"<scalarproduct/>")==temp) return 1;
	if (strstr(temp,"<outerproduct/>")==temp) return 1;
	if (strstr(temp,"<card/>")==temp) return 1;
	if (strstr(temp,"<max/>")==temp) return 1;
	if (strstr(temp,"<min/>")==temp) return 1;
	if (strstr(temp,"<forall/>")==temp) return 1;
	if (strstr(temp,"<exists/>")==temp) return 1;
	if (strstr(temp,"<abs/>")==temp) return 1;
	if (strstr(temp,"<conjugate/>")==temp) return 1;
	if (strstr(temp,"<arg/>")==temp) return 1;
	if (strstr(temp,"<floor/>")==temp) return 1;
	if (strstr(temp,"<ceiling/>")==temp) return 1;

	if (strstr(temp,"<inverse/>")==temp) return 1;
	if (strstr(temp,"<domain/>")==temp) return 1;
	if (strstr(temp,"<codomain/>")==temp) return 1;
	if (strstr(temp,"<image/>")==temp) return 1;

	if (strstr(temp,"<factorial/>")==temp) return 1;
	//if (strstr(temp,"<tendsto/>")==temp) return wrapped[complete=tendsto];
	//if (strstr(temp,"<in/>")==temp) return wrapped[complete=in];
	//if (strstr(temp,"<notin/>")==temp) return wrapped[complete=notin];
	//if (strstr(temp,"<intersect/>")==temp) return wrapped[complete=intersect];
	//if (strstr(temp,"<union/>")==temp) return wrapped[complete=union_];
	//if (strstr(temp,"<compose/>")==temp) return wrapped[complete=compose];
	//if (strstr(temp,"<power/>")==temp) return wrapped[complete=power];
	//if (strstr(temp,"<divide/>")==temp) return wrapped[complete=divide];
	//if (strstr(temp,"<times/>")==temp) return wrapped[complete=times];
	//if (strstr(temp,"<minus/>")==temp) return wrapped[complete=minus];
	//if (strstr(temp,"<plus/>")==temp) return wrapped[complete=plus];
	//if (strstr(temp,"<rem/>")==temp) return wrapped[complete=rem];
	//if (strstr(temp,"<gt/>")==temp) return wrapped[complete=gt];
	//if (strstr(temp,"<lt/>")==temp) return wrapped[complete=lt];
	//if (strstr(temp,"<eq/>")==temp) return wrapped[complete=eq];
	//if (strstr(temp,"<neq/>")==temp) return wrapped[complete=neq];
	//if (strstr(temp,"<geq/>")==temp) return wrapped[complete=geq];
	//if (strstr(temp,"<leq/>")==temp) return wrapped[complete=leq];
	//if (strstr(temp,"<equivalent/>")==temp) return wrapped[complete=equivalent];
	//if (strstr(temp,"<approx/>")==temp) return wrapped[complete=approx];
	//if (strstr(temp,"<cartesianproduct/>")==temp) return wrapped[complete=cartesianproduct];
	//if (strstr(temp,"<setdiff/>")==temp) return wrapped[complete=setdiff];
	//if (strstr(temp,"<subset/>")==temp) return wrapped[complete=subset];
	//if (strstr(temp,"<prsubset/>")==temp) return wrapped[complete=prsubset];
//	if (strstr(temp,"<notsubset/>")==temp) return wrapped[complete=notsubset];
//	if (strstr(temp,"<notprsubset/>")==temp) return wrapped[complete=notprsubset];
//	if (strstr(temp,"<and/>")==temp) return wrapped[complete=and];
//	if (strstr(temp,"<or/>")==temp) return wrapped[complete=or];
//	if (strstr(temp,"<xor/>")==temp) return wrapped[complete=xor];
//	if (strstr(temp,"<implies/>")==temp) return wrapped[complete=implies];

	if (strstr(temp,"<arccos/>")==temp) return 1;
	if (strstr(temp,"<arccosh/>")==temp) return 1;
	if (strstr(temp,"<arcsin/>")==temp) return 1;
	if (strstr(temp,"<arcsinh/>")==temp) return 1;
	if (strstr(temp,"<arctan/>")==temp) return 1;
	if (strstr(temp,"<arctanh/>")==temp) return 1;
	if (strstr(temp,"<arg/>")==temp) return 1;
	if (strstr(temp,"<cos/>")==temp) return 1;
	if (strstr(temp,"<cosh/>")==temp) return 1;
	if (strstr(temp,"<cot/>")==temp) return 1;
	if (strstr(temp,"<arccot/>")==temp) return 1;
	if (strstr(temp,"<coth/>")==temp) return 1;
	if (strstr(temp,"<arccoth/>")==temp) return 1;
	if (strstr(temp,"<csc/>")==temp) return 1;
	if (strstr(temp,"<arccsc/>")==temp) return 1;
	if (strstr(temp,"<csch/>")==temp) return 1;
	if (strstr(temp,"<arccsch/>")==temp) return 1;
	if (strstr(temp,"<determinant/>")==temp) return 1;
	if (strstr(temp,"<exp/>")==temp) return 1;
	if (strstr(temp,"<ln/>")==temp) return 1;
	if (strstr(temp,"<log/>")==temp) return 1;
	if (strstr(temp,"<max/>")==temp) return 1;
	if (strstr(temp,"<min/>")==temp) return 1;
	if (strstr(temp,"<sec/>")==temp) return 1;
	if (strstr(temp,"<arcsec/>")==temp) return 1;
	if (strstr(temp,"<sech/>")==temp) return 1;
	if (strstr(temp,"<arcsech/>")==temp) return 1;
	if (strstr(temp,"<sin/>")==temp) return 1;
	if (strstr(temp,"<sinh/>")==temp) return 1;
	if (strstr(temp,"<tan/>")==temp) return 1;
	if (strstr(temp,"<tanh/>")==temp) return 1;

	return 0;
}

int IsMMLContainerEnd(char*temp){
	if (*(temp+1)!='/') return 0;
	if (strstr(temp,"</mtable>")==temp) return 1;
	if (strstr(temp,"</mlabeledtr")==temp) return 1;
	if (strstr(temp,"</mtr>")==temp) return 1;
	if (strstr(temp,"</mtd>")==temp) return 1;
	if (strstr(temp,"</mrow>")==temp) return 1;
	if (strstr(temp,"</mtext>")==temp) return 1;
	if (strstr(temp,"</mi>")==temp) return 1;
	if (strstr(temp,"</mn>")==temp) return 1;
	if (strstr(temp,"</mo>")==temp) return 1;
	if (strstr(temp,"</mover>")==temp) return 1;
	if (strstr(temp,"</munder>")==temp) return 1;
	if (strstr(temp,"</msub>")==temp) return 1;
	if (strstr(temp,"</msup>")==temp) return 1;
	if (strstr(temp,"</msubsup>")==temp) return 1;
	if (strstr(temp,"</mfrac>")==temp) return 1;
	if (strstr(temp,"</msqrt>")==temp) return 1;
	if (strstr(temp,"</mroot>")==temp) return 1;
	if (strstr(temp,"</ms>")==temp) return 1;

	if (strstr(temp,"</ci>")==temp) return 1;
	if (strstr(temp,"</cn>")==temp) return 1;
	if (strstr(temp,"</csymbol>")==temp) return 1;
	if (strstr(temp,"</apply>")==temp) return 1;
	if (strstr(temp,"</logbase>")==temp) return 1;
	if (strstr(temp,"</bvar>")==temp) return 1;
	if (strstr(temp,"</degree>")==temp) return 1;
	if (strstr(temp,"</condition>")==temp) return 1;
	if (strstr(temp,"</vector>")==temp) return 1;
	if (strstr(temp,"</matrix>")==temp) return 1;
	if (strstr(temp,"</matrixrow>")==temp) return 1;
	if (strstr(temp,"</lowlimit>")==temp) return 1;
	if (strstr(temp,"</uplimit>")==temp) return 1;
	if (strstr(temp,"</moment>")==temp) return 1;
	if (strstr(temp,"</momentabout>")==temp) return 1;
	if (strstr(temp,"</set>")==temp) return 1;
	if (strstr(temp,"</list>")==temp) return 1;
	if (strstr(temp,"</interval>")==temp) return 1;
	if (strstr(temp,"</piece>")==temp) return 1;
	if (strstr(temp,"</piecewise>")==temp) return 1;

	return 0;
}
int IsMMLContainerStart(char*temp){
	if(*(temp+1)=='m'){
		if (strstr(temp,"<mtable")==temp) return 1;
		if (strstr(temp,"<mlabeledtr")==temp) return 1;
		if (strstr(temp,"<mtr")==temp) return 1;
		if (strstr(temp,"<mtd")==temp) return 1;
		if (strstr(temp,"<mrow")==temp) return 1;
		if (strstr(temp,"<mtext")==temp) return 1;
		if (strstr(temp,"<mi")==temp) return 1;
		if (strstr(temp,"<mn")==temp) return 1;
		if (strstr(temp,"<mover")==temp) return 1;
		if (strstr(temp,"<munder")==temp) return 1;
		if (strstr(temp,"<mo")==temp) return 1;
		if (strstr(temp,"<msubsup")==temp) return 1;
		if (strstr(temp,"<msub")==temp) return 1;
		if (strstr(temp,"<msup")==temp) return 1;
		if (strstr(temp,"<mfrac")==temp) return 1;
		if (strstr(temp,"<msqrt")==temp) return 1;
		if (strstr(temp,"<mroot")==temp) return 1;
		if (strstr(temp,"<ms")==temp) return 1;
	}
	if (strstr(temp,"<ci")==temp) return 1;
	if (strstr(temp,"<cn")==temp) return 1;
	if (strstr(temp,"<csymbol")==temp) return 1;
	if (strstr(temp,"<apply")==temp) return 1;
	if (strstr(temp,"<logbase")==temp) return 1;
	if (strstr(temp,"<bvar")==temp) return 1;
	if (strstr(temp,"<degree")==temp) return 1;
	if (strstr(temp,"<condition")==temp) return 1;
	if (strstr(temp,"<vector")==temp) return 1;
	if (strstr(temp,"<matrix")==temp) return 1;
	if (strstr(temp,"<matrixrow")==temp) return 1;
	if (strstr(temp,"<lowlimit")==temp) return 1;
	if (strstr(temp,"<uplimit")==temp) return 1;
	if (strstr(temp,"<moment")==temp) return 1;
	if (strstr(temp,"<momentabout")==temp) return 1;
	if (strstr(temp,"<set")==temp) return 1;
	if (strstr(temp,"<list")==temp) return 1;
	if (strstr(temp,"<interval")==temp) return 1;
	if (strstr(temp,"<piece")==temp) return 1;
	if (strstr(temp,"<piecewise")==temp) return 1;

	return 0;
}

int IsMMLConstant(char*temp){
	if (strstr(temp,"<integers/>")==temp) return 1;
	if (strstr(temp,"<reals/>")==temp) return 1;
	if (strstr(temp,"<rationals/>")==temp) return 1;
	if (strstr(temp,"<naturalnumbers/>")==temp) return 1;
	if (strstr(temp,"<complexes/>")==temp) return 1;
	if (strstr(temp,"<primes/>")==temp) return 1;
	if (strstr(temp,"<exponentiale/>")==temp) return 1;
	if (strstr(temp,"<imaginaryi/>")==temp) return 1;
	if (strstr(temp,"<notanumber/>")==temp) return 1;
	if (strstr(temp,"<true/>")==temp) return 1;
	if (strstr(temp,"<false/>")==temp) return 1;
	if (strstr(temp,"<emptyset/>")==temp) return 1;
	if (strstr(temp,"<pi/>")==temp) return 1;
	if (strstr(temp,"<eulergamma/>")==temp) return 1;
	if (strstr(temp,"<infinity/>")==temp) return 1;
	if (strstr(temp,"<ident/>")==temp) return 1;
	return 0;
}

char* Insert(char*at,char*what){
	//return a pointer to the next byte after the inserted string
	char*s,*final;
	if(*at){
		s=(char*)malloc(strlen(at)+1);
		strcpy(s,at);
		strcpy(at,what);final=strrchr(at,0);
		strcat(at,s);
		free(s);
	}else{
		strcpy(at,what);final=strrchr(at,0);
	}
	assert(final);
	return final;
}


char* MatchTagLeft(char*from, char*what){ //start from closing tag, match to left
	char*temp=from,*ctag;
	int wraps=1;
	ctag=(char*)malloc(strlen(what)+2);
	strcpy(ctag,"</");strcat(ctag,what+1);//assuming 'what' is an opening tag
	while(wraps){
		if (temp==doc_math) {
			free(ctag);
			die("can't match tag left...");
		}
		temp--;
		while(temp!=strstr(temp,what)) {
			if (temp==strstr(temp," RD ")) temp=SkipBracketsLeft(temp);
			else if (temp==strstr(temp,ctag)) wraps++;
			temp--;
			if (temp==doc_math && temp!=strstr(temp,what)){
				free(ctag);
				die("error:\ncan't match tag left...\n");
			}
		}
		wraps--;
		assert(wraps>=0);
	}
	free(ctag);
	assert(temp);
	return temp;
}

char* MatchTagRight(char*from){
	//in: pointer to a starting tag
	//returns: a pointer to the first byte after 
	//the corresponding enclosing tag
	char *temp,*btag,*etag,*check;
	int wraps=1, len=strcspn(from,"> ");

	//create the begin and end tags
	temp=from;
	if (temp==strstr(temp,"<apply")){
		len=strcspn(from,"/");
		btag=(char*)malloc(len+3);
		check=btag;
		while(*temp!='/')
			*check++=*temp++;
		*check=0;
		strcat(btag,"/>");
		len=strcspn(btag,"> ");
		etag=(char*)malloc(len+3);
		strcpy(etag,"</");
		check=strrchr(etag,0);temp=btag+1;
		while(*temp!='>' && *temp!=' ')
			*check++=*temp++;
		*check=0;
		strcat(etag,">");
	}else{
		btag=(char*)malloc(len+2);
		check=btag;
		while(*temp!='>' && *temp!=' ')
			*check++=*temp++;
		*check=0;
		etag=(char*)malloc(strlen(btag)+3);
		strcpy(etag,"</");strcat(etag,btag+1);strcat(etag,">");
	}

	if (!strstr(from,etag)){
		printf("\n error:\ninput was:\n %s\n", doc_math);
		printf("for %s, couldn't find '%s' tag...\n", btag,etag);
		free(btag);
		free(etag);
		yyerror("");
	}

	temp=from;
	while(wraps){
		temp++;
		while(temp!=strstr(temp,etag)) {
			if (temp==strstr(temp," LD ")) temp=SkipBracketsRight(temp);
			else {
				if (temp==strstr(temp,btag)) wraps++;
				else {
					if (temp==strstr(temp,"<apply>")){
						check=strstr(temp,">");check++;
						check=strstr(check,"<");
						if (IsComplete(check) && btag==strstr(btag,"<apply>")) wraps ++;
					}
				}
				if (*temp) temp++;
				else {
					printf("\ncan't find end tag %s for starting tag %s...\n", etag,btag);
					free(btag);
					free(etag);
					yyerror("");
				}
			}
		}
		wraps--;
		assert(wraps>=0);
	}
	assert(temp);
	temp+=strlen(etag);
	free(btag);
	free(etag);
	return temp;
}

char* SkipBracketsLeft(char*from){//assume start from right bracket
	int wraps=1;
	char*temp=from;
	while(wraps) {
		temp--;
		if(temp!=strstr(temp," LD ")){
			if(temp==strstr(temp," RD ")) wraps++;
		}else wraps--;
	}
	assert(temp);
	return temp;
}

char* SkipBracketsRight(char*from){//assume start from left bracket
	int wraps=1;
	char*temp=from+strlen(" LD ");
	temp--;
	while(wraps) {
		temp++;
		if(temp!=strstr(temp," RD ")){
			if(temp==strstr(temp," LD ")) wraps++;
		}else wraps--;
	}
	assert(temp);
	temp+=strlen(" RD ");
	return temp;
}

void pretty(char*s, int eraseBrackets){

	char* temp,*pick,*shadow=0;
	int spaces;
	temp=s;pick=s;
	spaces=0;
	if (eraseBrackets && strstr(s," LD ")){ //strip LDs
		shadow=temp=(char*)malloc(strlen(s)+1);
		while(*pick){
			if (pick!=strstr(pick," LD ") && pick!=strstr(pick," RD ")) {
					*shadow++=*pick++;
			}else
				pick+=strlen(" LD ");
		}
		*shadow=0;
		shadow=temp;
	}
	if (mathblock)	
		printf("<math xmlns=\"http://www.w3.org/1998/Math/MathML\" display=\"block\"");
	else	
		printf("<math xmlns=\"http://www.w3.org/1998/Math/MathML\"");
		
	//print indented
	if (*id) printf(" id=\"%s\">",id);
	else printf(">");
	*id=0;
	while (*temp){
		if (IsMMLContainerStart(temp)){
			temp=IndentContainer(temp,&spaces,1);
		}else{
			if (IsMMLContainerEnd(temp)){
				temp=IndentContainer(temp,&spaces,0);
			}else
				printf("%c",*temp++);
		}
	}
	// we check a kind of wellformedness here 
	if (spaces) 
		die("\nwellformedness error: an opening/closing parenthesis is missing...\n");
	printf("\n</math>\n");
	if (eraseBrackets && shadow) free (shadow);

}

char* IndentContainer(char*pos,int* spaces,int start){
	int i;
	if (start){
		printf("\n");
		i=*spaces;
		while (i-- >0) fputc(' ',stdout);
		if (*(pos+1)=='a'){
			if (strstr(pos,"<apply>")==pos){
				do{	fputc(*pos,stdout);
				}while(strstr(pos,"/>")!=pos++);
			}
		}
		do{	fputc(*pos,stdout);
		}while(*pos++!='>');

		while(*pos && *pos!='<' && (!(*pos=='/' && *(pos+1)=='>')) )
			fputc(*pos++,stdout);
		if((*pos=='/' && *(pos+1)=='>')||(*pos=='<' && *(pos+1)=='/')){
			while(*pos && *pos!='>') fputc(*pos++,stdout);
			(*spaces)--;
		}
		(*spaces)++;
	}else{
		printf("\n");
		(*spaces)-=1;i=*spaces;
		while (i-- >0) fputc(' ',stdout);
		do{	fputc(*pos,stdout);
		}while(*pos && *pos++!='>');
	}
	return pos;
}

void Clean(char*from, char*what,int how){
//how=0 clean just "<apply><times/> what"
//how=1 clean just "what"
//how=2 clean both "<apply><times/> what" and "what" after
	char *temp=from,*tail,*trash;
	if (how==0 || how==2){
		trash=(char*)malloc(strlen("<apply><times/>")+strlen(what)+1);
		strcpy(trash,"<apply><times/>");strcat(trash,what);
		while ((temp=strstr(temp,trash))){		// clean the 'trash' starting at 'from'
			tail=(char*)malloc(strlen(temp)+1);
			strcpy(tail,temp+strlen(trash));
			*temp=0;
			strcpy(temp,tail);
			free(tail);
		}
		free(trash);
	}
	temp=from;
	if (how==1 || how==2){
		while ((temp=strstr(temp,what))){		// clean the 'what' starting at 'from'
			tail=(char*)malloc(strlen(temp)+1);
			strcpy(tail,temp+strlen(what));
			*temp=0;
			strcpy(temp,tail);
			free(tail);
		}
	}
}

void flushText()
{
	int length;
	if (doc_text){
		if (*doc_text==0) return;
		length=strlen(doc_text);
		assert(length<LIMIT);
		fprintf(stdout,"%s\n",doc_text);*doc_text=0;
	}
}

void flushMath()
{
char*temp,*lock;
int length=strlen(doc_math);
assert(length<LIMIT);
//fprintf(stderr,"math:%s\n",doc_math);
if (mathBox) die("bug: found unbalanced mathBox\n");
//there should be no random spaces between tags in 'doc_math'
	fixBackParsedPrimitive("<OVER/>");
	fixBackParsedPrimitive("<ATOP/>");
	fixBackParsedPrimitive("<CHOOSE/>");
	fixLabels();
	fixIds();
	
	if ((lock=temp=strstr(doc_math,"<source"))){//fake math, it was a figure
		temp=strstr(temp,"</source>");
		temp=strstr(temp,">");
		temp++;*temp=0;
		fprintf(stdout,"\n%s\n",lock);
	}else
		pretty(doc_math,1);
	*doc_math=0;
	return;
};

void die(char* text){
	fprintf(stderr,"\n%s\n",text);
	yyerror("");
}

void fixLabels(){
//getting the full math string
//locating and positioning Labels:
//creating mtable with mlabeledtr wrappers where found
char *temp=doc_math,*tail,*lock,*pelabel,*plabel=label;
//fprintf(stdout,":www:%s\n",doc_math);
	while((temp=strstr(doc_math,"<label>"))){
		if (temp==doc_math){
			//simple left labeled expression
			//copy label contents
			lock=strstr(temp,">");
			lock++;
			while(*lock && *lock!='<'){
				*plabel++=*lock++;
			};
			*plabel=0;
			lock=strstr(lock,">");
			if (lock){
				lock++;
				//backup the rest of doc_math
				tail=(char*)malloc(strlen(lock)+1);
				strcpy(tail,lock);
				strcpy(doc_math,"<mtable><mlabeletdr><mtd><mtext>");
				strcat(doc_math,label);
				strcat(doc_math,"</mtext></mtd><mtd>");
				strcat(doc_math,tail);
				strcat(doc_math,"</mtd></mlabeletdr></mtable>");
				free(tail);
			}
			return;
		}
		temp=strstr(temp,"<label>");
		pelabel=strstr(temp,"</label>");
		//copy label contents
		lock=strstr(temp,">");lock++;
		plabel=label;
		while(lock!=pelabel){
			*plabel++=*lock++;
		};
		*plabel=0;
		lock=strstr(lock,">");lock++;
		//rid of the label element
		tail=(char*)malloc(strlen(lock)+1);
		strcpy(tail,lock);
		strcpy(temp,tail);
		free(tail);
		if (temp==strstr(temp,"</mtr>")){
			temp+=3;
			Insert(temp,"labeled");
			temp=MatchTagLeft(temp,"<mtr");
			temp+=2;
			Insert(temp,"labeled");
			temp=strstr(temp,">");temp++;
			temp=Insert(temp,"<mtd><mtext>");
			temp=Insert(temp,label);
			Insert(temp,"</mtext></mtd>");
		}else{
			//label is the last
			//if (*temp) die("error:label should be the last, and it isn't\n");
			strcat(doc_math,"</mtd></mlabeledtr></mtable>");
			temp=doc_math;
			temp=Insert(temp,"<mtable><mlabeledtr><mtd><mtext>");
			temp=Insert(temp,label);
			Insert(temp,"</mtext></mtd><mtd>");
		}
	}
}

void fixBackParsedPrimitive(const char * what)
{
	char *temp=doc_math,*tail,*lock;
	
	while((temp=strstr(doc_math,what))){
		lock=strstr(temp,">");lock++;
		tail=(char*)malloc(strlen(lock)+1);
		strcpy(tail,lock);
		*temp=0;
	
		temp=MatchTagLeft(temp,"<mrow");
		temp=Insert(temp,"<mfrac");
		if (strcmp(what,"<OVER/>")==0)
			Insert(temp,">");
		else
			Insert(temp," linethickness=\"0\">");
		strcat(temp,"</mrow>");
		lock=strrchr(temp,0);
		strcat(temp,"<mrow>");
		strcat(temp,tail);
		free (tail);
		temp=MatchTagRight(lock);
		Insert(temp,"</mfrac>");
	}
}

void fixIds(){
//getting the full math string
//locating and positioning Ids:
//moving id labels content from cells to their parent rows
char *temp=doc_math,*tail,*lock,*pid=id;

	while((temp=strstr(doc_math,"<id>"))){
		temp=strstr(temp,"<id>");
		//copy id contents
		lock=strstr(temp,">");lock++;
		pid=id;
		while(*lock!='<'){
			*pid++=*lock++;
		};
		*pid=0;
		lock=strstr(lock,">");lock++;
		//rid of the id element
		tail=(char*)malloc(strlen(lock)+1);
		strcpy(tail,lock);
		strcpy(temp,tail);
		free(tail);
		//locate the parent mtr or mlabeledtr
		//or point to the math wrapper
		lock=strstr(temp,"</mlabeledtr");
		tail=strstr(temp,"</mtr");
		if (lock&& tail){
			if (tail==strstr(lock,"</mtr>")){
				temp=lock;
				temp=MatchTagLeft(temp,"<mlabeledtr");
			}else{
				temp=tail;
				temp=MatchTagLeft(temp,"<mtr");
			}
		}else{
			if (tail){
				temp=tail;
				temp=MatchTagLeft(temp,"<mtr");
			}else{
				if (lock){
					temp=lock;
					temp=MatchTagLeft(temp,"<mlabeledtr");
				}else
					return;
			}
		}
		//and load the id
		temp=strstr(temp,">");
		temp=Insert(temp," id=\"");
		temp=Insert(temp,id);
		temp=Insert(temp,"\"");
		*id=0;
	}
}


//font mapping, no poetry here

void selectFont(unsigned int fnum){
	int i=0;
	while((*pFont)[i].number!=fnum) {
	i++;
		if (i>maxFontNr) 
		{fprintf(stderr,"error:\nfont number overflow, requested %d, available %d, quitting\n",i,maxFontNr); exit(EXIT_FAILURE);}
	}
	strcpy(theFont.name,(*pFont)[i].name);
	strcpy(theFont.size,(*pFont)[i].size);
	theFont.number=(*pFont)[i].number;
	theFont.map=(*pFont)[i].map;
	theFont.width=(*pFont)[i].width;
	theFont.family=(*pFont)[i].family;
	theFont.variant=(*pFont)[i].variant;
	theFont.style=(*pFont)[i].style;
	theFont.weight=(*pFont)[i].weight;

}

void mapFonts(int check){
//parsing fontname for encoding, variant, width, style and weight
int total=0,pos=0;
char* currentFont=theFont.name;
pos=strlen(theFont.name);
total=pos;
assert(pos);

//defaults
theFont.width=regularWidth;
theFont.family=serif;
theFont.variant=normal;
theFont.style=upright;
theFont.weight=normalWeight;
theFont.map=NULL;

//weight:abcdhjklmprsux
//var:cfikmostuvwxyz
//5[aistwz]
//6[abcdikmstwxyz]
//7[acdfkmtvyz] 
//8[234acefimnnqrtuvwxyz]
//9[cdeiostuxz]
//width:cenopqrtuvwx

//parsing the fontname backwards

	while((*currentFont=='z' && pos>2) || pos>1 ){
		switch(currentFont[pos]){
			case 'a': 
				switch(currentFont[pos-1]){
				case '8': 
					theFont.map=fontMap8a;
					break;
				case '7': //alternate characters, not mapped yet
					break;
				case '6': //T2A, not mapped yet
					break;
				case '5': //phonetic alternate, not mapped yet
					break;
				case 's':
					if (pos==2 && *currentFont=='m')	//msam
						theFont.map=fontMapMsam;
					break;
				case 'y':	//[px,tx]sya
						theFont.map=fontMapMsam;
					break;
				default:
					theFont.weight=hairline;
				}
			break;
			case 'b': 
				switch(currentFont[pos-1]){
				case '6': //cyrillic 7 bit from ISO 8859-5, not mapped yet
					break;
				case 's':
					if (pos==2 && *currentFont=='m')	//msbm
						theFont.map=fontMapMsbm;
					else
						theFont.weight=bold;
					break;
				case 'c':	
					if (pos==2 && *currentFont=='e')	//ecb
						theFont.map=fontMap8t;
					if (pos==2 && *currentFont=='t')	//tcb
						theFont.map=fontMap8c;
					theFont.weight=bold;
					break;
				case 'e':
					if (pos==2 && *currentFont=='a')	//aeb
					{
						theFont.map=fontMap8t;
						theFont.weight=bold;
					}
				break;
				case 'm': //cmb
					if (currentFont[pos-2]=='c')	//cmb..
						if (!theFont.map) theFont.map=fontMap7t;
						theFont.weight=bold;
					break;
				case 'y':	//[px,tx]syb
						theFont.map=fontMapMsbm;
						theFont.weight=bold;
					break;
				case 'l':
					if (currentFont[pos-2]=='p' && *currentFont=='p')	//pplb...
					if (!theFont.map) 	theFont.map=fontMapDvips;
					theFont.weight=bold;
				break;
				case 'x':
					if (!theFont.map) theFont.map=fontMap7t; //[t,p]x...
					theFont.weight=bold;
				break;
				default:
					theFont.weight=bold;
				}
			break;
			case 'c': 
				switch(currentFont[pos-1]){
				case '9': 
					theFont.map=fontMap8c;
					break;
				case '8':
					theFont.map=fontMap8c;	
					break;
				case '7':
					theFont.map=fontMap7c;	
					break;
				case '6':	//T2C, not mapped yet
					break;
				case 'c':
					if (pos==2 && *currentFont=='e')	//ecc... fonts
						if (!theFont.map) theFont.map=fontMap8t;
						theFont.variant=smallCaps;
					break;
				case 'm':
					if (pos==2 && *currentFont=='c')	//cmc... fonts
						if (!theFont.map) theFont.map=fontMap7tt;
					break;
				case 's':
					if (strstr(currentFont,"ec")==currentFont) {//ecsc
						theFont.style=italic;
						theFont.weight=black;
						}
					else{
						if (!theFont.map) theFont.map=fontMap7tt;
					}
					theFont.variant=smallCaps;
					break;
				default:
					if (pos>total/2+1)
						theFont.weight=black;
					else
						theFont.width=condensed;
				}
			break;
			case 'd': 
				switch(currentFont[pos-1]){
				case '9': 
					theFont.map=fontMap8t;	
					break;
				case '7':	//old style digit enc, not mapped yet
					break;
				case '6':	//cyrillic, CP866
					break;
				default:
					if (pos<total/2+1)
						theFont.weight=demiBold;
				}
			break;
			case 'e': 
				switch(currentFont[pos-1]){
				case '9': 
					theFont.map=fontMap8t;	
					break;
				case '8':	//Adobe CE, not mapped yet
					break;
				case 'u':
					if (*currentFont=='e')	//euex...
						theFont.map=fontMapMathExt;
				break;
				default:
					if (pos<total/2+1)
						theFont.width=expanded;
				}
				break;
			case 'f': 
				switch(currentFont[pos-1]){
				case '7':	//Fraction, not mapped yet
					break;
				case '8':	//TeXAfricanLatin, not mapped yet
					break;
				case 'm':
					theFont.map=fontMap7t; //[c]mff... 
					if (currentFont[pos+1]=='i')	//[c]mfi... 
						theFont.style=italic;
				break;
				case 'u':
					if (*currentFont=='e')	//eufm...
						theFont.map=fontMap7c;
				break;
				default:
					theFont.map=fontMap7c; //make it fraktur
				}
				break;
			case 'h': 
				theFont.weight=heavy; 
				break;
			case 'i': 
				switch(currentFont[pos-1]){
				case '5':	// PhoneticIPA, not mapped yet
					break;
				case '6':	//ISO 8859-5, not mapped yet
					break;
				case '8':	//TC and standard, not mapped yet
					break;
				case '9':	//TSOX, not mapped yet
					break;
				case 'm':	
					if (pos>2 && !theFont.map) theFont.map=fontMapMathItalic; 
					if (currentFont[pos+1]=='a') theFont.map=fontMapMathItalicA;	//[px,tx]mia
					break;
				case 'x':
				if (pos==2 && ((*currentFont=='t') ||(*currentFont=='p')))	//[p,t]xsi... fonts
					if (!theFont.map) theFont.map=fontMap7t;
				break;
				default:
					theFont.style=italic; 
				}
				break;
			case 'j': 
				theFont.weight=extraLight; 
				break;
			case 'k': //greek, not mapped yet
				break;
			case 'l': 
				if (currentFont[pos-1]=='s') theFont.style=oblique;
				else{
					if ((pos>2 && *currentFont!='z') ||(pos>3 && *currentFont=='z')) theFont.weight=light; 
				}
				break;
			case 'm': 
				switch(currentFont[pos-1]){
				case '6':	//cyrillic Macintosh encoding, not mapped yet
					break;
				case '7':	
					theFont.map=fontMapMathItalic;
					break;
				case '8':	//Macintosh standard encoding, not mapped yet
					break;
				case 'b':	
				if (*currentFont=='b') //bbm
					theFont.map=fontMap7t;
					theFont.family=doubleStruck;
					break;
				default:
					if (pos>6)
						theFont.map=fontMapMathItalic;
					else {
						if (strstr(currentFont,"cm")!=currentFont) theFont.weight=medium;
						}
				}
				break;
			case 'n': 
				switch(currentFont[pos-1]){
				case '8':	//LM1 textures???, not mapped yet
					break;
				default:
					if (!theFont.map)
						theFont.width=narrow;
				}
				break;
			case 'o': 
				switch(currentFont[pos-1]){
				case '9':	//expert+oldstyle+tex
					theFont.map=fontMap7t;
					break;
				default:
					if (pos<total/2)
						theFont.width=ultraCondensed;
					else
						theFont.style=oblique;
				}
				break;
			case 'q':
				if (currentFont[pos-1]=='8')
					theFont.map=fontMap8q;
				break;
			case 'r':
				switch(currentFont[pos-1]){
				case '8':	
					theFont.map=fontMap8r;
					break;
				case 'c':	
				if (!theFont.map && pos==2){ 
				if (*currentFont=='e')	//ecr... fonts
						theFont.map=fontMap8t;
					
				if (*currentFont=='t')	//tcr
						theFont.map=fontMap8c;
				}
				break;
				case 'e':	
				if (*currentFont=='a')//aer...
					theFont.map=fontMap8t;
				break;
				case 'l':
					if (currentFont[pos-2]=='p' && *currentFont=='p')	//pplr... fonts
						if (!theFont.map) theFont.map=fontMapDvips;
				break;
				case 'm': //cm
					if (currentFont[pos-2]=='c')	//cmr..
						if (!theFont.map)theFont.map=fontMap7t;
					break;
				case 'o': //co
					if (currentFont[pos-2]=='c')	//cor..
						if (!theFont.map)theFont.map=fontMap8t;
					break;
				case 's': //dsrom
					if (*currentFont=='d')	//dsr..
						if (!theFont.map)theFont.map=fontMap7t;
						theFont.family=doubleStruck;
					break;
				case 'u':
					if (*currentFont=='e')	//eur...
						theFont.map=fontMapMathItalic;
				break;
				case 'x': 
					if (pos==2 && *currentFont=='t')	//txr
						if (!theFont.map) theFont.map=fontMap7t;
					break;
				default:
					if (pos<total/2)
						theFont.width=ultraCondensed;
					else
						theFont.style=oblique;
				}
				break;
			case 's': 
				switch(currentFont[pos-1]){
				case '5':	//sil-IPA, not mapped yet
					break;
				case '6':	//Storm extra encoding, not mapped yet
					break;
				case '9':	//superfont, not mapped yet
					break;
				case 'a':
					if (pos==2 && *currentFont=='l')	//las... fonts
						theFont.map=fontMapLasy;
					break;
				case 'c':	
					if (!theFont.map && pos==2){
						if (*currentFont=='e')	//ecs...
							theFont.map=fontMap8t;
						if (*currentFont=='t')	//tcs...
							theFont.map=fontMap8c;
					} 
					break;
				case 'e': 
					if (*currentFont=='a')//aess...
						theFont.map=fontMap8t;
					break;
				case 'm':	
				if (pos==2 && *currentFont=='c')	//cms... fonts
					if (!theFont.map) theFont.map=fontMap7t;
				break;
				case 's':
					theFont.family=sans;
				break;
				case 'u':
					if (*currentFont=='e')	//eusm...
						theFont.map=fontMapMathSymbol;
				break;
				case 'x':
				if (pos==2 && ((*currentFont=='t') ||(*currentFont=='p')))	//[p,t]xsl... fonts
					if (!theFont.map) theFont.map=fontMap7t;
				break;
				default:
					if (pos<total/2)
						theFont.weight=semiBold;
					else
						theFont.family=sans;
				}
				break;
			case 't': 
				switch(currentFont[pos-1]){
				case '5': //TeX-IPA, not mapped yet
					break;
				case '6': //T2B, not mapped yet
					break;
				case '7': 
					theFont.map=fontMap7t;
					break;
				case '8': 
					theFont.map=fontMap8t;
					break;
				case '9': //expert??? + TeX
					theFont.map=fontMap7t;
					break;
				case 'c':
					if (pos==2){
						if (*currentFont=='e')	//ect..
							theFont.map=fontMap8t;
						if (*currentFont=='t')	//tct..
							theFont.map=fontMap8c;
						}
					break;
				case 'e': 
					if (*currentFont=='a')//aeti...
						theFont.map=fontMap8t;
					break;
				case 'm':
					if (pos>1 && currentFont[pos-2]=='c')	//cmt... 
						if (!theFont.map) theFont.map=fontMap7t;
					if (currentFont[pos+1]=='e' && currentFont[pos+2]=='x') //cmtex
						theFont.map=fontMapCmTeX;
				break;
				case 't':
					if ((*currentFont=='c' && currentFont[1]=='m')|| (currentFont[1]=='x' && (*currentFont=='t' || *currentFont=='p'))) {
						if (!theFont.map) theFont.map=fontMap7tt;
					}	else {
						if (!theFont.map) theFont.map=fontMap8t;
					}
					theFont.family=monospace;
				break;
				default:
					if (pos<total/2)
						theFont.width=thin;
					else 
						theFont.family=monospace;
				}
			break;
			case 'u': 
				switch(currentFont[pos-1]){
				case '8': 
					theFont.map=fontMap8u;
					break;
				case '9': //Unicode compatible???, not mapped yet
					break;
				case 'm': //cmu
					if (pos==2 && *currentFont=='c')
						theFont.map=fontMap7t;
					break;
				default:
					if (pos<total/2)	
						theFont.weight=ultraBlack;
					else 	
						theFont.width=ultraCompressed;
				}
			break;
			case 'v': 
				switch(currentFont[pos-1]){
				case '7': 
					theFont.map=fontMapMathExt;
					break;
				case '8': //TeX vietnamese, not mapped yet
					break;
				case 'm': 
					if (pos>1 && currentFont[pos-2]=='c')	//cmv... fonts
						theFont.map=fontMap7t;
					break;
				default:
					if (theFont.map)	
						theFont.width=extraExpanded;
					else
						theFont.map=fontMapMathExt;
				}
			break;
			case 'x': 
				switch(currentFont[pos-1]){
				case '1':
					if (pos==2 && *currentFont=='t')	//t1x...
						theFont.map=fontMap8t;
				break;
				case '6': //X2???, not mapped yet
					break;
				case '8':	//expert???, not mapped yet
					break;
				case '9': 
					theFont.map=fontMap8y;
					break;
				case 'c':
					switch(*currentFont){
						case 't':
							theFont.map=fontMap8c;	//tcx...
							break;
						case 'e':
							theFont.map=fontMap8t;	//ecx...
							theFont.variant=smallCaps;
							break;
					}
					break;
				case 'e':
					if (pos>2){	
						if (currentFont[pos+1]=='a') //[tx,px]exa... fonts
							theFont.map=fontMapMathExtA;
						if (currentFont[pos+1]==0)		//[cm,tx,px]ex... fonts
							theFont.map=fontMapMathExt;
					}
				break;
				case 'y':
					if (pos==2 && *currentFont=='t')	//tyx...
						theFont.map=fontMap8y;
				break;
				default:
					if (pos<total/2+1)
						theFont.weight=extraBold;
					else 
						theFont.width=extended;
				}
			break;
			case 'y': 
				switch(currentFont[pos-1]){
				case '6': //LCY???, not mapped yet
					break;
				case '8':	
					theFont.map=fontMap8y;
					break;
				case 's':
					switch(currentFont[pos+1]){
					case 'a':
						theFont.map=fontMapMsam;
						break;
					case 'b':
						theFont.map=fontMapMsbm;
						break;
					case 'c':
						theFont.map=fontMapMathSymbolC;
						break;
					default:
							theFont.map=fontMapMathSymbol;
					}
					break;
				default:
						theFont.map=fontMapMathSymbol;
				}
			break;
			case 'z': 
				switch(currentFont[pos-1]){
				case '5': //user, not mapped
					break;
				case '6': //user, not mapped
					break;
				case '7': //user, not mapped
					break;
				case '8': 
					theFont.map=fontMap8z;
					break;
				case '9': //user, not mapped
					break;
				}
			break;
		}
		pos--;
	}
		
	if (!theFont.map) {
		fontsMissing=1;
		if (!check && fontsMissing){
			fprintf(stderr,"\nerror: font %s not mapped yet\n",currentFont);
			die("");
		}
	}

//print the mapping
/*	
	fprintf(stderr,"%s\t",currentFont);
	fprintf(stderr,"M:");
	if (theFont.map==fontMap7t)
		fprintf(stderr,"7t");
	if (theFont.map==fontMap7tp)
		fprintf(stderr,"7p");
	if (theFont.map==fontMap7tt)
		fprintf(stderr,"7tt");
	if (theFont.map==fontMap7ttp)
		fprintf(stderr,"7ttp");
	if (theFont.map==fontMap8a)
		fprintf(stderr,"8a");
	if (theFont.map==fontMapDvips)
		fprintf(stderr,"Dvips");
	if (theFont.map==fontMap8r)
		fprintf(stderr,"8r");
	if (theFont.map==fontMap8a)
		fprintf(stderr,"8a");
	if (theFont.map==fontMap8t)
		fprintf(stderr,"8t");
	if (theFont.map==fontMap8c)
		fprintf(stderr,"8c");
	if (theFont.map==fontMap8q)
		fprintf(stderr,"qx");
	if (theFont.map==fontMap8y)
		fprintf(stderr,"8y");
	if (theFont.map==fontMap8z)
		fprintf(stderr,"8z");
	if (theFont.map==fontMap8u)
		fprintf(stderr,"8u");
	if (theFont.map==fontMapMathExt)
		fprintf(stderr,"mx");
	if (theFont.map==fontMapMathExtA)
		fprintf(stderr,"xa");
	if (theFont.map==fontMapMathSymbol)
		fprintf(stderr,"sy");
	if (theFont.map==fontMapMathSymbolC)
		fprintf(stderr,"cm");
	if (theFont.map==fontMapCmTeX)
		fprintf(stderr,"ct");
	if (theFont.map==fontMapMathItalic)
		fprintf(stderr,"mi");
	if (theFont.map==fontMapMathItalicA)
		fprintf(stderr,"ma");
	if (theFont.map==fontMapLasy)
		fprintf(stderr,"ly");
	if (theFont.map==fontMapWasy)
		fprintf(stderr,"wy");
	if (theFont.map==fontMap7c)
		fprintf(stderr,"7c");
	if (theFont.map==fontMapMsam)
		fprintf(stderr,"am");
	if (theFont.map==fontMapMsbm)
		fprintf(stderr,"bm");
	

	fprintf(stderr," F=");
	switch(theFont.family){
	case serif:
	fprintf(stderr,"se");
	break;
	case sans:
	fprintf(stderr,"ss");
	break;
	case monospace:
	fprintf(stderr,"tt");
	break;
	case cursive:
	fprintf(stderr,"sp");
	break;
	case fantasy:
	fprintf(stderr,"fn");
	break;
	case fraktur:
	fprintf(stderr,"fr");
	break;
	case doubleStruck:
	fprintf(stderr,"ds");
	break;
	}
	
	fprintf(stderr," V=");
	if (theFont.variant==smallCaps)
		fprintf(stderr,"c");
	else
		fprintf(stderr,"r");

	fprintf(stderr," S=");
	switch(theFont.style){
	case upright:
	fprintf(stderr,"r");
	break;
	case italic:
	fprintf(stderr,"i");
	break;
	case oblique:
	fprintf(stderr,"o");
	break;
	}
	
	fprintf(stderr," W=");
	switch(theFont.width){
	case ultraCompressed:
	fprintf(stderr,"ucm");
	break;
	case ultraCondensed:
	fprintf(stderr,"ucn");
	break;
	case extraCondensed:
	fprintf(stderr,"ecn");
	break;
	case compressed:
	fprintf(stderr,"cmp");
	break;
	case condensed:
	fprintf(stderr,"cnd");
	break;
	case thin:
	fprintf(stderr,"thn");
	break;
	case narrow:
	fprintf(stderr,"nrw");
	break;
	case regularWidth:
	fprintf(stderr,"reg");
	break;
	case extended:
	fprintf(stderr,"ext");
	break;
	case expanded:
	fprintf(stderr,"exp");
	break;
	case extraExpanded:
	fprintf(stderr,"eex");
	break;
	case wide:
	fprintf(stderr,"wid");
	break;
	}

	fprintf(stderr," G=");
	switch(theFont.weight){
	case hairline:
	fprintf(stderr,"hrl");
	break;
	case extraLight:
	fprintf(stderr,"xli");
	break;
	case light:
	fprintf(stderr,"lit");
	break;
	case book:
	fprintf(stderr,"bok");
	break;
	case normalWeight:
	fprintf(stderr,"reg");
	break;
	case medium:
	fprintf(stderr,"med");
	break;
	case demiBold:
	fprintf(stderr,"dbo");
	break;
	case semiBold:
	fprintf(stderr,"sbo");
	break;
	case bold:
	fprintf(stderr,"bol");
	break;
	case extraBold:
	fprintf(stderr,"xbo");
	break;
	case heavy:
	fprintf(stderr,"hvy");
	break;
	case black:
	fprintf(stderr,"bla");
	break;
	case ultraBlack:
	fprintf(stderr,"ubl");
	break;
	case poster:
	fprintf(stderr,"pst");
	break;
	}

	fprintf(stderr,"\n");		
*/
	
}

void fontMap7t(){//cmr 7 bit
unsigned char* temp=(unsigned char*)yytext;
do{
	switch(*temp){
	case 0x00:pMathType=mo;pmt(0x0393);break;//Gamma
	case 0x01:pMathType=mo;pmt(0x0394);break;//Delta
	case 0x02:pMathType=mo;pmt(0x0398);break;//Theta
	case 0x03:pMathType=mo;pmt(0x039B);break;//Lambda
	case 0x04:pMathType=mo;pmt(0x039E);break;//Xi
	case 0x05:pMathType=mo;pmt(0x03A0);break;//Pi
	case 0x06:pMathType=mo;pmt(0x03A3);break;//Sigma
	case 0x07:pMathType=mo;pmt(0x03D2);break;//Upsilon with hook
	case 0x08:pMathType=mo;pmt(0x03A6);break;//Phi
	case 0x09:pMathType=mo;pmt(0x03A8);break;//Psi
	case 0x0A:pMathType=mo;pmt(0x03A9);break;//Omega
	case 0x0B:pMathType=mo;pmt('f');pMathType=mo;pmt('f');break;//p(ul2utf8(0xFB00));break;//ligature ff
	case 0x0C:pMathType=mo;pmt('f');pMathType=mo;pmt('i');break;//p(ul2utf8(0xFB01));break;//ligature fi
	case 0x0D:pMathType=mo;pmt('f');pMathType=mo;pmt('l');break;//p(ul2utf8(0xFB02));break;//ligature fl
	case 0x0E:pMathType=mo;pmt('f');pMathType=mo;pmt('f');pMathType=mo;pmt('i');break;//p(ul2utf8(0xFB03));break;//ligature ffi
	case 0x0F:pMathType=mo;pmt('f');pMathType=mo;pmt('f');pMathType=mo;pmt('l');break;//p(ul2utf8(0xFB04));break;//ligature ffl

	case 0x10:pMathType=mo;pmt(0x0131);break;//imath
	case 0x11:pMathType=mo;pmt(0x006A);break;//jmath,pmt(0x0237);break;//jmath
	case 0x12:
		if (spacing || mathmode) {pMathType=mo;pmt(0x0060);spacing=0;} 
		else 	combiningUnicode=0x0300;
		break;	//grave accent
	case 0x13:
		if (spacing || mathmode) {pMathType=mo;pmt(0x00B4);spacing=0;} 
		else 	combiningUnicode=0x0301;
		break;	//acute accent
	case 0x14:
		if (spacing || mathmode) {pMathType=mo;pmt(0x02C7);spacing=0;} 
		else 	combiningUnicode=0x030C;
		break;	//caron, hacek
	case 0x15:
		if (spacing || mathmode) {pMathType=mo;pmt(0x02D8);spacing=0;} 
		else 	combiningUnicode=0x0306;
		break;	//breve
	case 0x16:
		if (spacing || mathmode) {pMathType=mo;pmt(0x00AF);spacing=0;} 
		else 	combiningUnicode=0x0304;
		break;	//macron
	case 0x17:pMathType=mo;pmt(0x02DA);break;//ring above
	case 0x18:pMathType=mo;pmt(0x00B8);break;//cedilla
	case 0x19:pMathType=mo;pmt(0x00DF);break;//german SS
	case 0x1A:pMathType=mo;pmt(0x00E6);break;//latin ae
	case 0x1B:pMathType=mo;pmt(0x0153);break;//latin oe
	case 0x1C:pMathType=mo;pmt(0x00F8);break;//o slash
	case 0x1D:pMathType=mo;pmt(0x00C6);break;//latin AE
	case 0x1E:pMathType=mo;pmt(0x0152);break;//latin OE
	case 0x1F:pMathType=mo;pmt(0x00D8);break;//O slash

	case 0x20:combiningUnicode=0x0337;break;//.notdef, overlay short solidus
	case 0x21:pMathType=mo;pmt(*temp);break;//!
	case 0x22:pMathType=mo;pmt(0x201D);break;//right double quotation mark
	case 0x23://number sign
	case 0x24://US dollar symbol
	case 0x25:pMathType=mo;pmt(*temp);break;//percent
	case 0x26://ampersand
		if (mathmode && !mathText){
			p("<mo>&amp;</mo>");
		}else 
			p("&amp;");
		break;
	case 0x27:pMathType=mo;pmt(*temp);break;//'
	case 0x28:pMathType=mo;pmt(*temp);break;//(
	case 0x29:pMathType=mo;pmt(*temp);break;//)
	case 0x2A://asterisk
	case 0x2B://plus
	case 0x2C:inhibitspace=0;pMathType=mo;pmt(*temp);break;//comma
	case 0x2D://hyphen
	case 0x2E://period
	case 0x2F:pMathType=mo;pmt(*temp);break;//slash

	case 0x30:
	case 0x31:
	case 0x32:
	case 0x33:
	case 0x34:
	case 0x35:
	case 0x36:
	case 0x37:
	case 0x38:
	case 0x39:pMathType=mn;pmt(*temp);break;//numbers 0-9
	case 0x3A:pMathType=mo;pmt(*temp);break;//:
	case 0x3B:pMathType=mo;pmt(*temp);break;//;
	case 0x3C:pMathType=mo;pmt(0x00A1);break;//inverted exclamation mark
	case 0x3D: //equal
		pMathType=mo;
		precomposedNegative(*temp, 0x2260);
		break;
	case 0x3E:pMathType=mo;pmt(0x00BF);break;//inverted question mark
	case 0x3F:pMathType=mo;pmt(*temp);break;//?

	case 0x40:pMathType=mo;pmt(*temp);break;//@ //at
	
	//A to Z go to default: mo
	
	case 0x5B:pMathType=mo;pmt(*temp);break;//[
	case 0x5C:pMathType=mo;pmt(0x201C);break;//left double quotation mark
	case 0x5D:pMathType=mo;pmt(*temp);break;//]
	case 0x5E:
		if (spacing || mathmode) {pMathType=mo;pmt(*temp);spacing=0;} 
		else 	combiningUnicode=0x0302;
		break;	//hat
	case 0x5F:
		if (spacing || mathmode) {pMathType=mo;pmt(0x02D9);spacing=0;} 
		else 	combiningUnicode=0x0307;
		break;	//dot above

	case 0x60:pMathType=mo;pmt(*temp);break;//`//quoteleft
	
	//a to z go to default: mo
	
	case 0x7B:pMathType=mo;pmt(0x2013);break;//en dash
	case 0x7C:pMathType=mo;pmt(0x2014);break;//em dash
	case 0x7D:pMathType=mo;pmt(0x02DD);break;//double acute accent, 0x30B combining
	case 0x7E:
		if (spacing || mathmode) {pMathType=mo;pmt(*temp);spacing=0;} 
		else combiningUnicode=0x0342;
		break;	//diaeresis
	case 0x7F:
		if (spacing || mathmode) {pMathType=mo;pmt(0x00A8);spacing=0;} 
		else combiningUnicode=0x0308;
		break;	//diaeresis
	
	case 0x8A:pMathType=mo;pmt(0x0141);break;//L with stroke
	case 0xA2:pMathType=mo;pmt(*temp);break;//cent sign
	case 0xA3:pMathType=mo;pmt(*temp);break;//pound sign
	case 0xAA:pMathType=mo;pmt(0x0142);break;//l with stroke
	case 0xC5:pMathType=mo;pmt(*temp);break;//A with ring above, Angstrom
	case 0xE5:pMathType=mo;pmt(*temp);break;//a with ring above
	default:pMathType=mo;pmt(*temp);
	}
	temp++;
}while(*temp);
return;
}

void fontMap7tp(){//OT1++ (pound for dollar)
unsigned char* temp=(unsigned char*)yytext;
do{
	switch(*temp){
	case 0x00:pMathType=mo;pmt(0x0393);break;//Gamma
	case 0x01:pMathType=mo;pmt(0x0394);break;//Delta
	case 0x02:pMathType=mo;pmt(0x0398);break;//Theta
	case 0x03:pMathType=mo;pmt(0x039B);break;//Lambda
	case 0x04:pMathType=mo;pmt(0x039E);break;//Xi
	case 0x05:pMathType=mo;pmt(0x03A0);break;//Pi
	case 0x06:pMathType=mo;pmt(0x03A3);break;//Sigma
	case 0x07:pMathType=mo;pmt(0x03D2);break;//Upsilon with hook
	case 0x08:pMathType=mo;pmt(0x03A6);break;//Phi
	case 0x09:pMathType=mo;pmt(0x03A8);break;//Psi
	case 0x0A:pMathType=mo;pmt(0x03A9);break;//Omega
	case 0x0B:pMathType=mo;pmt('f');pMathType=mo;pmt('f');break;//p(ul2utf8(0xFB00));break;//ligature ff
	case 0x0C:pMathType=mo;pmt('f');pMathType=mo;pmt('i');break;//p(ul2utf8(0xFB01));break;//ligature fi
	case 0x0D:pMathType=mo;pmt('f');pMathType=mo;pmt('l');break;//p(ul2utf8(0xFB02));break;//ligature fl
	case 0x0E:pMathType=mo;pmt('f');pMathType=mo;pmt('f');pMathType=mo;pmt('i');break;//p(ul2utf8(0xFB03));break;//ligature ffi
	case 0x0F:pMathType=mo;pmt('f');pMathType=mo;pmt('f');pMathType=mo;pmt('l');break;//p(ul2utf8(0xFB04));break;//ligature ffl

	case 0x10:pMathType=mo;pmt(0x0131);break;//imath
	case 0x11:pMathType=mo;pmt(0x006A);break;//jmath,pmt(0x0237);break;//jmath
	case 0x12:pMathType=mo;pmt(0x0060);break;//grave accent
	case 0x13:pMathType=mo;pmt(0x00B4);break;//acute accent
	case 0x14:pMathType=mo;pmt(0x02C7);break;//caron, hacek
	case 0x15:pMathType=mo;pmt(0x02D8);break;//breve
	case 0x16:pMathType=mo;pmt(0x00AF);break;//macron
	case 0x17:pMathType=mo;pmt(0x02DA);break;//ring above
	case 0x18:pMathType=mo;pmt(0x00B8);break;//cedilla
	case 0x19:pMathType=mo;pmt(0x00DF);break;//german SS
	case 0x1A:pMathType=mo;pmt(0x00E6);break;//latin ae
	case 0x1B:pMathType=mo;pmt(0x0153);break;//latin oe
	case 0x1C:pMathType=mo;pmt(0x00F8);break;//o slash
	case 0x1D:pMathType=mo;pmt(0x00C6);break;//latin AE
	case 0x1E:pMathType=mo;pmt(0x0152);break;//latin OE
	case 0x1F:pMathType=mo;pmt(0x00D8);break;//O slash

	case 0x20:combiningUnicode=0x0337;break;//.notdef, overlay short solidus
	case 0x21:pMathType=mo;pmt(*temp);break;//exclamation sign
	case 0x22:pMathType=mo;pmt(0x201D);break;//right double quotation mark
	case 0x23://number sign
	case 0x24:pMathType=mo;pmt(0x00A3);break;//sterling
	case 0x25:pMathType=mo;pmt(*temp);break;//percent
	case 0x26://ampersand
		if (mathmode && !mathText){
			p("<mo>&amp;</mo>");
		}else 
			p("&amp;");
		break;
	case 0x27:pMathType=mo;pmt(*temp);break;//apostrophe
	case 0x28:pMathType=mo;pmt(*temp);break;//left parenthesis
	case 0x29:pMathType=mo;pmt(*temp);break;//right parenthesis
	case 0x2A://asterisk
	case 0x2B://plus
	case 0x2C:inhibitspace=0;pMathType=mo;pmt(*temp);break;//comma
	case 0x2D://hyphen
	case 0x2E://period
	case 0x2F:pMathType=mo;pmt(*temp);break;//slash

	case 0x30:
	case 0x31:
	case 0x32:
	case 0x33:
	case 0x34:
	case 0x35:
	case 0x36:
	case 0x37:
	case 0x38:
	case 0x39:pMathType=mn;pmt(*temp);break;//numbers 0-9
	case 0x3A:pMathType=mo;pmt(*temp);break;//:
	case 0x3B:pMathType=mo;pmt(*temp);break;//;
	case 0x3C:pMathType=mo;pmt(0x00A1);break;//inverted exclamation mark
	case 0x3D: //equal
		pMathType=mo;
		precomposedNegative(*temp, 0x2260);
		break;
	case 0x3E:pMathType=mo;pmt(0x00BF);break;//inverted question mark
	case 0x3F:pMathType=mo;pmt(*temp);break;//?

	case 0x40:pMathType=mo;pmt(*temp);break;//@ //at
	
	//A to Z go to default: mo
	
	case 0x5B:pMathType=mo;pmt(*temp);break;//[
	case 0x5C:pMathType=mo;pmt(0x201C);break;//left double quotation mark
	case 0x5D:pMathType=mo;pmt(*temp);break;//]
	case 0x5E:pMathType=mo;pmt(*temp);break;//^
	case 0x5F:pMathType=mo;pmt(0x02D9);break;//dot above

	case 0x60:pMathType=mo;pmt(*temp);break;//`//quoteleft
	
	//a to z go to default: mo
	
	case 0x7B:pMathType=mo;pmt(0x2013);break;//en dash
	case 0x7C:pMathType=mo;pmt(0x2014);break;//em dash
	case 0x7D:pMathType=mo;pmt(0x02DD);break;//double acute accent, 0x30B combining
	case 0x7E:pMathType=mo;pmt(*temp);break;//tilde
	case 0x7F:
		if (spacing || mathmode) {pMathType=mo;pmt(0x00A8);spacing=0;} 
		else 
		combiningUnicode=0x0308;
		break;	//diaeresis
	
	case 0x8A:pMathType=mo;pmt(0x0141);break;//L with stroke
	case 0xA2:pMathType=mo;pmt(*temp);break;//cent sign
	case 0xA3:pMathType=mo;pmt(*temp);break;//pound sign
	case 0xAA:pMathType=mo;pmt(0x0142);break;//l with stroke
	case 0xC5:pMathType=mo;pmt(*temp);break;//A with ring above, Angstrom
	case 0xE5:pMathType=mo;pmt(*temp);break;//a with ring above
	default:pMathType=mo;pmt(*temp);
	}
	temp++;
}while(*temp);
return;
}

void fontMap7tt(){//OT1++ , typewriter 
//cmtt, cmcsc, cmsltt, cmtcsc, cmtl, cmsltl, cccsc
//cmitt (pound for dollar)
//px[sc,bsc], rpx[bsl,bsc,i,r,sc,sl], rtx[b,bi,bsc,bsssc]
//tx[tt,ttsc,ttsl,sc,sssc,btt,bttsc,bsc,bsssc]
//pcrr7n
//cmitt 

unsigned char* temp=(unsigned char*)yytext; 

do{
	switch(*temp){
	case 0x00:pMathType=mo;pmt(0x0393);break;//Gamma
	case 0x01:pMathType=mo;pmt(0x0394);break;//Delta
	case 0x02:pMathType=mo;pmt(0x0398);break;//Theta
	case 0x03:pMathType=mo;pmt(0x039B);break;//Lambda
	case 0x04:pMathType=mo;pmt(0x039E);break;//Xi
	case 0x05:pMathType=mo;pmt(0x03A0);break;//Pi
	case 0x06:pMathType=mo;pmt(0x03A3);break;//Sigma
	case 0x07:pMathType=mo;pmt(0x03D2);break;//Upsilon with hook
	case 0x08:pMathType=mo;pmt(0x03A6);break;//Phi
	case 0x09:pMathType=mo;pmt(0x03A8);break;//Psi
	case 0x0A:pMathType=mo;pmt(0x03A9);break;//Omega
	case 0x0B:pMathType=mo;pmt(0x2191);break;//up arrow
	case 0x0C:pMathType=mo;pmt(0x2193);break;//down arrow
	case 0x0D:pMathType=mo;pmt(0x2032);break;//prime
	case 0x0E:pMathType=mo;pmt(0x00A1);break;//inverted exclamation mark
	case 0x0F:pMathType=mo;pmt(0x00BF);break;//inverted question mark

	case 0x10:pMathType=mo;pmt(0x026A);break;//latin i small capital
	case 0x11:pMathType=mo;pmt(0x006A);break;//j (ascii)
	case 0x12:pMathType=mo;pmt(0x0060);break;//grave accent
	case 0x13:pMathType=mo;pmt(0x00B4);break;//acute accent
	case 0x14:pMathType=mo;pmt(0x02C7);break;//caron, hacek
	case 0x15:pMathType=mo;pmt(0x02D8);break;//breve
	case 0x16:pMathType=mo;pmt(0x00AF);break;//macron
	case 0x17:pMathType=mo;pmt(0x02DA);break;//ring above
	case 0x18:pMathType=mo;pmt(0x00B8);break;//cedilla
	case 0x19:pMathType=mo;pmt(0x00DF);break;//german SS (XXX)
	case 0x1A:pMathType=mo;pmt(0x00E6);break;//ae
	case 0x1B:pMathType=mo;pmt(0x0153);break;//oe
	case 0x1C:pMathType=mo;pmt(0x00F8);break;//o slash
	case 0x1D:pMathType=mo;pmt(0x00C6);break;//AE
	case 0x1E:pMathType=mo;pmt(0x0152);break;//OE
	case 0x1F:pMathType=mo;pmt(0x00D8);break;//O slash

	case 0x20:combiningUnicode=0x0337;break;//overlay short solidus
	case 0x21:pMathType=mo;pmt(*temp);break;//exclamation mark
	case 0x22:pMathType=mo;pmt(0x201D);break;//right double quotation mark
	case 0x23:
	case 0x24:
	case 0x25:pMathType=mo;pmt(*temp);break;
	case 0x26:
		if (mathmode && !mathText)
			p("<mo>&amp;</mo>");
		else 
			p("&amp;");
		break;//ampersand
	case 0x27:pMathType=mo;pmt(*temp);break;//apostrophe
	case 0x28:pMathType=mo;pmt(*temp);break;//left parenthesis
	case 0x29:pMathType=mo;pmt(*temp);break;//right parenthesis
	case 0x2A:
	case 0x2B:
	case 0x2C:inhibitspace=0;pMathType=mo;pmt(*temp);break;
	case 0x2D:
	case 0x2E:
	case 0x2F:pMathType=mo;pmt(*temp);break;

	case 0x30:
	case 0x31:
	case 0x32:
	case 0x33:
	case 0x34:
	case 0x35:
	case 0x36:
	case 0x37:
	case 0x38:
	case 0x39:pMathType=mn;pmt(*temp);break;//numbers 0-9
	case 0x3A:pMathType=mo;pmt(*temp);break;//:
	case 0x3B:pMathType=mo;pmt(*temp);break;//;
		
	case 0x3C://less than
		if(combiningUnicode==0x0338) { 
			combiningUnicode=0;
			pmt(0x226F);
		}	else	{
			if (mathmode && !mathText)
				p("<mo>&lt;</mo>");
			else 
				p("&lt;");
		}
		break;
	case 0x3D: //equal
		pMathType=mo;
		precomposedNegative(*temp, 0x2260);
		break;
	case 0x3E: //greater than
		if(combiningUnicode==0x0338) { 
			combiningUnicode=0;
			pmt(0x226F);
		}	else{
			if (mathmode && !mathText)
				p("<mo>&gt;</mo>");
			else 
				p("&gt;");
		}
		break;
	case 0x3F:pMathType=mo;pmt(*temp);break;//question mark
	case 0x40:pMathType=mo;pmt(*temp);break;//at sign

	//A to Z go to default: mo
	
	case 0x5B:pMathType=mo;pmt(*temp);break;//[
	case 0x5C:pMathType=mo;pmt(0x201C);break;//left double quotation mark
	case 0x5D:pMathType=mo;pmt(*temp);break;//]
	case 0x5E:pMathType=mo;pmt(*temp);break;//^
	case 0x5F:pMathType=mo;pmt(0x02D9);break;//dot above

	case 0x60:pMathType=mo;pmt(*temp);break;//`
	
	//a to z go to default: mo
	
	case 0x7B:pMathType=mo;pmt(0x2013);break;//en dash
	case 0x7C:pMathType=mo;pmt(0x2014);break;//em dash
	case 0x7D:pMathType=mo;pmt(0x02DD);break;//double acute accent
	case 0x7E:pMathType=mo;pmt(*temp);break;//tilde
	case 0x7F:pMathType=mo;pmt(0x00A8);break;//diaeresis

	case 0x8A:pMathType=mo;pmt(0x0141);break;//L with stroke
	case 0xA2:pMathType=mo;pmt(*temp);break;//cent sign
	case 0xA3:pMathType=mo;pmt(*temp);break;//pound sign
	case 0xAA:pMathType=mo;pmt(0x0142);break;//l with stroke
	case 0xC5:pMathType=mo;pmt(*temp);break;//A with ring above, Angstrom
	case 0xE5:pMathType=mo;pmt(*temp);break;//a with ring above
	
	default:pMathType=mo;pmt(*temp);
	}
	temp++;
}while(*temp);
return;
}

void fontMap7ttp(){//OT1++ , typewriter 
//cmitt (pound for dollar)

unsigned char* temp=(unsigned char*)yytext; 

do{
	switch(*temp){
	case 0x00:pMathType=mo;pmt(0x0393);break;	//Gamma
	case 0x01:pMathType=mo;pmt(0x0394);break;	//Delta
	case 0x02:pMathType=mo;pmt(0x0398);break;	//Theta
	case 0x03:pMathType=mo;pmt(0x039B);break;	//Lambda
	case 0x04:pMathType=mo;pmt(0x039E);break;	//Xi
	case 0x05:pMathType=mo;pmt(0x03A0);break;	//Pi
	case 0x06:pMathType=mo;pmt(0x03A3);break;	//Sigma
	case 0x07:pMathType=mo;pmt(0x03D2);break;	//Upsilon with hook
	case 0x08:pMathType=mo;pmt(0x03A6);break;	//Phi
	case 0x09:pMathType=mo;pmt(0x03A8);break;	//Psi
	case 0x0A:pMathType=mo;pmt(0x03A9);break;	//Omega
	case 0x0B:pMathType=mo;pmt(0x2191);break;	//up arrow
	case 0x0C:pMathType=mo;pmt(0x2193);break;	//down arrow
	case 0x0D:pMathType=mo;pmt(0x2032);break;	//prime
	case 0x0E:pMathType=mo;pmt(0x00A1);break;	//inverted exclamation mark
	case 0x0F:pMathType=mo;pmt(0x00BF);break;	//inverted question mark

	case 0x10:pMathType=mo;pmt(0x026A);break;	//latin i small capital
	case 0x11:pMathType=mo;pmt(0x006A);break;	//j (ascii)
	case 0x12:pMathType=mo;pmt(0x0060);break;	//grave accent
	case 0x13:pMathType=mo;pmt(0x00B4);break;	//acute accent
	case 0x14:pMathType=mo;pmt(0x02C7);break;	//caron, hacek
	case 0x15:pMathType=mo;pmt(0x02D8);break;	//breve
	case 0x16:pMathType=mo;pmt(0x00AF);break;	//macron
	case 0x17:pMathType=mo;pmt(0x02DA);break;	//ring above
	case 0x18:pMathType=mo;pmt(0x00B8);break;	//cedilla
	case 0x19:pMathType=mo;pmt(0x00DF);break;	//german SS
	case 0x1A:pMathType=mo;pmt(0x00E6);break;	//ae
	case 0x1B:pMathType=mo;pmt(0x0153);break;	//oe
	case 0x1C:pMathType=mo;pmt(0x00F8);break;	//o slash
	case 0x1D:pMathType=mo;pmt(0x00C6);break;	//AE
	case 0x1E:pMathType=mo;pmt(0x0152);break;	//OE
	case 0x1F:pMathType=mo;pmt(0x00D8);break;	//O slash

	case 0x20:combiningUnicode=0x0337;break;//overlay short solidus
	case 0x21:pMathType=mo;pmt(*temp);break;//exclamation mark
	case 0x22:pMathType=mo;pmt(0x201D);break;//right double quotation mark
	case 0x23:
	case 0x24:pMathType=mo;pmt(0x00A3);break;//sterling
	case 0x25:pMathType=mo;pmt(*temp);break;
	case 0x26:
		if (mathmode && !mathText)
			p("<mo>&amp;</mo>");
		else 
			p("&amp;");
		break;//ampersand
	case 0x27:pMathType=mo;pmt(*temp);break;//apostrophe
	case 0x28:pMathType=mo;pmt(*temp);break;//left parenthesis
	case 0x29:pMathType=mo;pmt(*temp);break;//right parenthesis
	case 0x2A:
	case 0x2B:
	case 0x2C:inhibitspace=0;pMathType=mo;pmt(*temp);break;
	case 0x2D:
	case 0x2E:
	case 0x2F:pMathType=mo;pmt(*temp);break;

	case 0x30:
	case 0x31:
	case 0x32:
	case 0x33:
	case 0x34:
	case 0x35:
	case 0x36:
	case 0x37:
	case 0x38:
	case 0x39:pMathType=mn;pmt(*temp);break;//numbers 0-9
	case 0x3A:pMathType=mo;pmt(*temp);break;//:
	case 0x3B:pMathType=mo;pmt(*temp);break;//;
		
	case 0x3C://less than
		if(combiningUnicode==0x0338) { 
			combiningUnicode=0;
			pmt(0x226F);
		}	else	{
			if (mathmode && !mathText)
				p("<mo>&lt;</mo>");
			else 
				p("&lt;");
		}
		break;
	case 0x3D: //equal
		pMathType=mo;
		precomposedNegative(*temp, 0x2260);
		break;
	case 0x3E: //greater than
		if(combiningUnicode==0x0338) { 
			combiningUnicode=0;
			pmt(0x226F);
		}	else{
			if (mathmode && !mathText)
				p("<mo>&gt;</mo>");
			else 
				p("&gt;");
		}
		break;
	case 0x3F:pMathType=mo;pmt(*temp);break;//question mark
	case 0x40:pMathType=mo;pmt(*temp);break;//at sign

	//A to Z go to default: mo
	
	case 0x5B:pMathType=mo;pmt(*temp);break;//[
	case 0x5C:pMathType=mo;pmt(0x201C);break;//left double quotation mark
	case 0x5D:pMathType=mo;pmt(*temp);break;//]
	case 0x5E:pMathType=mo;pmt(*temp);break;//^
	case 0x5F:pMathType=mo;pmt(0x02D9);break;//dot above

	case 0x60:pMathType=mo;pmt(*temp);break;//`
	
	//a to z go to default: mo
	
	case 0x7B:pMathType=mo;pmt(0x2013);break;//en dash
	case 0x7C:pMathType=mo;pmt(0x2014);break;//em dash
	case 0x7D:pMathType=mo;pmt(0x02DD);break;//double acute accent
	case 0x7E:pMathType=mo;pmt(*temp);break;//tilde
	case 0x7F:pMathType=mo;pmt(0x00A8);break;//diaeresis

	case 0x8A:pMathType=mo;pmt(0x0141);break;//L with stroke
	case 0xA2:pMathType=mo;pmt(*temp);break;//cent sign
	case 0xA3:pMathType=mo;pmt(*temp);break;//pound sign
	case 0xAA:pMathType=mo;pmt(0x0142);break;//l with stroke
	case 0xC5:pMathType=mo;pmt(*temp);break;//A with ring above, Angstrom
	case 0xE5:pMathType=mo;pmt(*temp);break;//a with ring above
	
	default:pMathType=mo;pmt(*temp);
	}
	temp++;
}while(*temp);
return;
}

void fontMap8a(){//8a, Standard Encoding
//rpag[d,do,k,ko]

unsigned char* temp=(unsigned char*)yytext;

do{
	switch(*temp){
	case 0x00:
	case 0x01:
	case 0x02:
	case 0x03:
	case 0x04:
	case 0x05:
	case 0x06:
	case 0x07:
	case 0x08:
	case 0x09:
	case 0x0A:
	case 0x0B:
	case 0x0C:
	case 0x0D:
	case 0x0E:
	case 0x0F:

	case 0x10:
	case 0x11:
	case 0x12:
	case 0x13:
	case 0x14:
	case 0x15:
	case 0x16:
	case 0x17:
	case 0x18:
	case 0x19:
	case 0x1A:
	case 0x1B:
	case 0x1C:
	case 0x1D:
	case 0x1E:
	case 0x1F:

	case 0x20:pMathType=mo;pmt(*temp);break;	//space
	case 0x21:pMathType=mo;pmt(*temp);break;	//exclamation sign
	case 0x22:pMathType=mo;pmt(0x201D);break;	//right double quotation mark
	case 0x23:
	case 0x24:
	case 0x25:pMathType=mo;pmt(*temp);break;
	case 0x26:
		if (mathmode && !mathText){
			p("<mo>&amp;</mo>");
		}else 
			p("&amp;");
		break;//ampersand
	case 0x27:pMathType=mo;pmt(*temp);break;	//apostrophe
	case 0x28:pMathType=mo;pmt(*temp);break;	//left parenthesis
	case 0x29:pMathType=mo;pmt(*temp);break;	//right parenthesis
	case 0x2A:
	case 0x2B:
	case 0x2C:inhibitspace=0;pMathType=mo;pmt(*temp);break;
	case 0x2D:
	case 0x2E:
	case 0x2F:pMathType=mo;pmt(*temp);break;

	case 0x30:
	case 0x31:
	case 0x32:
	case 0x33:
	case 0x34:
	case 0x35:
	case 0x36:
	case 0x37:
	case 0x38:
	case 0x39:pMathType=mn;pmt(*temp);break;	//0-9 digits
	case 0x3A:pMathType=mo;pmt(*temp);break;	//colon
	case 0x3B:pMathType=mo;pmt(*temp);break;	//semicolon
	case 0x3C://less than
		if(combiningUnicode==0x0338) { 
			combiningUnicode=0;
			pmt(0x226F);
		}	else{
			if (mathmode && !mathText)
				p("<mo>&lt;</mo>");
			else 
				p("&lt;");
			break;
		}
		break;
	case 0x3D:pMathType=mo;pmt(0x002F);break;	//slash
	case 0x3E: //greater than
		if(combiningUnicode==0x0338) { 
			combiningUnicode=0;
			pmt(0x226F);
		}	else{
			if (mathmode && !mathText)
				p("<mo>&gt;</mo>");
			else 
				p("&gt;");
			break;
		}
		break;
	case 0x3F:pMathType=mo;pmt(*temp);break;	//question mark

	case 0x40:pMathType=mo;pmt(*temp);break;	//at sign
	
	//ascii capital letters
	
	case 0x5B:pMathType=mo;pmt(*temp);break;	//left square bracket
	case 0x5C:pMathType=mo;pmt(*temp);break;	//backslash
	case 0x5D:pMathType=mo;pmt(*temp);break;	//rightt square bracket
	
	case 0x5E:pMathType=mo;pmt(*temp);break;	//circumflex
	case 0x5F:pMathType=mo;pmt(*temp);break;	//underscore
	
	case 0x60:pMathType=mo;pmt(*temp);break;	//left single quote
	
	//ascii small letters

	case 0x7B:pMathType=mo;pmt(*temp);break;	//left brace
	case 0x7C:pMathType=mo;pmt(*temp);break;	//vertical bar
	case 0x7D:pMathType=mo;pmt(*temp);break;	//right brace
	case 0x7E:pMathType=mo;pmt(*temp);break;	//tilde
	case 0x7F:break;	//notdef
	
	case 0x80:
	case 0x81:
	case 0x82:
	case 0x83:
	case 0x84:
	case 0x85:
	case 0x86:
	case 0x87:
	case 0x88:
	case 0x89:
	case 0x8A:
	case 0x8B:
	case 0x8C:
	case 0x8D:
	case 0x8E:
	case 0x8F:

	case 0x90:
	case 0x91:
	case 0x92:
	case 0x93:
	case 0x94:
	case 0x95:
	case 0x96:
	case 0x97:
	case 0x98:
	case 0x99:
	case 0x9A:
	case 0x9B:
	case 0x9C:
	case 0x9D:
	case 0x9E:
	case 0x9F:

	case 0xA0:
	case 0xA1:break;	//notdef
	case 0xA2:	//cent
	case 0xA3:pMathType=mo;pmt(*temp);break;	//sterling
	case 0xA4:pMathType=mo;pmt(0x2044);break;	//fraction slash
	case 0xA5:pMathType=mo;pmt(*temp);break;	//yen
	case 0xA6:pMathType=mo;pmt(0x0192);break;	//florin currency
	case 0xA7:pMathType=mo;pmt(*temp);break;	//section mark
	case 0xA8:pMathType=mo;pmt(0x00A4);break;	//currency sign
	case 0xA9:pMathType=mo;pmt(0x2019);break;	//right single quot-mark
	case 0xAA:pMathType=mo;pmt(0x201C);break;	//left double quot-mark
	
	case 0xAB:pMathType=mo;pmt(*temp);break;	//left guillemet
	case 0xAC:pMathType=mo;pmt(0x2039);break;	//left single guillemet
	case 0xAD:pMathType=mo;pmt(0x2040);break;	//right single guillemet
	case 0xAE:pMathType=mo;pmt('f');pMathType=mo;pmt('i');break;	//p(ul2utf8(0xFB01));break;//ligature fi
	case 0xAF:pMathType=mo;pmt('f');pMathType=mo;pmt('l');break;	//p(ul2utf8(0xFB02));break;//ligature fl

	case 0xB0:break;	//notdef
	case 0xB1:pMathType=mo;pmt(0x2013);break;	//en-dash
	case 0xB2:pMathType=mo;pmt(0x2020);break;	//dagger
	case 0xB3:pMathType=mo;pmt(0x2021);break;	//double dagger
	case 0xB4:pMathType=mo;pmt(0x00B7);break;	//centered dot
	case 0xB5:break;//notdef
	case 0xB6:pMathType=mo;pmt(*temp);break;	//paragraph
	case 0xB7:pMathType=mo;pmt(0x2022);break;	//bullet
	case 0xB8:pMathType=mo;pmt(0x201A);break;	//quot-mark single base
	case 0xB9:pMathType=mo;pmt(0x201E);break;	//quot-mark double base
	case 0xBA:pMathType=mo;pmt(0x201D);break;	//quot-mark double right
	case 0xBB:pMathType=mo;pmt(*temp);break;	//right guillemet
	case 0xBC:pMathType=mo;pmt(0x2026);break;	//horizontal ellipsis
	case 0xBD:pMathType=mo;pmt(0x2030);break; //per mille
	case 0xBE:break;//notdef
	case 0xBF:pMathType=mo;pmt(*temp);break;
	
	case 0xC0:break;//notdef
	case 0xC1:pMathType=mo;pmt(0x0060);break;	//grave accent
	case 0xC2:pMathType=mo;pmt(0x00B4);break;	//acute accent
	case 0xC3:pMathType=mo;pmt(0x005E);break;	//hat
	case 0xC4:pMathType=mo;pmt(0x007E);break;	//tilde
	case 0xC5:pMathType=mo;pmt(0x00AF);break;	//macron 
	case 0xC6:pMathType=mo;pmt(0x02D8);break;	//breve 
	case 0xC7:pMathType=mo;pmt(0x02D9);break;	//dot above 
	case 0xC8:pMathType=mo;pmt(0x0308);break;	//diaeresis, XXX, it is combining, should be put in combineAccent 
	case 0xC9:break;//notdef
	case 0xCA:pMathType=mo;pmt(0x02DA);break;	//ring above
	case 0xCB:pMathType=mo;pmt(0x00B8);break;	//cedilla
	case 0xCC:break;//notdef
	case 0xCD:pMathType=mo;pmt(0x02DD);break;	//double acute accent 
	case 0xCE:pMathType=mo;pmt(0x02DB);break;	//ogonek 
	case 0xCF:pMathType=mo;pmt(0x02C7);break;	//caron, hacek
	
	case 0xD0:pMathType=mo;pmt(0x2014);break;	//em-dash
	case 0xD1:
	case 0xD2:
	case 0xD3:
	case 0xD4:
	case 0xD5:
	case 0xD6:
	case 0xD7:
	case 0xD8:
	case 0xD9:
	case 0xDA:
	case 0xDB:
	case 0xDC:
	case 0xDD:
	case 0xDE:
	case 0xDF:
	
	case 0xE0:break;	//notdef
	case 0xE1:pMathType=mo;pmt(0x00C6);break;	//AE
	case 0xE2:break;	//notdef
	case 0xE3:pMathType=mo;pmt(0x00AA);break;	//ordinal feminine
	case 0xE4:
	case 0xE5:
	case 0xE6:
	case 0xE7:break;	//notdef
	case 0xE8:pMathType=mo;pmt(0x0141);break;	//L stroke
	case 0xE9:pMathType=mo;pmt(0x00D8);break;	//O stroke
	case 0xEA:pMathType=mo;pmt(0x0152);break;	//OE
	case 0xEB:pMathType=mo;pmt(0x00BA);break;	//ordinal masculine
	case 0xEC:
	case 0xED:
	case 0xEE:
	case 0xEF:
	
	case 0xF0:break;	//notdef
	case 0xF1:pMathType=mo;pmt(0x00E6);break;	//ae
	case 0xF2:
	case 0xF3:
	case 0xF4:break;	//notdef
	case 0xF5:pMathType=mo;pmt(0x0131);break;	//imath
	case 0xF6:
	case 0xF7:break;	//notdef
	case 0xF8:pMathType=mo;pmt(0x0142);break;	//l stroke
	case 0xF9:pMathType=mo;pmt(0x00F8);break;	//o stroke
	case 0xFA:pMathType=mo;pmt(0x0153);break;	//oe
	case 0xFB:pMathType=mo;pmt(0x00DF);break;	//german eszett
	case 0xFC:
	case 0xFD:
	case 0xFE:
	case 0xFF:break;//notdef
	
	default:pMathType=mo;pmt(*temp);
	}
	temp++;
}while(*temp);
return;

}

void fontMapDvips(){
//pag[k,kc,ko,dc,do]
//pbk[d,dc,di,do,l,lc,li,lo]
//rpbk[d,dc,di,do,l,lc,li,lo]
//pcr[b,bc,bo,r,rc,ro]
//rpcr[b,bo,rr,ro
//phv[r,rc,ro,ron,rrn,bc,bo,bon,brn]
//rphv[b,bo,bon,brn,r,ro,ronrrn]
//pnc[b,bc,bo,r,rc,ri,ro]
//rpnc[b,bi,cr,cri]
//ppl[b,bc,bi,bo,bu,r,rc,ri,ro,rre,rrn,ru]
//rppl[r,ri,ro,rre,rrn,ru,b,bi,bu
//ptm[r,rc,ri,ro,rre,rrn,b,bc,bi,bo]
//rptm[r,ri,ro,rre,rrn,b,bi,bo
//rpxcmi
unsigned char* temp=(unsigned char*)yytext;

do{
	switch(*temp){
	case 0x00:
	case 0x01:
	case 0x02:
	case 0x03:
	case 0x04:
	case 0x05:
	case 0x06:
	case 0x07:
	case 0x08:
	case 0x09:
	case 0x0A:
	case 0x0B:
	case 0x0C:break;//notdef
	case 0x0D:pMathType=mo;pmt('\'');break;//quote single
	case 0x0E:pMathType=mo;pmt(0x00A1);break;//inverted exclamation mark
	case 0x0F:pMathType=mo;pmt(0x00BF);break;//inverted question mark

	case 0x10:pMathType=mo;pmt(0x0131);break;//imath
	case 0x11:pMathType=mo;pmt(0x006A);break;//jmath,pmt(0x0237);break;//jmath
	case 0x12:pMathType=mo;pmt(0x0060);break;//grave accent
	case 0x13:pMathType=mo;pmt(0x00B4);break;//acute accent
	case 0x14:pMathType=mo;pmt(0x02C7);break;//caron, hacek
	case 0x15:pMathType=mo;pmt(0x02D8);break;//breve
	case 0x16:pMathType=mo;pmt(0x00AF);break;//macron
	case 0x17:pMathType=mo;pmt(0x02DA);break;//ring above
	case 0x18:pMathType=mo;pmt(0x00B8);break;//cedilla
	case 0x19:pMathType=mo;pmt(0x00DF);break;//german SS
	case 0x1A:pMathType=mo;pmt(0x00E6);break;//latin ae
	case 0x1B:pMathType=mo;pmt(0x0153);break;//latin oe
	case 0x1C:pMathType=mo;pmt(0x00F8);break;//o slash
	case 0x1D:pMathType=mo;pmt(0x00C6);break;//latin AE
	case 0x1E:pMathType=mo;pmt(0x0152);break;//latin OE
	case 0x1F:pMathType=mo;pmt(0x00D8);break;//O slash

	case 0x20://space
	case 0x21:pMathType=mo;pmt(*temp);break;//!
	case 0x22:pMathType=mo;pmt(0x201D);break;//right double quotation mark
	case 0x23:
	case 0x24:
	case 0x25:pMathType=mo;pmt(*temp);break;
	case 0x26:
		if (mathmode && !mathText){
			p("<mo>&amp;</mo>");
		}else 
			p("&amp;");
		break;//ampersand
	case 0x27:pMathType=mo;pmt(*temp);break;//'
	case 0x28:pMathType=mo;pmt(*temp);break;//(
	case 0x29:pMathType=mo;pmt(*temp);break;//)
	case 0x2A:
	case 0x2B:
	case 0x2C:inhibitspace=0;pMathType=mo;pmt(*temp);break;
	case 0x2D:
	case 0x2E:
	case 0x2F:pMathType=mo;pmt(*temp);break;

	case 0x30:
	case 0x31:
	case 0x32:
	case 0x33:
	case 0x34:
	case 0x35:
	case 0x36:
	case 0x37:
	case 0x38:
	case 0x39:pMathType=mn;pmt(*temp);break;
	case 0x3A:pMathType=mo;pmt(*temp);break;//:
	case 0x3B:pMathType=mo;pmt(*temp);break;//;
	case 0x3C://less than
		if(combiningUnicode==0x0338) { 
			combiningUnicode=0;
			pmt(0x226F);
		}	else	p("<mo>&lt;</mo>");
		break;
	case 0x3D:pMathType=mo;pmt(0x002F);break;//slash
	case 0x3E: //greater than
		if(combiningUnicode==0x0338) { 
			combiningUnicode=0;
			pmt(0x226F);
		}	else	p("<mo>&gt;</mo>");
		break;
	case 0x3F:pMathType=mo;pmt(*temp);break;//?

	case 0x40:pMathType=mo;pmt(*temp);break;//@
	
	//ascii capital letters
	
	case 0x5B:pMathType=mo;pmt(*temp);break;//[
	case 0x5C:pMathType=mo;pmt(*temp);break;//backslash
	case 0x5D:pMathType=mo;pmt(*temp);break;//]
	
	case 0x5E:pMathType=mo;pmt(*temp);break;//^
	case 0x5F:pMathType=mo;pmt(*temp);break;//_
	
	case 0x60:pMathType=mo;pmt(*temp);break;//`
	
	//ascii small letters

	case 0x7B:pMathType=mo;pmt(*temp);break;//left brace
	case 0x7C:pMathType=mo;pmt(*temp);break;//vertical bar
	case 0x7D:pMathType=mo;pmt(*temp);break;//right brace
	case 0x7E:pMathType=mo;pmt(*temp);break;//tilde
	case 0x7F:pMathType=mo;pmt(0x00A8);break;//diaeresis
	
	case 0x80:pMathType=mo;pmt(0x005E);break;//ascii circumflex
	case 0x81:pMathType=mo;pmt(0x223C);break;//tilde operator
	case 0x82:pMathType=mo;pmt(0x00C7);break;//C cedilla
	case 0x83:pMathType=mo;pmt(0x00CD);break;//I aigu
	case 0x84:pMathType=mo;pmt(0x00CE);break;//I circumflex
	case 0x85:pMathType=mo;pmt(0x00E3);break;//a tilde
	case 0x86:pMathType=mo;pmt(0x00EB);break;//e diaeresis
	case 0x87:pMathType=mo;pmt(0x00E8);break;//e grave
	case 0x88:pMathType=mo;pmt(0x0161);break;//s caron
	case 0x89:pMathType=mo;pmt(0x017E);break;//z caron
	case 0x8A:pMathType=mo;pmt(0x00D0);break;//ETH
	
	case 0x8B:pMathType=mo;pmt('f');pMathType=mo;pmt('f');break;//p(ul2utf8(0xFB00));break;//ligature ff 
	case 0x8C:pMathType=mo;pmt('f');pMathType=mo;pmt('f');pMathType=mo;pmt('i');break;//p(ul2utf8(0xFB03));break;//ligature ffi 
	case 0x8D:pMathType=mo;pmt('f');pMathType=mo;pmt('f');pMathType=mo;pmt('l');break;//p(ul2utf8(0xFB04));break;//ligature ffl 
	case 0x8E:
	case 0x8F:

	case 0x90:
	case 0x91:break;//notdef
	case 0x92:pMathType=mo;pmt(0x0160);break;//S caron
	case 0x93:
	case 0x94:
	case 0x95:
	case 0x96:
	case 0x97:break;//notdef
	case 0x98:pMathType=mo;pmt(0x0178);break;//Y diaeresis
	case 0x99:break;//notdef
	case 0x9A:pMathType=mo;pmt(0x017D);break;//Z caron
	case 0x9B:
	case 0x9C:
	case 0x9D:
	case 0x9E:
	case 0x9F:

	case 0xA0:
	case 0xA1:break;//notdef
	case 0xA2://cent
	case 0xA3:pMathType=mo;pmt(*temp);break;//sterling
	case 0xA4:pMathType=mo;pmt(0x2044);break;//fraction slash
	case 0xA5:pMathType=mo;pmt(*temp);break;//yen
	case 0xA6:pMathType=mo;pmt(0x0192);break;//florin currency
	case 0xA7:pMathType=mo;pmt(*temp);break;//section mark
	case 0xA8:pMathType=mo;pmt(0x00A4);break;//currency sign
	case 0xA9:pMathType=mo;pmt(*temp);break;//copyright
	case 0xAA:pMathType=mo;pmt(0x201C);break;//left double quot-mark
	case 0xAB:pMathType=mo;pmt(*temp);break;//left guillemet
	case 0xAC:pMathType=mo;pmt(0x2039);break;//left single guillemet
	case 0xAD:pMathType=mo;pmt(0x2040);break;//right single guillemet
	case 0xAE:pMathType=mo;pmt('f');pMathType=mo;pmt('i');break;//p(ul2utf8(0xFB01));break;//ligature fi
	case 0xAF:pMathType=mo;pmt('f');pMathType=mo;pmt('l');break;//p(ul2utf8(0xFB02));break;//ligature fl

	case 0xB0:pMathType=mo;pmt(*temp);break;//degree
	case 0xB1:pMathType=mo;pmt(0x2013);break;//en-dash
	case 0xB2:pMathType=mo;pmt(0x2020);break;//dagger
	case 0xB3:pMathType=mo;pmt(0x2021);break;//double dagger
	case 0xB4:pMathType=mo;pmt(0x00B7);break;//centered dot
	case 0xB5:break;//notdef
	case 0xB6:pMathType=mo;pmt(*temp);break;//paragraph
	case 0xB7:pMathType=mo;pmt(0x2022);break;//bullet
	
	case 0xB8:pMathType=mo;pmt(0x201A);break;//quot-mark single base
	case 0xB9:pMathType=mo;pmt(0x201E);break;//quot-mark double base
	case 0xBA:pMathType=mo;pmt(0x201D);break;//quot-mark double right
	case 0xBB:pMathType=mo;pmt(*temp);break;//right guillemet
	case 0xBC:pMathType=mo;pmt(0x2026);break;//horizontal ellipsis
	case 0xBD:pMathType=mo;pmt(0x2030);break; //per mille
	case 0xBE:
	case 0xBF:break;//notdef
	
	case 0xC6:break;//notdef
	case 0xC7:pMathType=mo;pmt(0x02D9);break;//dot above
	
	case 0xCD:pMathType=mo;pmt(0x02DD);break;//double acute accent
	case 0xCE:pMathType=mo;pmt(0x02DB);break;//ogonek
	
	case 0xD0:pMathType=mo;pmt(0x2014);break;//em-dash
	
	case 0xD7:
	case 0xD8:break;//notdef
	
	case 0xDF:break;//notdef
	
	case 0xE3:pMathType=mo;pmt(0x00AA);break;//ordinal feminine
	
	case 0xEB:pMathType=mo;pmt(0x00BA);break;//ordinal masculine
	
	default:pMathType=mo;pmt(*temp);
	}
	temp++;
}while(*temp);
return;

}

void fontMap8r(){//TeXBase1 Encoding
//rpxppl[b,bi,bo,r,ri,ro]
//rtxphv[b,bo,r,ro,rtxptm[b,bi,bo,r,ri,ro]
//pag[d,do,k,ko]8r
//pbk[d,di,do,l,li,lo]8r
//pcr[b,bo,r,ro]8r
//pfr[r,ri,l,li,b,bi,c,ci,u]8r,pfr[r,l,b,c,u]8rc
//phv[r,ro,b,bo]8r,phv[r,ro,b,bo]8rn
//pnc[r,ri,ro,b,bi,bo]8r
//ppl[r,r,c,ri,rij,ro,ru,b,bi,bij,bj,bo,bu]8r, pplrr8re
//pcrr8rn
//ptm[r,ri,ro,b,bi,bo]8r,ptmrr8re
//pzcmi8r
unsigned char* temp=(unsigned char*)yytext;

do{
	switch(*temp){
	case 0x00:break;	//notdef
	case 0x01:pMathType=mo;pmt(0x02D9);break;	//dot above
	case 0x02:pMathType=mo;pmt('f');pMathType=mo;pmt('i');break;//p(ul2utf8(0xFB01));break;//ligature fi
	case 0x03:pMathType=mo;pmt('f');pMathType=mo;pmt('l');break;//p(ul2utf8(0xFB02));break;//ligature fl
	case 0x04:pMathType=mo;pmt(0x2044);break;	//fraction slash
	case 0x05:pMathType=mo;pmt(0x02DD);break;	//double acute accent
	case 0x06:pMathType=mo;pmt(0x0141);break;	//L stroke
	case 0x07:pMathType=mo;pmt(0x0142);break;	//l stroke
	case 0x08:pMathType=mo;pmt(0x02DB);break;	//ogonek 
	case 0x09:pMathType=mo;pmt(0x02DA);break;	//ring above 
	case 0x0A:break;//notdef
	case 0x0B:pMathType=mo;pmt(0x02D8);break;	//breve 
	case 0x0C:pMathType=mo;pmt(0x2212);break;	//minus
	case 0x0D:break;//notdef
	case 0x0E:pMathType=mo;pmt(0x017D);break;	//Z caron
	case 0x0F:pMathType=mo;pmt(0x017E);break;	//z caron
	

	case 0x10:pMathType=mo;pmt(0x02C7);break;	//caron
	case 0x11:pMathType=mo;pmt(0x0131);break; //dotless i
	case 0x12:pMathType=mo;pmt(0x0237);break; //dotless j
	case 0x13:pMathType=mo;pmt('f');pMathType=mo;pmt('f');break;//p(ul2utf8(0xFB00));break;//ligature ff 
	case 0x14:pMathType=mo;pmt('f');pMathType=mo;pmt('f');pMathType=mo;pmt('i');break;//p(ul2utf8(0xFB03));break;//ligature ffi 
	case 0x15:pMathType=mo;pmt('f');pMathType=mo;pmt('f');pMathType=mo;pmt('l');break;//p(ul2utf8(0xFB04));break;//ligature ffl 
	case 0x16:pMathType=mo;pmt(0x2260);break; //not equal
	case 0x17:pMathType=mo;pmt(0x221E);break; //infinity
	case 0x18:pMathType=mo;pmt(0x2264);break;	//less or equal 
	case 0x19:pMathType=mo;pmt(0x2264);break;	//greater or equal
	case 0x1A:pMathType=mo;pmt(0x2202);break; //partial diff	
	case 0x1B:pMathType=mo;pmt(0x2211);break; //summation
	case 0x1C:pMathType=mo;pmt(0x220F);break; //product
	case 0x1D:pMathType=mo;pmt(0x03C0);break; //pi
	case 0x1E:pMathType=mo;pmt(0x0060);break;	//grave
	case 0x1F:pMathType=mo;pmt(0x2019);break;	//quote single
	
	//default to ascii
	
	case 0x26:
		if (mathmode && !mathText)
			p("<mo>&amp;</mo>");
		else 
			p("&amp;");
		break;//ampersand
	case 0x3C://less than
		if(combiningUnicode==0x0338) { 
			combiningUnicode=0;
			pmt(0x226F);
		}	else{
			if (mathmode && !mathText)
				p("<mo>&lt;</mo>");
			else 
				p("&lt;");
		}
		break;
	case 0x3E: //greater than
		if(combiningUnicode==0x0338) { 
			combiningUnicode=0;
			pmt(0x226F);
		}	else{
			if (mathmode && !mathText)
				p("<mo>&gt;</mo>");
			else 
				p("&gt;");
		}
		break;

	//default to ascii
	
	case 0x7F:break;	//notdef
	
	//combined accented 
	case 0x80:pMathType=mo;pmt(0x20AC);break;	//euro sign
	case 0x81:pMathType=mo;pmt(0x222B);break;	//integral sign
	case 0x82:pMathType=mo;pmt(0x2019);break;	//quote single base
	case 0x83:pMathType=mo;pmt(0x0192);break;	//florin
	case 0x84:pMathType=mo;pmt(0x201E);break;	//double base quot-mark
	case 0x85:pMathType=mo;pmt(0x2026);break;	//horizontal ellipsis
	case 0x86:pMathType=mo;pmt(0x2020);break;	//dagger
	case 0x87:pMathType=mo;pmt(0x2021);break;	//double dagger
	case 0x88:pMathType=mo;pmt(0x005E);break;	//circumflex
	case 0x89:pMathType=mo;pmt(0x2030);break; //per mille
	case 0x8A:pMathType=mo;pmt(0x0160);break;	//S caron
	case 0x8B:pMathType=mo;pmt(0x2039);break;	//left single guillemet
	case 0x8C:pMathType=mo;pmt(0x0152);break;	//OE
	case 0x8D:pMathType=mo;pmt(0x03A9);break;	//Omega	
	case 0x8E:pMathType=mo;pmt(0x221A);break;	//radical sign
	case 0x8F:pMathType=mo;pmt(0x224A);break;	//approxeq

	case 0x90:
	case 0x91:
	case 0x92:break;	//notdef
	case 0x93:pMathType=mo;pmt(0x201C);break;	//left double quot-mark
	case 0x94:pMathType=mo;pmt(0x201D);break;	//right double quot-mark
	case 0x95:pMathType=mo;pmt(0x2022);break;	//bullet
	case 0x96:pMathType=mo;pmt(0x2013);break;	//en-dash
	case 0x97:pMathType=mo;pmt(0x2014);break;	//em-dash
	case 0x98:pMathType=mo;pmt(0x007E);break;	//tilde
	case 0x99:pMathType=mo;pmt(0x2122);break;	//TradeMark
	case 0x9A:pMathType=mo;pmt(0x0161);break;	//s caron
	case 0x9B:pMathType=mo;pmt(0x2040);break;	//right single guillemet
	case 0x9C:pMathType=mo;pmt(0x0153);break;	//oe
	case 0x9D:pMathType=mo;pmt(0x0394);break;	//Delta
	case 0x9E:pMathType=mo;pmt(0x25CA);break;	//lozenge
	case 0x9F:pMathType=mo;pmt(0x0178);break;	//Y diaeresis
	
	//default to Unicode A0-FF
	
	default:pMathType=mo;pmt(*temp);
	}
	temp++;
}while(*temp);
return;

}

void fontMap8t(){//Cork Encoding
//ebbx, ebmo, ebmr, ebso, ebsr, ebtl, ebto
//p1x[r,i,sl,sc, b, bi,bsc, bsl]
//t1x[r,b,i,bi,bsc,bsl,bss,bsssc,bsssl,sl,sc,ss,sssl,sssc,tt,ttsl,ttsc,btt,bttsl,bttsc]
//ecb, ecbi, ecbx eccc, ecrb, ecrm, ecsc, ecsl, ecss, ecssdc, ecti, ectt
//eocc, eorm, eosl, eoti
//lm[r,ri,ro,ss,sso,ssq,ssqo,ssqbo,ssqbx,ssbo,ssbx,ssdc,ssdo,b,bo,bx,bxi,bxo,csc,csco]
//lmtt, lmtcsc, lmtti, lmtto, lmvtt, lmvtto
//pag[dc,do,k,kc,ko]8t
//pbk[d,dc,di,do,l,lc,li,lo]8t
//pcr[r,r,c,ro,b,bc,bo]8t
//pfr[b,bi,c,ci,l,li,r,ri,u]8t,pfr[b,c,l,r,u]8tc
//phv[r,rc,ro,b,bc,bo]8t,phv[r,rc,ro,b,bc,bo]8tn
//pnc[r,r,c,ri,ro,b,bc,bi,bo]8t
//ppl[r,r,c,ri,ro,b,bc,bi,bo]8t
//pcrr8tn
//ptm[r,rc,ri,ro,b,bc,bi,bo]8t
//pzcmi8t

unsigned char* temp=(unsigned char*)yytext;

do{
	switch(*temp){
	case 0x00:pMathType=mo;pmt(0x0060);break;	//grave accent
	case 0x01:pMathType=mo;pmt(0x00B4);break;	//acute accent
	case 0x02:pMathType=mo;pmt(0x005E);break;	//hat
	case 0x03:pMathType=mo;pmt(0x007E);break;	//tilde
	case 0x04:pMathType=mo;pmt(0x0308);break;	//XXX, it is combining, should be put in combineAccent
	case 0x05:pMathType=mo;pmt(0x02DD);break;	//double acute accent
	case 0x06:pMathType=mo;pmt(0x02DA);break;	//ring above
	case 0x07:pMathType=mo;pmt(0x02C7);break;	//caron, hacek
	case 0x08:pMathType=mo;pmt(0x02D8);break;	//breve
	case 0x09:pMathType=mo;pmt(0x00AF);break;	//macron
	case 0x0A:pMathType=mo;pmt(0x02D9);break;	//dot above
	case 0x0B:pMathType=mo;pmt(0x00B8);break;	//cedilla
	case 0x0C:pMathType=mo;pmt(0x02DB);break;	//ogonek
	case 0x0D:pMathType=mo;pmt(0x201A);break;	//single low quot-mark
	case 0x0E:pMathType=mo;pmt(0x2329);break;	//left angle
	case 0x0F:pMathType=mo;pmt(0x232A);break;	//right angle
	

	case 0x10:pMathType=mo;pmt(0x201C);break;	//left double quotation mark
	case 0x11:pMathType=mo;pmt(0x201D);break;	//right double quotation mark
	case 0x12:pMathType=mo;pmt(0x0311);break;	//frown, combining inverted breve
	case 0x13:pMathType=mo;pmt(0x030F);break;	//combining double breve
	case 0x14:pMathType=mo;pmt(0x0306);break;	//combining breve, XXX should be cyrillic breve
	case 0x15:pMathType=mo;pmt(0x2013);break;	//en dash
	case 0x16:pMathType=mo;pmt(0x2014);break;	//em dash
	case 0x17:break;	//notdef
	case 0x18:pMathType=mo;pmt(0x00B0);break; //degree sign
	case 0x19:pMathType=mo;pmt(0x0131);break;	//dotless i
	case 0x1A:pMathType=mo;pmt(0x0237);break; //dotless j
	case 0x1B:pMathType=mo;pmt('f');pMathType=mo;pmt('f');break;//p(ul2utf8(0xFB00));break;//ligature ff
	case 0x1C:pMathType=mo;pmt('f');pMathType=mo;pmt('i');break;//p(ul2utf8(0xFB01));break;//ligature fi
	case 0x1D:pMathType=mo;pmt('f');pMathType=mo;pmt('l');break;//p(ul2utf8(0xFB02));break;//ligature fl
	case 0x1E:pMathType=mo;pmt('f');pMathType=mo;pmt('f');pMathType=mo;pmt('i');break;//p(ul2utf8(0xFB03));break;//ligature ffi
	case 0x1F:pMathType=mo;pmt('f');pMathType=mo;pmt('f');pMathType=mo;pmt('l');break;//p(ul2utf8(0xFB04));break;//ligature ffl

	case 0x20:pMathType=mo;pmt(0x2423);break;//graphic for space
	
	case 0x21:pMathType=mo;pmt(*temp);break;//!
	case 0x22:pMathType=mo;pmt(0x201D);break;//right double quotation mark
	case 0x23:
	case 0x24:
	case 0x25:pMathType=mo;pmt(*temp);break;
	case 0x26:
		if (mathmode && !mathText){
			p("<mo>&amp;</mo>");
		}else 
			p("&amp;");
		break;//ampersand
	case 0x27:pMathType=mo;pmt(0x2019);break;//right single quot-mark
	case 0x28:pMathType=mo;pmt(*temp);break;//(
	case 0x29:pMathType=mo;pmt(*temp);break;//)
	case 0x2A:
	case 0x2B:
	case 0x2C:inhibitspace=0;pMathType=mo;pmt(*temp);break;
	case 0x2D:
	case 0x2E:
	case 0x2F:pMathType=mo;pmt(*temp);break;

	case 0x30:
	case 0x31:
	case 0x32:
	case 0x33:
	case 0x34:
	case 0x35:
	case 0x36:
	case 0x37:
	case 0x38:
	case 0x39:pMathType=mn;pmt(*temp);break;
	case 0x3A:pMathType=mo;pmt(*temp);break;//:
	case 0x3B:pMathType=mo;pmt(*temp);break;//;
	case 0x3C://less than
		if(combiningUnicode==0x0338) { 
			combiningUnicode=0;
			pmt(0x226F);
		}	else{
			if (mathmode && !mathText)
				p("<mo>&lt;</mo>");
			else 
				p("&lt;");
		}
		break;
	case 0x3D:pMathType=mo;pmt(0x002F);break;//slash
	case 0x3E: //greater than
		if(combiningUnicode==0x0338) { 
			combiningUnicode=0;
			pmt(0x226F);
		}	else{
			if (mathmode && !mathText)
				p("<mo>&gt;</mo>");
			else 
				p("&gt;");
		}
		break;
	case 0x3F:pMathType=mo;pmt(*temp);break;//question mark

	case 0x40:pMathType=mo;pmt(*temp);break;//at sign

	case 0x5B:pMathType=mo;pmt(*temp);break;//[
	case 0x5C:pMathType=mo;pmt(*temp);break;//backslash
	case 0x5D:pMathType=mo;pmt(*temp);break;//]
	
	case 0x5E:pMathType=mo;pmt(*temp);break;//circumflex
	case 0x5F:pMathType=mo;pmt(*temp);break;//underscore
	case 0x60:pMathType=mo;pmt(0x2018);break;//left single quot-mark
	
	//ascii small letters

	case 0x7B:pMathType=mo;pmt(*temp);break;//left brace
	case 0x7C:pMathType=mo;pmt(*temp);break;//vertical bar
	case 0x7D:pMathType=mo;pmt(*temp);break;//right brace
	case 0x7E:pMathType=mo;pmt(*temp);break;//tilde
	case 0x7F:pMathType=mo;pmt(0x2012);break;//figure dash
	
	//combined accented 
	case 0x80:pMathType=mo;pmt(0x0102);break;//A breve
	case 0x81:pMathType=mo;pmt(0x0104);break;//A ogonek
	case 0x82:pMathType=mo;pmt(0x0106);break;//C acute
	case 0x83:pMathType=mo;pmt(0x010C);break;//C caron
	case 0x84:pMathType=mo;pmt(0x010E);break;//D caron
	case 0x85:pMathType=mo;pmt(0x011A);break;//E caron
	case 0x86:pMathType=mo;pmt(0x0118);break;//E ogonek
	case 0x87:pMathType=mo;pmt(0x011E);break;//G breve
	case 0x88:pMathType=mo;pmt(0x0139);break;//L acute
	case 0x89:pMathType=mo;pmt(0x013D);break;//L caron
	case 0x8A:pMathType=mo;pmt(0x0141);break;//L stroke
	case 0x8B:pMathType=mo;pmt(0x0143);break;//N acute
	case 0x8C:pMathType=mo;pmt(0x0147);break;//N caron
	case 0x8D:pMathType=mo;pmt(0x014A);break;//ENG
	case 0x8E:pMathType=mo;pmt(0x0150);break;//O double acute
	case 0x8F:pMathType=mo;pmt(0x0154);break;//R acute

	case 0x90:pMathType=mo;pmt(0x0158);break;//R caron
	case 0x91:pMathType=mo;pmt(0x015A);break;//S acute
	case 0x92:pMathType=mo;pmt(0x0160);break;//S caron
	case 0x93:pMathType=mo;pmt(0x015E);break;//S cedilla
	case 0x94:pMathType=mo;pmt(0x0164);break;//T caron
	case 0x95:pMathType=mo;pmt(0x0162);break;//T cedilla
	case 0x96:pMathType=mo;pmt(0x0170);break;//U double acute
	case 0x97:pMathType=mo;pmt(0x016E);break;//U ring above
	case 0x98:pMathType=mo;pmt(0x0178);break;//Y diaeresis
	case 0x99:pMathType=mo;pmt(0x0179);break;//Z acute
	case 0x9A:pMathType=mo;pmt(0x017D);break;//Z caron
	case 0x9B:pMathType=mo;pmt(0x017B);break;//Z dot above
	case 0x9C:pMathType=mo;pmt(0x0132);break;//ligature IJ
	case 0x9D:pMathType=mo;pmt(0x0130);break;//I dot above
	case 0x9E:pMathType=mo;pmt(0x0111);break;//d stroke
	case 0x9F:pMathType=mo;pmt(0x00A7);break;//section sign

	case 0xA0:pMathType=mo;pmt(0x0103);break;//a breve
	case 0xA1:pMathType=mo;pmt(0x0104);break;//a ogonek
	case 0xA2:pMathType=mo;pmt(0x0107);break;//c acute
	case 0xA3:pMathType=mo;pmt(0x010D);break;//c caron
	case 0xA4:pMathType=mo;pmt(0x010F);break;//d caron
	case 0xA5:pMathType=mo;pmt(0x011B);break;//e caron
	case 0xA6:pMathType=mo;pmt(0x0119);break;//e ogonek
	case 0xA7:pMathType=mo;pmt(0x011F);break;//g breve
	case 0xA8:pMathType=mo;pmt(0x013A);break;//l acute
	case 0xA9:pMathType=mo;pmt(0x013E);break;//l caron
	case 0xAA:pMathType=mo;pmt(0x0142);break;//l stroke
	case 0xAB:pMathType=mo;pmt(0x0144);break;//n acute
	case 0xAC:pMathType=mo;pmt(0x0148);break;//n caron
	case 0xAD:pMathType=mo;pmt(0x014B);break;//eng
	case 0xAE:pMathType=mo;pmt(0x0151);break;//o double acute
	case 0xAF:pMathType=mo;pmt(0x0155);break;//r acute
	
	case 0xB0:pMathType=mo;pmt(0x0159);break;//r caron
	case 0xB1:pMathType=mo;pmt(0x015B);break;//s acute
	case 0xB2:pMathType=mo;pmt(0x0161);break;//s caron
	case 0xB3:pMathType=mo;pmt(0x015F);break;//s cedilla
	case 0xB4:pMathType=mo;pmt(0x0165);break;//t caron
	case 0xB5:pMathType=mo;pmt(0x0163);break;//t cedilla
	case 0xB6:pMathType=mo;pmt(0x0171);break;//u double acute
	case 0xB7:pMathType=mo;pmt(0x016F);break;//u ring above
	case 0xB8:pMathType=mo;pmt(0x00FF);break;//y diaeresis
	case 0xB9:pMathType=mo;pmt(0x017A);break;//z acute
	case 0xBA:pMathType=mo;pmt(0x017E);break;//z caron
	case 0xBB:pMathType=mo;pmt(0x017C);break;//z dot above
	case 0xBC:pMathType=mo;pmt(0x0133);break;//ligature ij
	case 0xBD:pMathType=mo;pmt(0x00A1);break;//inverted exclamation sign
	case 0xBE:pMathType=mo;pmt(0x00BF);break;//inverted question sign
	case 0xBF:pMathType=mo;pmt(0x00A3);break;//pound sterling

	case 0xC0://A grave
	case 0xC1://A acute
	case 0xC2://A circumflex
	case 0xC3://A tilde
	case 0xC4://A diaeresis
	case 0xC5://A ring above
	case 0xC6://AE ligature
	case 0xC7://C cedilla
	case 0xC8://E grave
	case 0xC9://E acute
	case 0xCA://E circumflex
	case 0xCB://E diaeresis
	case 0xCC://I grave
	case 0xCD://I acute
	case 0xCE://I circumflex
	case 0xCF:pMathType=mo;pmt(*temp);break;//I diaeresis

	case 0xD0://ETH
	case 0xD1://N tilde
	case 0xD2://O grave
	case 0xD3://O acute
	case 0xD4://O circumflex
	case 0xD5://O tilde
	case 0xD6://O diaeresis
	case 0xD7://C cedilla
	case 0xD8://E grave
	case 0xD9://E acute
	case 0xDA://E circumflex
	case 0xDB://E diaeresis
	case 0xDC://I grave
	case 0xDD://I acute
	case 0xDE:pMathType=mo;pmt(*temp);break;//I circumflex
	case 0xDF:pMathType=mo;pmt(0x0152);break;//ligature OE
	
	case 0xE0://a grave
	case 0xE1://a acute
	case 0xE2://a circumflex
	case 0xE3://a tilde
	case 0xE4://a diaeresis
	case 0xE5://a ring above
	case 0xE6://ligature ae
	case 0xE7://c cedilla
	case 0xE8://e grave
	case 0xE9://e acute
	case 0xEA://e circumflex
	case 0xEB://e diaeresis
	case 0xEC://i grave
	case 0xED://i acute
	case 0xEE://i circumflex
	case 0xEF:pMathType=mo;pmt(*temp);break;//i diaeresis
	
	case 0xF0://eth
	case 0xF1://n tilde
	case 0xF2://o grave
	case 0xF3://o acute
	case 0xF4://o circumflex
	case 0xF5://o tilde
	case 0xF6:pMathType=mo;pmt(*temp);break;//o diaeresis
	case 0xF7:pMathType=mo;pmt(0x0153);break;//ligature oe
	case 0xF8://o stroke
	case 0xF9://u grave
	case 0xFA://u acute
	case 0xFB://u circumflex
	case 0xFC://u diaeresis
	case 0xFD://y acute
	case 0xFE:pMathType=mo;pmt(*temp);break;//thorn
	case 0xFF:pMathType=mo;pmt(0x00DF);break;//sharp s, german eszett
	
	default:pMathType=mo;pmt(*temp);
	}
	temp++;
}while(*temp);
return;
}

void fontMap8c(){
//tbbx, tbmo, tbmr, tbso, tbsr, tbtl, tbto
//tcssdc, torm, tosl, toti
//ts1-lm[r,ri,ro,ss, ssbo, ssbx, ssdc, ssdo, sso,ssq, ssqbo, ssqbx, ssqo, b,bo,bx,bxi,bxo,csc,csco, tcsc, tt, tti, tto, vtt, vtto]
//[r]pcx[b,bi,	bsl,i,r,sl]
//rtcx[b,bi,bsl,bss,bsso,i,r,sl,ss,sssl,]
//tcx[r,sl,ss,sssl,i,b,bi,bss,bsl,bsssl,btt,bttsl,tt,ttsl,

unsigned char* temp=(unsigned char*)yytext;

do{
	switch(*temp){
	case 0x00:pMathType=mo;pmt(0x0060);break;//grave accent
	case 0x01:pMathType=mo;pmt(0x00B4);break;//acute accent
	case 0x02:pMathType=mo;pmt(0x005E);break;//hat
	case 0x03:pMathType=mo;pmt(0x007E);break;//tilde
	case 0x04:pMathType=mo;pmt(0x0308);break;//XXX, it is combining, should be put in combineAccent
	case 0x05:pMathType=mo;pmt(0x02DD);break;//double acute accent
	case 0x06:pMathType=mo;pmt(0x02DA);break;//ring above
	case 0x07:pMathType=mo;pmt(0x02C7);break;//caron, hacek
	case 0x08:pMathType=mo;pmt(0x02D8);break;//breve
	case 0x09:pMathType=mo;pmt(0x00AF);break;//macron
	case 0x0A:pMathType=mo;pmt(0x02D9);break;//dot above
	case 0x0B:pMathType=mo;pmt(0x00B8);break;//cedilla
	case 0x0C:pMathType=mo;pmt(0x02DB);break;//ogonek
	case 0x0D:pMathType=mo;pmt(0x201A);break;//single low quot-mark
	case 0x0E:
	case 0x0F:break;//notdef
	

	case 0x10:
	case 0x11:break;//notdef
	case 0x12:pMathType=mo;pmt(0x201E);break;//low double quot-mark
	case 0x13:
	case 0x14:break;//notdef
	case 0x15:pMathType=mo;pmt(0x2013);break;//en-dash (XXX,12 ???)
	case 0x16:pMathType=mo;pmt(0x2014);break;//em-dash (XXX,3/4 ???)
	case 0x17:break;//notdef
	case 0x18:pMathType=mo;pmt(0x2190);break;//leftarrow
	case 0x19:pMathType=mo;pmt(0x2192);break;//rightarrow
	case 0x1A:pMathType=mo;pmt(0x2040);break;//tie (lower case, XXX not in Unicode 4.1)
	case 0x1B:pMathType=mo;pmt(0x2040);break;//tie (capital, XXX not in Unicode 4.1)
	case 0x1C:pMathType=mo;pmt(0x2040);break;//tie (lower case, XXX not in Unicode 4.1)
	case 0x1D:pMathType=mo;pmt(0x2040);break;//tie (capital, XXX not in Unicode 4.1)
	case 0x1E:
	case 0x1F:break;//notdef

	case 0x20:pMathType=mo;pmt(0x2422);break;//graphic for space
	case 0x21:
	case 0x22:
	case 0x23:break;//notdef
	case 0x24:pMathType=mo;pmt(*temp);break;//dollar sign
	case 0x25:
	case 0x26:break;//notdef
	case 0x27:pMathType=mo;pmt(0x2019);break;//right single quot-mark
	case 0x28:
	case 0x29:break;//notdef
	case 0x2A:pMathType=mo;pmt(*temp);break;//*
	case 0x2B:break;//notdef
	case 0x2C:inhibitspace=0;pMathType=mo;pmt(*temp);break;//comma
	case 0x2D:break;//notdef
	case 0x2E:
	case 0x2F:pMathType=mo;pmt(*temp);break;//fraction

	case 0x30:
	case 0x31:
	case 0x32:
	case 0x33:
	case 0x34:
	case 0x35:
	case 0x36:
	case 0x37:
	case 0x38:
	case 0x39:pMathType=mn;pmt(*temp);break;
	case 0x3A:break;//notdef
	case 0x3B:
	case 0x3C:
	case 0x3D:
	case 0x3E:
	case 0x3F:

	case 0x40:
	case 0x41:
	case 0x42:
	case 0x43:
	case 0x44:
	case 0x45:
	case 0x46:
	case 0x47:
	case 0x48:
	case 0x49:
	case 0x4A:
	case 0x4B:
	case 0x4C:break;//notdef
	case 0x4D:pMathType=mo;pmt(0x2127);break;//mho
	case 0x4E:break;//notdef
	case 0x4F:pMathType=mo;pmt(0x25CB);break;//white circle
	
	case 0x50:
	case 0x51:
	case 0x52:
	case 0x53:
	case 0x54:
	case 0x55:
	case 0x56:break;//notdef
	case 0x57:pMathType=mo;pmt(0x2126);break;//ohm sign
	case 0x58:
	case 0x59:
	case 0x5A:break;//notdef
	case 0x5B:pMathType=mo;pmt(0x27E6);break;//left ds square parenthesis
	case 0x5C:break;//notdef
	case 0x5D:pMathType=mo;pmt(0x27E7);break;//right ds square parenthesis
	case 0x5E:pMathType=mo;pmt(0x2191);break;//up arrow
	case 0x5F:pMathType=mo;pmt(0x2193);break;//down arrow
	
	case 0x60:pMathType=mo;pmt(0x2018);break;//left single quot-mark
	case 0x61:break;//notdef
	case 0x62:pMathType=mo;pmt(0x22C6);break;//star operator (XXX, born, Uni???)
	case 0x63:pMathType=mo;pmt(0x26AE);break;//divorce
	case 0x64:pMathType=mo;pmt(0x271D);break;//cross (XXX, died, Uni???)
	case 0x65:
	case 0x66:
	case 0x67:
	case 0x68:
	case 0x69:
	case 0x6A:
	case 0x6B:break;//notdef
	case 0x6C:pMathType=mo;pmt(0x2618);break;//leaf (XXX, Uni.shamrock???)
	case 0x6D:pMathType=mo;pmt(0x26AE);break;//marriage
	case 0x6E:pMathType=mo;pmt(0x266A);break;//musical 1/8
	case 0x6F:break;//notdef
	
	case 0x70:
	case 0x71:
	case 0x72:
	case 0x73:
	case 0x74:
	case 0x75:
	case 0x76:
	case 0x77:
	case 0x78:
	case 0x79:
	case 0x7A:
	case 0x7B:
	case 0x7C:
	case 0x7D:break;//notdef
	case 0x7E:pMathType=mo;pmt(*temp);break;//tilde
	case 0x7F:pMathType=mo;pmt('=');break;//short equals (XXX,Uni????)
	
	//combined accented 
	case 0x80:pMathType=mo;pmt(0x02D8);break;//breve
	case 0x81:pMathType=mo;pmt(0x02C7);break;//caron, hacek
	case 0x82:pMathType=mo;pmt(0x301E);break;//double prime quot-mark
	case 0x83:pMathType=mo;pmt(0x301D);break;//reversed double prime quot-mark
	case 0x84:pMathType=mo;pmt(0x2020);break;//dagger
	case 0x85:pMathType=mo;pmt(0x2021);break;//double dagger
	case 0x86:pMathType=mo;pmt(0x2225);break;//double vert
	case 0x87:pMathType=mo;pmt(0x2030);break; //per mille
	
	case 0x88:pMathType=mo;pmt(0x2022);break;//bullet
	case 0x89:pMathType=mo;pmt(0x2103);break;//degree Celsius
	case 0x8A:pMathType=mo;pmt('$');break;//dollar oldstyle (XXX,Uni????)
	case 0x8B:pMathType=mo;pmt(0x00A2);break;//cent oldstyle (XXX,Uni????)
	case 0x8C:pMathType=mo;pmt(0x0192);break;//florin
	case 0x8D:pMathType=mo;pmt(0x20A1);break;//colon
	case 0x8E:pMathType=mo;pmt(0x20A9);break;//won
	case 0x8F:pMathType=mo;pmt(0x20A6);break;//naira

	case 0x90:pMathType=mo;pmt(0x20B2);break;//guarani
	case 0x91:pMathType=mo;pmt(0x20B1);break;//peso
	case 0x92:pMathType=mo;pmt(0x20A4);break;//lira
	case 0x93:pMathType=mo;pmt(0x211E);break;//recipe
	case 0x94:pMathType=mo;pmt(0x203D);break;//interrobang
	case 0x95:pMathType=mo;pmt(0x00BF);break;//gnaborretni (XXX, Uni????)
	case 0x96:pMathType=mo;pmt(0x20AB);break;//dong sign
	case 0x97:pMathType=mo;pmt(0x2122);break;//TM
	case 0x98:pMathType=mo;pmt(0x2031);break;//per ten thousand
	case 0x99:pMathType=mo;pmt(0x00B6);break;//paragraph?? (XXX,Uni????)
	case 0x9A:pMathType=mo;pmt(0x0E3F);break;//Baht
	case 0x9B:pMathType=mo;pmt(0x2116);break;//Numero sign
	case 0x9C:pMathType=mo;pmt(0x2052);break;//commercial minus
	case 0x9D:pMathType=mo;pmt(0x212E);break;//estimated
	case 0x9E:pMathType=mo;pmt(0x25E6);break;//white bullet
	case 0x9F:pMathType=mo;pmt(0x2120);break;//service mark

	//defaults go directly Unicode
	
	case 0xAB:pMathType=mo;pmt(0x0254);break;//copyleft  (XXX,Uni????)
	case 0xAD:pMathType=mo;pmt(0x2117);break;//sound recording copyright
	
	case 0xB8:pMathType=mo;pmt(0x203B);break;//reference mark
	case 0xBB:break;//notdef
	
	case 0xBF:pMathType=mo;pmt(0x20AC);break;//euro sign

	//should be none, but let them go
	
	case 0xE6:pMathType=mo;pmt(0x00D7);break;//multiplication sign
	
	//should be none, but let them go
	
	case 0xF6:pMathType=mo;pmt(0x00F7);break;//division sign
	
	default:pMathType=mo;pmt(*temp);
	}
	temp++;
}while(*temp);
return;

}



void fontMap8q(){
//qx-lmr[i,o],qx-lmss[bo,bx,dc,do,o,q,qo, qbo,qbx] qx-lmb[o,x], qx-lmbx[i,o], qx-lmcsc[o]
//qx-lmtcsc, qx-lmtt[i,o], qx-lmvtt[o]
//qb[kb,kbi,kr,kri], qh[vb,vbi,vcb,vcbi,vcr,vcri,vr,vri], qpl[b,bi,r,ri], qcr[b,bi,rr,rri] (tt)
//qtm[b,bi,r,ri,]
//qzcmi
//txbex
//vn[b,bx,bxsl,bxti,csc,dunh,ff,fi,fib,itt,r,sl,sltt,ss,ssbx,ssdc,ssi,ssq,ssqi,tcsc,ti,ttu,vtt
unsigned char* temp=(unsigned char*)yytext;
do{
	switch(*temp){
	case 0x00:pMathType=mo;pmt(0x03B1);break;//alpha
	case 0x01:pMathType=mo;pmt(0x0394);break;//Delta
	case 0x02:pMathType=mi;pmt(0x03B2);break;//beta
	case 0x03:pMathType=mi;pmt(0x03B4);break;//delta
	case 0x04:pMathType=mi;pmt(0x03C0);break;//pi
	case 0x05:pMathType=mo;pmt(0x03A0);break;//Pi
	case 0x06:pMathType=mo;pmt(0x03A3);break;//Sigma
	case 0x07:pMathType=mi;pmt(0x03BC);break;//mu
	case 0x08:pMathType=mo;pmt(0x2026);break;//horizontal ellipsis
	case 0x09:pMathType=mo;pmt(0x2620);break;//poison
	case 0x0A:pMathType=mo;pmt(0x03A9);break;//Omega
	case 0x0B:pMathType=mo;pmt('f');pMathType=mo;pmt('f');break;//p(ul2utf8(0xFB00));break;//ligature ff
	case 0x0C:pMathType=mo;pmt('f');pMathType=mo;pmt('i');break;//p(ul2utf8(0xFB01));break;//ligature fi
	case 0x0D:pMathType=mo;pmt('f');pMathType=mo;pmt('l');break;//p(ul2utf8(0xFB02));break;//ligature fl
	case 0x0E:pMathType=mo;pmt('f');pMathType=mo;pmt('f');pMathType=mo;pmt('i');break;//p(ul2utf8(0xFB03));break;//ligature ffi
	case 0x0F:pMathType=mo;pmt('f');pMathType=mo;pmt('f');pMathType=mo;pmt('l');break;//p(ul2utf8(0xFB04));break;//ligature ffl

	case 0x10:pMathType=mo;pmt(0x0131);break;//dotless i
	case 0x11:pMathType=mo;pmt(0x0237);break;//dotless j
	case 0x12:pMathType=mo;pmt(0x0060);break;//grave accent
	case 0x13:pMathType=mo;pmt(0x00B4);break;//acute accent
	case 0x14:pMathType=mo;pmt(0x02C7);break;//caron, hacek
	case 0x15:pMathType=mo;pmt(0x02D8);break;//breve
	case 0x16:pMathType=mo;pmt(0x00AF);break;//macron
	case 0x17:pMathType=mo;pmt(0x02DA);break;//ring above
	case 0x18:pMathType=mo;pmt(0x00B8);break;//cedilla
	case 0x19:pMathType=mo;pmt(0x00DF);break;//german SS
	case 0x1A:pMathType=mo;pmt(0x00E6);break;//latin ae
	case 0x1B:pMathType=mo;pmt(0x0153);break;//latin oe
	case 0x1C:pMathType=mo;pmt(0x00F8);break;//o slash
	case 0x1D:pMathType=mo;pmt(0x00C6);break;//latin AE
	case 0x1E:pMathType=mo;pmt(0x0152);break;//latin OE
	case 0x1F:pMathType=mo;pmt(0x00D8);break;//O slash

	//space to default
	case 0x21:pMathType=mo;pmt(*temp);break;//!
	case 0x22:pMathType=mo;pmt(0x201D);break;//right double quotation mark
	case 0x23://number sign
	case 0x24://US dollar symbol
	case 0x25:pMathType=mo;pmt(*temp);break;//percent
	case 0x26://ampersand
		if (mathmode && !mathText){
			p("<mo>&amp;</mo>");
		}else 
			p("&amp;");
		break;
	case 0x27:pMathType=mo;pmt(0x2019);break;//right single quot-mark
	case 0x28:pMathType=mo;pmt(*temp);break;//(
	case 0x29:pMathType=mo;pmt(*temp);break;//)
	case 0x2A://asterisk
	case 0x2B://plus
	case 0x2C:inhibitspace=0;pMathType=mo;pmt(*temp);break;//comma
	case 0x2D://hyphen
	case 0x2E://period
	case 0x2F:pMathType=mo;pmt(*temp);break;//slash

	case 0x30:
	case 0x31:
	case 0x32:
	case 0x33:
	case 0x34:
	case 0x35:
	case 0x36:
	case 0x37:
	case 0x38:
	case 0x39:pMathType=mn;pmt(*temp);break;	//numbers 0-9
	case 0x3A:pMathType=mo;pmt(*temp);break;	//colon
	case 0x3B:pMathType=mo;pmt(*temp);break;	//semicolon
	case 0x3C:pMathType=mo;pmt(0x00A1);break;	//inverted exclamation mark
	case 0x3D: //equal
		pMathType=mo;
		precomposedNegative(*temp, 0x2260);
		break;
	case 0x3E:pMathType=mo;pmt(0x00BF);break;	//inverted question mark
	case 0x3F:pMathType=mo;pmt(*temp);break;	//question mark

	case 0x40:pMathType=mo;pmt(*temp);break; //at
	
	//A to Z go to default: mo
	
	case 0x5B:pMathType=mo;pmt(*temp);break;	//[
	case 0x5C:pMathType=mo;pmt(0x201C);break;	//left double quotation mark
	case 0x5D:pMathType=mo;pmt(*temp);break;	//]
	case 0x5E:pMathType=mo;pmt(*temp);break;	//^
	case 0x5F:pMathType=mo;pmt(0x02D9);break;	//dot above

	case 0x60:pMathType=mo;pmt(*temp);break;	//quoteleft
	
	//a to z go to default: mo
	
	case 0x7B:pMathType=mo;pmt(0x2013);break;	//en dash
	case 0x7C:pMathType=mo;pmt(0x2014);break;	//em dash
	case 0x7D:pMathType=mo;pmt(0x02DD);break;	//double acute accent, 0x30B combining
	case 0x7E:pMathType=mo;pmt(*temp);break;	//tilde
	case 0x7F:pMathType=mo;pmt(0x00A8);break;	//diaeresis
	
	case 0x80:pMathType=mo;pmt(0x20AC);break;	//euro sign
	case 0x81:pMathType=mo;pmt(0x0104);break;	//A ogonek
	case 0x82:pMathType=mo;pmt(0x0106);break;	//C acute
	case 0x83:p("&gt;");//greater
	case 0x84:pMathType=mo;pmt(0x2265);break;	//greater equal
	case 0x85:pMathType=mo;pmt(0x224A);break;	//approxequal
	case 0x86:pMathType=mo;pmt(0x0118);break;	//E ogonek
	case 0x87:pMathType=mo;pmt(0x012E);break;	//I ogonek
	case 0x88:p("&lt;");//less
	case 0x89:pMathType=mo;pmt(0x2264);break;	//less equal
	case 0x8A:pMathType=mo;pmt(0x0141);break;	//L stroke
	case 0x8B:pMathType=mo;pmt(0x0143);break;	//N acute
	case 0x8C:pMathType=mo;pmt('~');break;		//ascii tilde
	case 0x8D:pMathType=mo;pmt('^');break;		//ascii circumflex
	case 0x8E:pMathType=mo;pmt(0x2113);break;	//ell script
	case 0x8F:pMathType=mo;pmt(0x2020);break;	//dagger
	
	case 0x90:pMathType=mo;pmt(0x2021);break;	//double dagger
	case 0x91:pMathType=mo;pmt(0x015A);break;	//S acute
	case 0x92:pMathType=mo;pmt(0x015C);break;	//S caron
	case 0x93:pMathType=mo;pmt(0x0218);break;	//S commma-under accent, romanian Sh
	case 0x94:pMathType=mo;pmt(0x00B0);break; //degree sign
	case 0x95:pMathType=mo;pmt(0x021A);break;	//T commma-under accent, romanian Ts
	case 0x96:pMathType=mo;pmt(0x02DB);break;	//ogonek
	case 0x97:pMathType=mo;pmt(0x0172);break;	//U ogonek
	case 0x98:pMathType=mo;pmt(0x0178);break;	//Y diaeresis
	case 0x99:pMathType=mo;pmt(0x0179);break;	//Z acute
	case 0x9A:pMathType=mo;pmt(0x017D);break;	//Z caron
	case 0x9B:pMathType=mo;pmt(0x017B);break;	//Z dot accent
	case 0x9C:pMathType=mo;pmt(0x0132);break;	//IJ
	case 0x9D:pMathType=mo;pmt('{');break;		//brace left
	case 0x9E:pMathType=mo;pmt('}');break;		//brace right
	case 0x9F:pMathType=mo;pmt(0x00A7);break;	//section

	case 0xA0:break;											//notdef
	case 0xA1:pMathType=mo;pmt(0x0105);break;	//a ogonek
	case 0xA2:pMathType=mo;pmt(0x0107);break;	//c acute
	case 0xA3:pMathType=mo;pmt(0x00AE);break;	//registered mark
	case 0xA4:pMathType=mo;pmt(0x2117);break;	//copyright sign
	case 0xA5:pMathType=mo;pmt(0x007C);break;	//division
	case 0xA6:pMathType=mo;pmt(0x0119);break;	//e ogonek
	case 0xA7:pMathType=mo;pmt(0x012F);break;	//i ogonek
	case 0xA8:pMathType=mo;pmt(0x2212);break;	//minus
	case 0xA9:pMathType=mo;pmt(0x00D7);break;	//multiplication sign
	case 0xAA:pMathType=mo;pmt(0x0142);break;	//l with stroke
	case 0xAB:pMathType=mo;pmt(0x0144);break;	//n acute
	case 0xAC:pMathType=mo;pmt(0x00B1);break;	//plus-minus
	case 0xAD:pMathType=mo;pmt(0x221E);break;	//infinity
	case 0xAE:pMathType=mo;pmt(0x00AB);break;	//left guillemet
	case 0xAF:pMathType=mo;pmt(0x00BB);break;	//right guillemet

	case 0xB0:pMathType=mo;pmt(0x0086);break;	//paragraph
	case 0xB1:pMathType=mo;pmt(0x015B);break;	//s acute
	case 0xB2:pMathType=mo;pmt(0x0161);break;	//s caron
	case 0xB3:pMathType=mo;pmt(0x0219);break;	//s comma-under accent, romanian sh
	case 0xB4:pMathType=mo;pmt(0x2022);break;	//bullet
	case 0xB5:pMathType=mo;pmt(0x021B);break;	//t comma-under accent, romanian ts
	case 0xB6:pMathType=mo;pmt(0x2014);break;	//em-dash (XXX, 3/4 em-dash, Uni????)
	case 0xB7:pMathType=mo;pmt(0x0173);break;	//u ogonek
	case 0xB8:pMathType=mo;pmt(0x00FF);break;	//y diaeresis
	case 0xB9:pMathType=mo;pmt(0x017A);break;	//z acute
	case 0xBA:pMathType=mo;pmt(0x017E);break;	//z caron
	case 0xBB:pMathType=mo;pmt(0x017C);break;	//z dot accent
	case 0xBC:pMathType=mo;pmt(0x0133);break;	//ij
	case 0xBD:pMathType=mo;pmt(0x00B7);break;	//centered dot
	case 0xBE:pMathType=mo;pmt('\"');break;		//quote double
	case 0xBF:pMathType=mo;pmt('\'');break;		//quote single

	case 0xC6:pMathType=mo;pmt('\\');break;		//backslash
	
	case 0xD7:pMathType=mo;pmt(0x00A4);break;	//currency sign
	case 0xD8:pMathType=mo;pmt(0x2030);break; //per mille	
	
	case 0xDF:pMathType=mo;pmt('|');break; 		//vertical bar

	case 0xE6:pMathType=mo;pmt('_');break;		//underscore
	
	case 0xF7:pMathType=mo;pmt(0x2222);break;	//angle arc
	case 0xF8:pMathType=mo;pmt(0x2300);break;	//diameter
	
	case 0xFF:pMathType=mo;pmt(0x201E);break;//low double comma quote-mark
	
	default:pMathType=mo;pmt(*temp);
	}
	temp++;
}while(*temp);
return;

}


void fontMap8y(){//TeXnANSI
//texnansi-lmr[i,o], texnansi-lmss[bo,bx,dc,do,o,q,qo, qbo,qbx], texnansi-lmb[o,x,xi,xo], texnansi-lmcsc[o]
//texnansi-lmtt[i,o], texnansi-lmtcsc, texnansi-lmvtt[o]
//tyx[r,i,b,sc,sl,ss,sssc,sssl, tt,ttsl,ttsc,bi,bsc,bsl,bss,bsssc,bsssl,btt,bttsc,bttsl,
//pag[k,ko,d,do]8c (euro in 0xBF), pag[d,k,ko]8r
//pbk[d,di,do,l,li,lo]8c (euro in 0xBF)
//pcr[r,ro,b,bo]8c (euro in 0xBF)
//pzcmi8c (euro in 0xBF)
//pfr[b,i,c,ci,l,li,r,ri,u]8c, pfr[b,c,l,r,u]8cc
//phv[r,ro,b,bo]8c,phv[ro,bo]8cn
//pnc[b,bi,bo,r,ri,ro]8c
//ppl[b,bi,bo,r,ri,ro]8c
//ptm[b,bi,bo,r,ri,ro]8c

unsigned char* temp=(unsigned char*)yytext;

do{
	switch(*temp){
	case 0x00:break;//notdef
	case 0x01:pMathType=mo;pmt(0x20AC);break;	//euro sign
	case 0x02:break;	//notdef
	case 0x03:break;	//notdef
	case 0x04:pMathType=mo;pmt(0x2044);break;	//fraction slash
	case 0x05:pMathType=mo;pmt(0x02D9);break;	//dot above
	case 0x06:pMathType=mo;pmt(0x02DD);break;	//double acute accent
	case 0x07:pMathType=mo;pmt(0x02DB);break;	//ogonek
	case 0x08:pMathType=mo;pmt('f');pMathType=mo;pmt('l');break;//p(ul2utf8(0xFB02));break;//ligature fl
	case 0x09:break;//notdef
	case 0x0A:break;//notdef
	case 0x0B:pMathType=mo;pmt('f');pMathType=mo;pmt('f');break;//p(ul2utf8(0xFB00));break;//ligature ff
	case 0x0C:pMathType=mo;pmt('f');pMathType=mo;pmt('i');break;//p(ul2utf8(0xFB01));break;//ligature fi
	case 0x0D:break;//notdef
	case 0x0E:pMathType=mo;pmt('f');pMathType=mo;pmt('f');pMathType=mo;pmt('i');break;//p(ul2utf8(0xFB03));break;//ligature ffi
	case 0x0F:pMathType=mo;pmt('f');pMathType=mo;pmt('f');pMathType=mo;pmt('l');break;//p(ul2utf8(0xFB04));break;//ligature ffl

	case 0x10:pMathType=mo;pmt(0x0131);break;	//imath
	case 0x11:pMathType=mo;pmt(0x006A);break;	//jmath,pmt(0x0237);break;//jmath
	case 0x12:pMathType=mo;pmt(0x0060);break;	//grave accent
	case 0x13:pMathType=mo;pmt(0x00B4);break;	//acute accent
	case 0x14:pMathType=mo;pmt(0x02C7);break;	//caron, hacek
	case 0x15:pMathType=mo;pmt(0x02D8);break;	//breve
	case 0x16:pMathType=mo;pmt(0x00AF);break;	//macron
	case 0x17:pMathType=mo;pmt(0x02DA);break;	//ring above
	case 0x18:pMathType=mo;pmt(0x00B8);break;	//cedilla
	case 0x19:pMathType=mo;pmt(0x00DF);break;	//german SS
	case 0x1A:pMathType=mo;pmt(0x00E6);break;	//latin ae
	case 0x1B:pMathType=mo;pmt(0x0153);break;	//latin oe
	case 0x1C:pMathType=mo;pmt(0x00F8);break;	//o slash
	case 0x1D:pMathType=mo;pmt(0x00C6);break;	//latin AE
	case 0x1E:pMathType=mo;pmt(0x0152);break;	//latin OE
	case 0x1F:pMathType=mo;pmt(0x00D8);break;	//O slash

	case 0x20:pMathType=mo;pmt(0x2423);break;	//graphic for space
	
	case 0x21:pMathType=mo;pmt(*temp);break;	//exclamation sign
	case 0x22:pMathType=mo;pmt(0x201D);break;	//right double quotation mark
	case 0x23:
	case 0x24:
	case 0x25:pMathType=mo;pmt(*temp);break;
	case 0x26:
		if (mathmode && !mathText){
			p("<mo>&amp;</mo>");
		}else 
			p("&amp;");
		break;//ampersand
	case 0x27:pMathType=mo;pmt(*temp);break;	//right single quot-mark
	case 0x28:pMathType=mo;pmt(*temp);break;	//(
	case 0x29:pMathType=mo;pmt(*temp);break;	//)
	case 0x2A:
	case 0x2B:
	case 0x2C:inhibitspace=0;pMathType=mo;pmt(*temp);break;
	case 0x2D:
	case 0x2E:
	case 0x2F:pMathType=mo;pmt(*temp);break;

	case 0x30:
	case 0x31:
	case 0x32:
	case 0x33:
	case 0x34:
	case 0x35:
	case 0x36:
	case 0x37:
	case 0x38:
	case 0x39:pMathType=mn;pmt(*temp);break;
	case 0x3A:pMathType=mo;pmt(*temp);break;	//colon
	case 0x3B:pMathType=mo;pmt(*temp);break;	//semicolon
	case 0x3C://less than
		if(combiningUnicode==0x0338) { 
			combiningUnicode=0;
			pmt(0x226F);
		}	else	p("<mo>&lt;</mo>");
		break;
	case 0x3D:pMathType=mo;pmt(0x002F);break;	//slash
	case 0x3E: //greater than
		if(combiningUnicode==0x0338) { 
			combiningUnicode=0;
			pmt(0x226F);
		}	else	p("<mo>&gt;</mo>");
		break;
	case 0x3F:pMathType=mo;pmt(*temp);break;	//question sign

	case 0x40:pMathType=mo;pmt(*temp);break;	//at sign
	
	//ascii capital letters
	
	case 0x5B:pMathType=mo;pmt(*temp);break;//[
	case 0x5C:pMathType=mo;pmt(*temp);break;//backslash
	case 0x5D:pMathType=mo;pmt(*temp);break;//]
	
	case 0x5E:pMathType=mo;pmt(*temp);break;	//circumflex
	case 0x5F:pMathType=mo;pmt(*temp);break;	//underscore
	
	case 0x60:pMathType=mo;pmt(*temp);break;	//left single quot-mark
	
	//ascii small letters

	case 0x7B:pMathType=mo;pmt(*temp);break;	//left brace
	case 0x7C:pMathType=mo;pmt(*temp);break;	//vertical bar
	case 0x7D:pMathType=mo;pmt(*temp);break;	//right brace
	case 0x7E:pMathType=mo;pmt(*temp);break;	//tilde
	case 0x7F:pMathType=mo;pmt(0x00A8);break;	//diaeresis
	
	//LY1 specific
	case 0x80:pMathType=mo;pmt(0x0141);break;	//L stroke
	case 0x81:pMathType=mo;pmt(0x201B);break;	//quote single
	case 0x82:pMathType=mo;pmt(0x201A);break;	//single low quot-mark
	case 0x83:pMathType=mo;pmt(0x0192);break;	//florin currency
	case 0x84:pMathType=mo;pmt(0x201E);break;	//double low quot-mark
	case 0x85:pMathType=mo;pmt(0x2026);break;	//horizontal ellipsis
	case 0x86:pMathType=mo;pmt(0x2020);break;	//dagger
	case 0x87:pMathType=mo;pmt(0x2021);break;	//double dagger
	case 0x88:pMathType=mo;pmt(0x005E);break;	//circumflex
	case 0x89:pMathType=mo;pmt(0x2030);break; //per mille
	case 0x8A:pMathType=mo;pmt(0x0160);break;	//S caron
	case 0x8B:pMathType=mo;pmt(0x2039);break;	//left single guillemet
	case 0x8C:pMathType=mo;pmt(0x0152);break;	//OE
	case 0x8D:pMathType=mo;pmt(0x017D);break;	//Z caron
	case 0x8E:pMathType=mo;pmt(0x005E);break;	//ascii circumflex
	case 0x8F:pMathType=mo;pmt(0x2212);break;	//minus

	case 0x90:pMathType=mo;pmt(0x0142);break;	//l stroke
	case 0x91:pMathType=mo;pmt(0x2018);break;	//left single quot-mark
	case 0x92:pMathType=mo;pmt(0x2019);break;	//right single quot-mark
	case 0x93:pMathType=mo;pmt(0x201C);break;	//left double quot-mark
	case 0x94:pMathType=mo;pmt(0x201D);break;	//right double quot-mark
	case 0x95:pMathType=mo;pmt(0x2022);break;	//bullet
	case 0x96:pMathType=mo;pmt(0x2013);break;	//en-dash
	case 0x97:pMathType=mo;pmt(0x2014);break;	//em-dash
	case 0x98:pMathType=mo;pmt(0x007E);break;	//tilde
	case 0x99:pMathType=mo;pmt(0x2122);break;	//TradeMark
	case 0x9A:pMathType=mo;pmt(0x0161);break;	//s caron
	case 0x9B:pMathType=mo;pmt(0x2040);break;	//right single guillemet
	case 0x9C:pMathType=mo;pmt(0x0153);break;	//oe
	case 0x9D:pMathType=mo;pmt(0x017E);break;	//z caron
	case 0x9E:pMathType=mo;pmt(0x223C);break;	//tilde operator
	case 0x9F:pMathType=mo;pmt(0x0178);break;	//Y diaeresis

	//0xA0-0xFF go to default:mo, //Unicode4.1 Latin-1 supplement
	
	default:pMathType=mo;pmt(*temp);
	}
	temp++;
}while(*temp);
return;

}


void fontMap8z(){//OT1+ISO Latin2, XL2
//cmr, cmsl, cmss, cmssbx, cmssbxo, cmssdc, cmssi, cmsssq, cmssqi, cmb, cmbx, cmbxsl, cmdunh, cmff, cmfib, cmfibs, cmvtt
//cmbr, cmbrbx, cmbrsl, cmsslu, cmssu	
//cmu, cmti, cmbxti, cmffi, cmbxcd, cmvtti, ccti (with pound instead of dollar)
//ccr, ccsl, ccslc
//lcmss[b]
//zplmb7t, zplmr7t
//px[r, i,b,bi,bsl,sl] +(6glyphs);
//rpx[b,bi]
//rtx[r,sl,ss,sssc,sssl,bsl,bss,bsssl] (with <, >, instead of exclam up/question down)
//tx[r,i,sl,ss,sssl,b,bi,bsl,bss,bsssl]
//pag[k,kc,ko,dc,do]7t
//pbk[d,dc,di,do,l,lcli,lo]7t
//pcr[b,bc,bo,r,rc,ro]7t
//pfr[r,ri,c,ci,l,li,b,bi,u]7t, pfr[r,ri,b,c,l,li,u]7tc
//phv[r,rc,ro,b,bc,bo]7t,phv[r,rc,ro,b,bc,bo]7tn
//pnc[b,bi,bo,r,rc,ri,ro]7t
//ppl[b,bc,bi,bo,r,rc,ri,ro]7t,zpple[r,b]7t
//ptm[,b,bc,bi,bo,r,rc,ri,ro]7t, zptmcm7t
//pzmi7t

unsigned char* temp=(unsigned char*)yytext; 
do{
	switch(*temp){
	case 0x00:pMathType=mo;pmt(0x0393);break;	//Gamma
	case 0x01:pMathType=mo;pmt(0x0394);break;	//Delta
	case 0x02:pMathType=mo;pmt(0x0398);break;	//Theta
	case 0x03:pMathType=mo;pmt(0x039B);break;	//Lambda
	case 0x04:pMathType=mo;pmt(0x039E);break;	//Xi
	case 0x05:pMathType=mo;pmt(0x03A0);break;	//Pi
	case 0x06:pMathType=mo;pmt(0x03A3);break;	//Sigma
	case 0x07:pMathType=mo;pmt(0x03D2);break;	//Upsilon with hook
	case 0x08:pMathType=mo;pmt(0x03A6);break;	//Phi
	case 0x09:pMathType=mo;pmt(0x03A8);break;	//Psi
	case 0x0A:pMathType=mo;pmt(0x03A9);break;	//Omega
	case 0x0B:pMathType=mo;pmt('f');pMathType=mo;pmt('f');break;//p(ul2utf8(0xFB00));break;//ligature ff
	case 0x0C:pMathType=mo;pmt('f');pMathType=mo;pmt('i');break;//p(ul2utf8(0xFB01));break;//ligature fi
	case 0x0D:pMathType=mo;pmt('f');pMathType=mo;pmt('l');break;//p(ul2utf8(0xFB02));break;//ligature fl
	case 0x0E:pMathType=mo;pmt('f');pMathType=mo;pmt('f');pMathType=mo;pmt('i');break;//p(ul2utf8(0xFB03));break;//ligature ffi
	case 0x0F:pMathType=mo;pmt('f');pMathType=mo;pmt('f');pMathType=mo;pmt('l');break;//p(ul2utf8(0xFB04));break;//ligature ffl

	case 0x10:pMathType=mo;pmt(0x0131);break;	//imath
	case 0x11:pMathType=mo;pmt(0x006A);break;	//jmath,pmt(0x0237);break;//jmath
	case 0x12:pMathType=mo;pmt(0x0060);break;	//grave accent
	case 0x13:pMathType=mo;pmt(0x00B4);break;	//acute accent
	case 0x14:pMathType=mo;pmt(0x02C7);break;	//caron, hacek
	case 0x15:pMathType=mo;pmt(0x02D8);break;	//breve
	case 0x16:pMathType=mo;pmt(0x00AF);break;	//macron
	case 0x17:pMathType=mo;pmt(0x02DA);break;	//ring above
	case 0x18:pMathType=mo;pmt(0x00B8);break;	//cedilla
	case 0x19:pMathType=mo;pmt(0x00DF);break;	//german SS
	case 0x1A:pMathType=mo;pmt(0x00E6);break;	//latin ae
	case 0x1B:pMathType=mo;pmt(0x0153);break;	//latin oe
	case 0x1C:pMathType=mo;pmt(0x00F8);break;	//o slash
	case 0x1D:pMathType=mo;pmt(0x00C6);break;	//latin AE
	case 0x1E:pMathType=mo;pmt(0x0152);break;	//latin OE
	case 0x1F:pMathType=mo;pmt(0x00D8);break;	//O slash

	case 0x20:combiningUnicode=0x0374;break;	//.notdef, overlay short solidus
	case 0x21:pMathType=mo;pmt(*temp);break;	//exclamation sign
	case 0x22:pMathType=mo;pmt(0x201D);break;	//right double quotation mark
	case 0x23://number sign
	case 0x24://US dollar symbol
	case 0x25:pMathType=mo;pmt(*temp);break;//percent
	case 0x26://ampersand
		if (mathmode && !mathText){
			p("<mo>&amp;</mo>");
		}else 
			p("&amp;");
		break;
	case 0x27:pMathType=mo;pmt(0x2018);break;	//left single quot-mark
	case 0x28:pMathType=mo;pmt(*temp);break;	//(
	case 0x29:pMathType=mo;pmt(*temp);break;	//)
	case 0x2A://asterisk
	case 0x2B://plus
	case 0x2C:inhibitspace=0;pMathType=mo;pmt(*temp);break;//comma
	case 0x2D://hyphen
	case 0x2E://period
	case 0x2F:pMathType=mo;pmt(*temp);break;	//slash

	case 0x30:
	case 0x31:
	case 0x32:
	case 0x33:
	case 0x34:
	case 0x35:
	case 0x36:
	case 0x37:
	case 0x38:
	case 0x39:pMathType=mn;pmt(*temp);break;	//numbers 0-9
	case 0x3A:pMathType=mo;pmt(*temp);break;	//colon
	case 0x3B:pMathType=mo;pmt(*temp);break;	//semicolon
	case 0x3C:pMathType=mo;pmt(0x00A1);break;	//inverted exclamation mark
	case 0x3D: //equal
		pMathType=mo;
		precomposedNegative(*temp, 0x2260);
		break;
	case 0x3E:pMathType=mo;pmt(0x00BF);break;	//inverted question mark
	case 0x3F:pMathType=mo;pmt(*temp);break;	//question mark

	case 0x40:pMathType=mo;pmt(*temp);break; //at sign
	
	//A to Z go to default: mo
	
	case 0x5B:pMathType=mo;pmt(*temp);break;	//[
	case 0x5C:pMathType=mo;pmt(0x201C);break;	//left double quotation mark
	case 0x5D:pMathType=mo;pmt(*temp);break;	//]
	case 0x5E:pMathType=mo;pmt(*temp);break;	//circumflex
	case 0x5F:pMathType=mo;pmt(0x02D9);break;	//dot above

	case 0x60:pMathType=mo;pmt(0x2019);break;	//right single quot-mark
	
	//a to z go to default: mo
	
	case 0x7B:pMathType=mo;pmt(0x2013);break;	//en dash
	case 0x7C:pMathType=mo;pmt(0x2014);break;	//em dash
	case 0x7D:pMathType=mo;pmt(0x02DD);break;	//double acute accent, 0x30B combining
	case 0x7E:pMathType=mo;pmt(*temp);break;	//tilde
	case 0x7F:pMathType=mo;pmt(0x00A8);break;	//diaeresis

	case 0x80:pMathType=mo;pmt(0x2026);break;	//horizontal ellipsis	
	case 0x81:pMathType=mo;pmt(0x2020);break;	//dagger
	case 0x82:pMathType=mo;pmt(0x2021);break;	//ddagger
	case 0x83:pMathType=mo;pmt(0x2022);break;	//bullet
	case 0x84:pMathType=mo;pmt(0x00A3);break;	//pound sterling
	case 0x85:pMathType=mo;pmt(*temp);break;	//paragraph
	case 0x86:
	case 0x87:
	case 0x88:
	case 0x89:
	case 0x8A:
	case 0x8B:
	case 0x8C:break;	//notdef
	case 0x8D:pMathType=mo;pmt(0x2030);break; //per mille
	case 0x8E:
	case 0x8F:
	
	case 0x90:
	case 0x91:
	case 0x92:
	case 0x93:
	case 0x94:
	case 0x95:
	case 0x96:
	case 0x97:break;	//notdef
	case 0x98:pMathType=mo;pmt(0x00C0);break; //A grave
	case 0x99:
	case 0x9A:
	case 0x9B:break;	//notdef
	case 0x9C:pMathType=mo;pmt(0x002D);break; //hyphen
	case 0x9D:pMathType=mo;pmt(0x02DB);break;	//ogonek	
	case 0x9E:pMathType=mo;pmt(0x00AB);break;	//guillemet left 	
	case 0x9F:pMathType=mo;pmt(0x00BB);break;	//guillemet right 
	
	case 0xA0:break;	//notdef
	case 0xA1:pMathType=mo;pmt(0x0104);break;	//A ogonek
	case 0xA2:pMathType=mo;pmt(0x02D8);break;	//breve
	case 0xA3:pMathType=mo;pmt(0x0141);break;	//L stroke	
	case 0xA4:pMathType=mo;pmt(*temp);break;	//currency sign
	case 0xA5:pMathType=mo;pmt(0x013D);break;	//L caron
	case 0xA6:pMathType=mo;pmt(0x015A);break;	//S acute	
	case 0xA7:	//section	
	case 0xA8:pMathType=mo;pmt(*temp);break;	//diaeresis	
	case 0xA9:pMathType=mo;pmt(0x0160);break;	//S caron	
	case 0xAA:pMathType=mo;pmt(0x015E);break;	//S cedilla	
	case 0xAB:pMathType=mo;pmt(0x0164);break;	//T caron	
	case 0xAC:pMathType=mo;pmt(0x0179);break;	//Z acute
	case 0xAD:break;	//notdef
	case 0xAE:pMathType=mo;pmt(0x017D);break;	//Z caron
	case 0xAF:pMathType=mo;pmt(0x017B);break;	//Z dot above
	
	case 0xB0:pMathType=mo;pmt(0x02DA);break;	//ring above
	case 0xB1:pMathType=mo;pmt(0x0104);break;	//a ogonek
	case 0xB2:pMathType=mo;pmt(0x00B8);break;	//cedilla
	case 0xB3:pMathType=mo;pmt(0x0142);break;	//l stroke
	case 0xB4:pMathType=mo;pmt(0x00B4);break;	//acute accent
	case 0xB5:pMathType=mo;pmt(0x013E);break;	//l caron
	case 0xB6:pMathType=mo;pmt(0x015B);break;	//s acute
	case 0xB7:pMathType=mo;pmt(0x02C7);break;	//caron, hacek
	case 0xB8:pMathType=mo;pmt(0x00E0);break;	//a grave
	case 0xB9:pMathType=mo;pmt(0x0161);break;	//s caron
	case 0xBA:pMathType=mo;pmt(0x015F);break;	//s cedilla
	case 0xBB:pMathType=mo;pmt(0x0165);break;	//t caron
	case 0xBC:pMathType=mo;pmt(0x017A);break;	//z acute
	case 0xBD:pMathType=mo;pmt(0x02DD);break;	//double acute accent, 0x30B combining
	case 0xBE:pMathType=mo;pmt(0x017E);break;	//z caron
	case 0xBF:pMathType=mo;pmt(0x02DD);break;	//double acute accent, 0x30B combining
	
	case 0xC0:pMathType=mo;pmt(0x0154);break;//R acute
	case 0xC1:	//A acute
	case 0xC2:pMathType=mo;pmt(*temp);break;	//A circumflex
	case 0xC3:pMathType=mo;pmt(0x0102);break;	//A breve
	case 0xC4:pMathType=mo;pmt(*temp);break;	//A diaeresis
	case 0xC5:pMathType=mo;pmt(0x0139);break;	//L acute
	case 0xC6:pMathType=mo;pmt(0x0106);break;	//C acute
	case 0xC7:pMathType=mo;pmt(*temp);break;	//C cedilla
	case 0xC8:pMathType=mo;pmt(0x00C0);break; //A grave
	case 0xC9:pMathType=mo;pmt(0x010C);break;	//C caron
	case 0xCA:pMathType=mo;pmt(0x00C9);break;	//E acute
	case 0xCB:pMathType=mo;pmt(0x0118);break;	//E ogonek
	case 0xCC:pMathType=mo;pmt(0x00CB);break; //E diaeresis
	case 0xCD:pMathType=mo;pmt(0x011A);break;	//E caron
	case 0xCE:pMathType=mo;pmt(0x00CD);break;	//I acute
	case 0xCF:pMathType=mo;pmt(0x010E);break;	//D caron
	
	case 0xD0:pMathType=mo;pmt(*temp);break;	//Eth
	case 0xD1:pMathType=mo;pmt(0x0143);break;	//N acute
	case 0xD2:pMathType=mo;pmt(0x0147);break;	//N caron
	case 0xD3:pMathType=mo;pmt(*temp);break;	//O acute
	case 0xD4:pMathType=mo;pmt(*temp);break;	//O circumflex
	case 0xD5:pMathType=mo;pmt(0x0150);break;	//O double acute
	case 0xD6:pMathType=mo;pmt(*temp);break;	//O diaeresis
	case 0xD7:pMathType=mo;pmt(0x00D7);break;	//multiply 
	case 0xD8:pMathType=mo;pmt(0x0158);break;	//R caron
	case 0xD9:pMathType=mo;pmt(0x016E);break;	//U ring above
	case 0xDA:pMathType=mo;pmt(*temp);break;	//U acute
	case 0xDB:pMathType=mo;pmt(0x0170);break;	//U double acute
	case 0xDC: //U diaeresis
	case 0xDD:pMathType=mo;pmt(*temp);break;	//Y acute
	case 0xDE:pMathType=mi;p("T");p(ul2utf8(0x0328)); break;//T ogonek
	case 0xDF:pMathType=mo;pmt(0x010E);break;	//D caron
	
	case 0xE0:pMathType=mo;pmt(0x0155);break;	//r acute
	case 0xE1:pMathType=mo;pmt(*temp);break;	//a acute
	case 0xE2:pMathType=mo;pmt(*temp);break;	//a circumflex
	case 0xE3:pMathType=mo;pmt(0x0103);break;	//a breve
	case 0xE4:pMathType=mo;pmt(*temp);break;	//a diaeresis
	case 0xE5:pMathType=mo;pmt(0x013A);break;	//l acute
	case 0xE6:pMathType=mo;pmt(0x0107);break;	//c acute
	case 0xE7:pMathType=mo;pmt(*temp);break;	//c cedilla
	case 0xE8:pMathType=mo;pmt(0x010D);break;	//c caron
	case 0xE9:pMathType=mo;pmt(*temp);break;	//e acute
	case 0xEA:pMathType=mo;pmt(0x0119);break;	//e ogonek
	case 0xEB:pMathType=mo;pmt(*temp);break;	//e diaeresis
	case 0xEC:pMathType=mo;pmt(0x011B);break;	//e caron
	case 0xED:	//i acute
	case 0xEE:pMathType=mo;pmt(*temp);break;	//i circumflex
	case 0xEF:pMathType=mo;pmt(0x010F);break;	//d caron
	
	case 0xF0:pMathType=mo;pmt(0x00D0);break;	//eth
	case 0xF1:pMathType=mo;pmt(0x0144);break;	//n acute
	case 0xF2:pMathType=mo;pmt(0x0148);break;	//n caron
	case 0xF3://o acute
	case 0xF4:pMathType=mo;pmt(*temp);break;	//o circumflex
	case 0xF5:pMathType=mo;pmt(0x0151);break;	//o double acute
	case 0xF6:pMathType=mo;pmt(*temp);break;	//o diaeresis
	case 0xF7:pMathType=mo;pmt(*temp);break;	//divide
	case 0xF8:pMathType=mo;pmt(0x0159);break;	//r caron
	case 0xF9:pMathType=mo;pmt(0x016F);break;	//u ring above
	case 0xFA:pMathType=mo;pmt(*temp);break;	//u acute
	case 0xFB:pMathType=mo;pmt(0x0171);break;	//u double acute
	case 0xFC:	//u diaeresis
	case 0xFD:pMathType=mo;pmt(*temp);break;	//y acute
	case 0xFE:pMathType=mo;pmt(0x201E);break;	//double low quot-mark
	case 0xFF:pMathType=mo;pmt(0x201C);break;	//left double quotation mark
	
	default:pMathType=mo;pmt(*temp);
	}
	temp++;
}while(*temp);
return;
}


void fontMap8u(){//OT1+ ISO Latin2, typewriter 
//cmtt, cmcsc, cmsltt, cmtcsc, cmtl, cmsltl, cccsc
//cmitt (pound for dollar)
//px[sc,bsc], rpx[bsl,bsc,i,r,sc,sl], rtx[b,bi,bsc,bsssc]
//tx[tt,ttsc,ttsl,sc,sssc,btt,bttsc,bsc,bsssc]
//pcrr7n
//cmitt 

unsigned char* temp=(unsigned char*)yytext; 

do{
	switch(*temp){
	case 0x00:pMathType=mo;pmt(0x0393);break;	//Gamma
	case 0x01:pMathType=mo;pmt(0x0394);break;	//Delta
	case 0x02:pMathType=mo;pmt(0x0398);break;	//Theta
	case 0x03:pMathType=mo;pmt(0x039B);break;	//Lambda
	case 0x04:pMathType=mo;pmt(0x039E);break;	//Xi
	case 0x05:pMathType=mo;pmt(0x03A0);break;	//Pi
	case 0x06:pMathType=mo;pmt(0x03A3);break;	//Sigma
	case 0x07:pMathType=mo;pmt(0x03D2);break;	//Upsilon with hook
	case 0x08:pMathType=mo;pmt(0x03A6);break;	//Phi
	case 0x09:pMathType=mo;pmt(0x03A8);break;	//Psi
	case 0x0A:pMathType=mo;pmt(0x03A9);break;	//Omega
	case 0x0B:pMathType=mo;pmt(0x2191);break;	//up arrow
	case 0x0C:pMathType=mo;pmt(0x2193);break;	//down arrow
	case 0x0D:pMathType=mo;pmt(0x2032);break;	//prime
	case 0x0E:pMathType=mo;pmt(0x00A1);break;	//inverted exclamation mark
	case 0x0F:pMathType=mo;pmt(0x00BF);break;	//inverted question mark

	case 0x10:pMathType=mo;pmt(0x026A);break;	//latin i small capital
	case 0x11:pMathType=mo;pmt(0x006A);break;	//j (ascii)
	case 0x12:pMathType=mo;pmt(0x0060);break;	//grave accent
	case 0x13:pMathType=mo;pmt(0x00B4);break;	//acute accent
	case 0x14:pMathType=mo;pmt(0x02C7);break;	//caron, hacek
	case 0x15:pMathType=mo;pmt(0x02D8);break;	//breve
	case 0x16:pMathType=mo;pmt(0x00AF);break;	//macron
	case 0x17:pMathType=mo;pmt(0x02DA);break;	//ring above
	case 0x18:pMathType=mo;pmt(0x00B8);break;	//cedilla
	case 0x19:pMathType=mo;pmt(0x00DF);break;	//german SS (XXX)
	case 0x1A:pMathType=mo;pmt(0x00E6);break;	//ae
	case 0x1B:pMathType=mo;pmt(0x0153);break;	//oe
	case 0x1C:pMathType=mo;pmt(0x00F8);break;	//o slash
	case 0x1D:pMathType=mo;pmt(0x00C6);break;	//AE
	case 0x1E:pMathType=mo;pmt(0x0152);break;	//OE
	case 0x1F:pMathType=mo;pmt(0x00D8);break;	//O slash

	case 0x20:break;	//notdef
	case 0x21:pMathType=mo;pmt(*temp);break;	//exclamation mark
	case 0x22:pMathType=mo;pmt(0x201D);break;	//right double quotation mark
	case 0x23:
	case 0x24:
	case 0x25:pMathType=mo;pmt(*temp);break;
	case 0x26:
		if (mathmode && !mathText)
			p("<mo>&amp;</mo>");
		else 
			p("&amp;");
		break;//ampersand
	case 0x27:pMathType=mo;pmt(*temp);break;	//right single quot-mark
	case 0x28:pMathType=mo;pmt(*temp);break;	//left parenthesis
	case 0x29:pMathType=mo;pmt(*temp);break;	//right parenthesis
	case 0x2A:
	case 0x2B:
	case 0x2C:inhibitspace=0;pMathType=mo;pmt(*temp);break;
	case 0x2D:
	case 0x2E:
	case 0x2F:pMathType=mo;pmt(*temp);break;

	case 0x30:
	case 0x31:
	case 0x32:
	case 0x33:
	case 0x34:
	case 0x35:
	case 0x36:
	case 0x37:
	case 0x38:
	case 0x39:pMathType=mn;pmt(*temp);break;	//numbers 0-9
	case 0x3A:pMathType=mo;pmt(*temp);break;	//colon
	case 0x3B:pMathType=mo;pmt(*temp);break;	//semicolon
		
	case 0x3C://less than
		if(combiningUnicode==0x0338) { 
			combiningUnicode=0;
			pmt(0x226F);
		}	else	{
			if (mathmode && !mathText)
				p("<mo>&lt;</mo>");
			else 
				p("&lt;");
		}
		break;
	case 0x3D: //equal
		pMathType=mo;
		precomposedNegative(*temp, 0x2260);
		break;
	case 0x3E: //greater than
		if(combiningUnicode==0x0338) { 
			combiningUnicode=0;
			pmt(0x226F);
		}	else{
			if (mathmode && !mathText)
				p("<mo>&gt;</mo>");
			else 
				p("&gt;");
		}
		break;
	case 0x3F:pMathType=mo;pmt(*temp);break;	//question mark
	case 0x40:pMathType=mo;pmt(*temp);break;	//at sign

	//A to Z go to default: mo
	
	case 0x5B:pMathType=mo;pmt(*temp);break;	//[
	case 0x5C:pMathType=mo;pmt(0x201C);break;	//left double quotation mark
	case 0x5D:pMathType=mo;pmt(*temp);break;	//]
	case 0x5E:pMathType=mo;pmt(*temp);break;	//circumflex
	case 0x5F:pMathType=mo;pmt(0x02D9);break;	//dot above

	case 0x60:pMathType=mo;pmt(*temp);break;	//left single quotation mark
	
	//a to z go to default: mo
	
	case 0x7B:pMathType=mo;pmt(0x2013);break;	//en dash
	case 0x7C:pMathType=mo;pmt(0x2014);break;	//em dash
	case 0x7D:pMathType=mo;pmt(0x02DD);break;	//double acute accent
	case 0x7E:pMathType=mo;pmt(*temp);break;	//tilde
	case 0x7F:pMathType=mo;pmt(0x00A8);break;	//diaeresis

	case 0x80:pMathType=mo;pmt(0x2026);break;	//horizontal ellipsis	
	case 0x81:pMathType=mo;pmt(0x2020);break;	//dagger
	case 0x82:pMathType=mo;pmt(0x2021);break;	//ddagger
	case 0x83:pMathType=mo;pmt(0x2022);break;	//bullet
	case 0x84:pMathType=mo;pmt(0x00A3);break;	//pound sterling
	case 0x85:pMathType=mo;pmt(*temp);break;	//paragraph
	case 0x86:
	case 0x87:
	case 0x88:
	case 0x89:
	case 0x8A:
	case 0x8B:
	case 0x8C:break;	//notdef
	case 0x8D:pMathType=mo;pmt(0x2030);break; //per mille
	case 0x8E:
	case 0x8F:
	
	case 0x90:
	case 0x91:
	case 0x92:
	case 0x93:
	case 0x94:
	case 0x95:
	case 0x96:
	case 0x97:break;	//notdef
	case 0x98:pMathType=mo;pmt(0x00C0);break; //A grave
	case 0x99:
	case 0x9A:
	case 0x9B:break;	//notdef
	case 0x9C:pMathType=mo;pmt(0x002D);break; //hyphen
	case 0x9D:pMathType=mo;pmt(0x02DB);break;	//ogonek	
	case 0x9E:pMathType=mo;pmt(0x00AB);break;	//guillemet left 	
	case 0x9F:pMathType=mo;pmt(0x00BB);break;	//guillemet right 
	
	case 0xA0:break;	//notdef
	case 0xA1:pMathType=mo;pmt(0x0104);break;	//A ogonek
	case 0xA2:pMathType=mo;pmt(0x02D8);break;	//breve
	case 0xA3:pMathType=mo;pmt(0x0141);break;	//L stroke	
	case 0xA4:pMathType=mo;pmt(*temp);break;	//currency sign
	case 0xA5:pMathType=mo;pmt(0x013D);break;	//L caron
	case 0xA6:pMathType=mo;pmt(0x015A);break;	//S acute	
	case 0xA7:	//section	
	case 0xA8:pMathType=mo;pmt(*temp);break;	//diaeresis	
	case 0xA9:pMathType=mo;pmt(0x0160);break;	//S caron	
	case 0xAA:pMathType=mo;pmt(0x015E);break;	//S cedilla	
	case 0xAB:pMathType=mo;pmt(0x0164);break;	//T caron	
	case 0xAC:pMathType=mo;pmt(0x0179);break;	//Z acute
	case 0xAD:break;	//notdef
	case 0xAE:pMathType=mo;pmt(0x017D);break;	//Z caron
	case 0xAF:pMathType=mo;pmt(0x017B);break;	//Z dot above
	
	case 0xB0:pMathType=mo;pmt(0x02DA);break;	//ring above
	case 0xB1:pMathType=mo;pmt(0x0104);break;	//a ogonek
	case 0xB2:pMathType=mo;pmt(0x00B8);break;	//cedilla
	case 0xB3:pMathType=mo;pmt(0x0142);break;	//l stroke
	case 0xB4:pMathType=mo;pmt(0x00B4);break;	//acute accent
	case 0xB5:pMathType=mo;pmt(0x013E);break;	//l caron
	case 0xB6:pMathType=mo;pmt(0x015B);break;	//s acute
	case 0xB7:pMathType=mo;pmt(0x02C7);break;	//caron, hacek
	case 0xB8:pMathType=mo;pmt(0x00E0);break;	//a grave
	case 0xB9:pMathType=mo;pmt(0x0161);break;	//s caron
	case 0xBA:pMathType=mo;pmt(0x015F);break;	//s cedilla
	case 0xBB:pMathType=mo;pmt(0x0165);break;	//t caron
	case 0xBC:pMathType=mo;pmt(0x017A);break;	//z acute
	case 0xBD:pMathType=mo;pmt(0x02DD);break;	//double acute accent, 0x30B combining
	case 0xBE:pMathType=mo;pmt(0x017E);break;	//z caron
	case 0xBF:pMathType=mo;pmt(0x02DD);break;	//double acute accent, 0x30B combining
	
	case 0xC0:pMathType=mo;pmt(0x0154);break;//R acute
	case 0xC1:	//A acute
	case 0xC2:pMathType=mo;pmt(*temp);break;	//A circumflex
	case 0xC3:pMathType=mo;pmt(0x0102);break;	//A breve
	case 0xC4:pMathType=mo;pmt(*temp);break;	//A diaeresis
	case 0xC5:pMathType=mo;pmt(0x0139);break;	//L acute
	case 0xC6:pMathType=mo;pmt(0x0106);break;	//C acute
	case 0xC7:pMathType=mo;pmt(*temp);break;	//C cedilla
	case 0xC8:pMathType=mo;pmt(0x00C0);break; //A grave
	case 0xC9:pMathType=mo;pmt(0x010C);break;	//C caron
	case 0xCA:pMathType=mo;pmt(0x00C9);break;	//E acute
	case 0xCB:pMathType=mo;pmt(0x0118);break;	//E ogonek
	case 0xCC:pMathType=mo;pmt(0x00CB);break; //E diaeresis
	case 0xCD:pMathType=mo;pmt(0x011A);break;	//E caron
	case 0xCE:pMathType=mo;pmt(0x00CD);break;	//I acute
	case 0xCF:pMathType=mo;pmt(0x010E);break;	//D caron
	
	case 0xD0:pMathType=mo;pmt(*temp);break;	//Eth
	case 0xD1:pMathType=mo;pmt(0x0143);break;	//N acute
	case 0xD2:pMathType=mo;pmt(0x0147);break;	//N caron
	case 0xD3:pMathType=mo;pmt(*temp);break;	//O acute
	case 0xD4:pMathType=mo;pmt(*temp);break;	//O circumflex
	case 0xD5:pMathType=mo;pmt(0x0150);break;	//O double acute
	case 0xD6:pMathType=mo;pmt(*temp);break;	//O diaeresis
	case 0xD7:pMathType=mo;pmt(0x00D7);break;	//multiply 
	case 0xD8:pMathType=mo;pmt(0x0158);break;	//R caron
	case 0xD9:pMathType=mo;pmt(0x016E);break;	//U ring above
	case 0xDA:pMathType=mo;pmt(*temp);break;	//U acute
	case 0xDB:pMathType=mo;pmt(0x0170);break;	//U double acute
	case 0xDC: //U diaeresis
	case 0xDD:pMathType=mo;pmt(*temp);break;	//Y acute
	case 0xDE:pMathType=mi;p("T");p(ul2utf8(0x0328)); break;//T ogonek
	case 0xDF:pMathType=mo;pmt(0x010E);break;	//D caron
	
	case 0xE0:pMathType=mo;pmt(0x0155);break;	//r acute
	case 0xE1:pMathType=mo;pmt(*temp);break;	//a acute
	case 0xE2:pMathType=mo;pmt(*temp);break;	//a circumflex
	case 0xE3:pMathType=mo;pmt(0x0103);break;	//a breve
	case 0xE4:pMathType=mo;pmt(*temp);break;	//a diaeresis
	case 0xE5:pMathType=mo;pmt(0x013A);break;	//l acute
	case 0xE6:pMathType=mo;pmt(0x0107);break;	//c acute
	case 0xE7:pMathType=mo;pmt(*temp);break;	//c cedilla
	case 0xE8:pMathType=mo;pmt(0x010D);break;	//c caron
	case 0xE9:pMathType=mo;pmt(*temp);break;	//e acute
	case 0xEA:pMathType=mo;pmt(0x0119);break;	//e ogonek
	case 0xEB:pMathType=mo;pmt(*temp);break;	//e diaeresis
	case 0xEC:pMathType=mo;pmt(0x011B);break;	//e caron
	case 0xED:	//i acute
	case 0xEE:pMathType=mo;pmt(*temp);break;	//i circumflex
	case 0xEF:pMathType=mo;pmt(0x010F);break;	//d caron
	
	case 0xF0:pMathType=mo;pmt(0x00D0);break;	//eth
	case 0xF1:pMathType=mo;pmt(0x0144);break;//n acute
	case 0xF2:pMathType=mo;pmt(0x0148);break;//n caron
	case 0xF3://o acute
	case 0xF4:pMathType=mo;pmt(*temp);break;	//o circumflex
	case 0xF5:pMathType=mo;pmt(0x0151);break;	//o double acute
	case 0xF6:pMathType=mo;pmt(*temp);break;	//o diaeresis
	case 0xF7:pMathType=mo;pmt(*temp);break;	//divide
	case 0xF8:pMathType=mo;pmt(0x0159);break;	//r caron
	case 0xF9:pMathType=mo;pmt(0x016F);break;	//u ring above
	case 0xFA:pMathType=mo;pmt(*temp);break;	//u acute
	case 0xFB:pMathType=mo;pmt(0x0171);break;	//u double acute
	case 0xFC:	//u diaeresis
	case 0xFD:pMathType=mo;pmt(*temp);break;	//y acute
	case 0xFE:pMathType=mo;pmt(0x201E);break;	//double low quot-mark
	case 0xFF:pMathType=mo;pmt(0x201C);break;//left double quotation mark
	
	default:pMathType=mo;pmt(*temp);
	}
	temp++;
}while(*temp);
return;
}

void fontMapMathExt(){
//cmex, px[b]ex, xccex, zeuex, tx[b]ex
	
unsigned char* temp=(unsigned char*)yytext;
do{
	switch(*temp){
	case 0x00:pMathType=mo;pmt(0x0028);break;	//left parenthesis
	case 0x01:pMathType=mo;pmt(0x0029);break;	//right parenthesis
	case 0x02:pMathType=mo;pmt(0x005B);break;	//left bracket
	case 0x03:pMathType=mo;pmt(0x005D);break;	//right bracket
	case 0x04:pMathType=mo;pmt(0x230A);break;	//left floor
	case 0x05:pMathType=mo;pmt(0x230B);break;	//right floor
	case 0x06:pMathType=mo;pmt(0x2308);break;	//left ceil
	case 0x07:pMathType=mo;pmt(0x2309);break;	//right ceil
	case 0x08:pMathType=mo;pmt(0x007b);break;	//left brace
	case 0x09:pMathType=mo;pmt(0x007d);break;	//right brace
	case 0x0A:pMathType=mo;pmt(0x2329);break;	//left angle
	case 0x0B:pMathType=mo;pmt(0x232A);break;	//right angle
	case 0x0C:pMathType=mo;pmt(0x007C);blockthis=0x007c;break;//vertical line
	case 0x0D:pMathType=mo;pmt(0x2016);blockthis=0x2016;break;//double vertical line
	case 0x0E:pMathType=mo;pmt(0x007C);break;	//division
	case 0x0F:pMathType=mo;pmt(0x2216);break;	//set minus

	case 0x10:pMathType=mo;pmt(0x0028);break;	//left parenthesis
	case 0x11:pMathType=mo;pmt(0x0029);break;	//right parenthesis
	case 0x12:pMathType=mo;pmt(0x0028);break;	//left parenthesis
	case 0x13:pMathType=mo;pmt(0x0029);break;	//right parenthesis
	case 0x14:pMathType=mo;pmt(0x005B);break;	//left bracket
	case 0x15:pMathType=mo;pmt(0x005D);break;	//right bracket
	case 0x16:pMathType=mo;pmt(0x230A);break;	//left floor
	case 0x17:pMathType=mo;pmt(0x230B);break;	//right floor
	case 0x18:pMathType=mo;pmt(0x2308);break;	//left ceil
	case 0x19:pMathType=mo;pmt(0x2309);break;	//right ceil
	case 0x1A:pMathType=mo;pmt(0x007B);break;	//left brace
	case 0x1B:pMathType=mo;pmt(0x007D);break;	//right brace
	case 0x1C:pMathType=mo;pmt(0x2329);break;	//left angle
	case 0x1D:pMathType=mo;pmt(0x232A);break;	//right angle
	case 0x1E:pMathType=mo;pmt(0x007C);break;	//division
	case 0x1F:pMathType=mo;pmt(0x2216);break;	//set minus

	case 0x20:pMathType=mo;pmt(0x0028);break;	//left parenthesis
	case 0x21:pMathType=mo;pmt(0x0029);break;	//right parenthesis
	case 0x22:pMathType=mo;pmt(0x005B);break;	//left bracket
	case 0x23:pMathType=mo;pmt(0x005D);break;	//right bracket
	case 0x24:pMathType=mo;pmt(0x230A);break;	//left floor
	case 0x25:pMathType=mo;pmt(0x230B);break;	//right floor
	case 0x26:pMathType=mo;pmt(0x2308);break;	//left ceil
	case 0x27:pMathType=mo;pmt(0x2309);break;	//right ceil
	case 0x28:pMathType=mo;pmt(0x007B);break;	//left curly bracket
	case 0x29:pMathType=mo;pmt(0x007D);break;	//right curly bracket
	case 0x2A:pMathType=mo;pmt(0x2329);break;	//left angle bracket
	case 0x2B:pMathType=mo;pmt(0x232A);break;	//right angle bracket
	case 0x2C:pMathType=mo;pmt(0x007C);break;	//division
	case 0x2D:pMathType=mo;pmt(0x2216);break;	//set minus
	case 0x2E:pMathType=mo;pmt(0x2215);break;	//division
	case 0x2F:pMathType=mo;pmt(0x2216);break;	//set minus

	case 0x30:pMathType=mo;pmt(0x0028);break;//pMathType=ld_b;pmt(0x239B);break;//left parenthesis top
	case 0x31:pMathType=mo;pmt(0x0029);break;//pMathType=rd_b;pmt(0x239E);break;//right parenthesis top
	case 0x32:pMathType=mo;pmt(0x005B);break;//pMathType=ld_b;pmt(0x23A1);break;//left bracket upper corner
	case 0x33:pMathType=mo;pmt(0x005D);break;//pMathType=rd_b;pmt(0x23A4);break;//right bracket upper corner
	case 0x34:break;//pMathType=ld_e;pmt(0x23A3);break;//left bracket lower corner
	case 0x35:break;//pMathType=rd_e;pmt(0x23A6);break;//right bracket lower corner
	case 0x36:break;//pMathType=ld_x;pmt(0x23A2);break;//left bracket extension
	case 0x37:break;//pMathType=rd_x;pmt(0x23A5);break;//right bracket extension
	case 0x38:pMathType=mo;pmt(0x007B);break;//pMathType=ld_b;pmt(0x23A7);break;//left curly bracket top
	case 0x39:pMathType=mo;pmt(0x007D);break;//pMathType=rd_b;pmt(0x23AB);break;//right curly bracket top
	case 0x3A:break;//pMathType=ld_e;pmt(0x23A9);break;//left curly bracket bottom
	case 0x3B:break;//pMathType=rd_e;pmt(0x23AD);break;//right curly bracket bottom
	case 0x3C:break;//pMathType=ld_x;pmt(0x23A8);break;//left curly bracket middle piece
	case 0x3D:break;//pMathType=rd_x;pmt(0x23AC);break;//right curly bracket middle piece
	case 0x3E:break;//pMathType=ld_x;pmt(0x23AA);break;//curly bracket extension
	case 0x3F:break;//pMathType=mo;pmt(0x23D0);break;//vertical arrow extension

	case 0x40:break;//pMathType=ld_e;pmt(0x239D);break;//left parenthesis bottom
	case 0x41:break;//pMathType=rd_e;pmt(0x23A0);break;//right parenthesis bottom
	case 0x42:break;//pMathType=ld_x;pmt(0x239C);break;//left parenthesis extension
	case 0x43:break;//pMathType=rd_x;pmt(0x239F);break;//right parenthesis extension
	case 0x44:pMathType=mo;pmt(0x2329);break;	//left angle bracket
	case 0x45:pMathType=mo;pmt(0x232A);break;	//right angle bracket
	case 0x46:pMathType=mo;pmt(0x2294);break;	//square cup
	case 0x47:pMathType=mo;pmt(0x2294);break;	//square cup
	case 0x48:pMathType=mo;pmt(0x222E);break;	//textstyle contour integral
	case 0x49:pMathType=mo;pmt(0x222E);break;	//displaystyle contour integral
	case 0x4A:pMathType=mo;pmt(0x2299);break;	//circled dot operator
	case 0x4B:pMathType=mo;pmt(0x2A00);break;	//n-ary circled dot operator
	case 0x4C:pMathType=mo;pmt(0x2295);break;	//circled plus
	case 0x4D:pMathType=mo;pmt(0x2295);break;	//circled plus//pmt(0x2A01);break;//n-ary circled plus, XXX not yet available in fonts
	case 0x4E:pMathType=mo;pmt(0x2297);break;	//circled times
	case 0x4F:pMathType=mo;pmt(0x2297);break;	//circled times//pmt(0x2A02);break;//n-ary circled times, XXX not yet available in fonts

	case 0x50:pMathType=mo;pmt(0x2211);break;	//n-ary summation
	case 0x51:pMathType=mo;pmt(0x220F);break;	//n-ary product
	case 0x52:pMathType=mo;pmt(0x222B);break;	//integral sign
	case 0x53:pMathType=mo;pmt(0x222A);break;	//cup
	case 0x54:pMathType=mo;pmt(0x2229);break;	//cap
	case 0x55:pMathType=mo;pmt(0x228E);break;	//multiset union
	case 0x56:pMathType=mo;pmt(0x2227);break;	//logical and
	case 0x57:pMathType=mo;pmt(0x2228);break;	//logical or
	case 0x58:pMathType=mo;pmt(0x2211);break;	//n-ary sigma
	case 0x59:pMathType=mo;pmt(0x220F);break;	//n-ary product
	case 0x5A:pMathType=mo;pmt(0x222B);break;	//integral sign
	case 0x5B:pMathType=mo;pmt(0x22C3);break;	//n-ary cap
	case 0x5C:pMathType=mo;pmt(0x22C2);break;	//n-ary cup
	case 0x5D:pMathType=mo;pmt(0x2A04);break;	//n-ary multiset union
	case 0x5E:pMathType=mo;pmt(0x22C0);break;	//n-ary logical and
	case 0x5F:pMathType=mo;pmt(0x22C1);break;	//n-ary logical or

	case 0x60:pMathType=mo;pmt(0x220F);break;	//n-ary coproduct
	case 0x61:pMathType=mo;pmt(0x220F);break;	//n-ary coproduct
	case 0x62:pMathType=mo;pmt(0x005E);break;	//hat
	case 0x63:pMathType=mo;pmt(0x005E);break;	//hat
	case 0x64:pMathType=mo;pmt(0x005E);break;	//hat
	case 0x65:pMathType=mo;pmt(0x007E);break;	//tilde
	case 0x66:pMathType=mo;pmt(0x22CF);break;	//tilde
	case 0x67:pMathType=mo;pmt(0x22CE);break;	//tilde
	case 0x68:pMathType=mo;pmt(0x005B);break;	//left bracket
	case 0x69:pMathType=mo;pmt(0x005D);break;	//right bracket
	case 0x6A:pMathType=mo;pmt(0x230A);break;	//left floor
	case 0x6B:pMathType=mo;pmt(0x230B);break;	//right floor
	case 0x6C:pMathType=mo;pmt(0x2308);break;	//left ceil
	case 0x6D:pMathType=mo;pmt(0x2309);break;	//right ceil
	case 0x6E:pMathType=mo;pmt(0x007B);break;	//left curly bracket
	case 0x6F:pMathType=mo;pmt(0x007D);break;	//right curly bracket

	case 0x70:pMathType=mo;pmt(0x221A);break;	//radical sign
	case 0x71:pMathType=mo;pmt(0x221A);break;	//radical sign
	case 0x72:pMathType=mo;pmt(0x221A);break;	//radical sign
	case 0x73:pMathType=mo;pmt(0x221A);break;	//radical sign
	case 0x74:pMathType=mo;pmt(0x221A);break;	//radical sign extensible XXX
	case 0x75:break;	//radical sign extension	XXX
	case 0x76:break;	//radical sign top	XXX
	case 0x77:break;	//double vertical line extension  XXX
	case 0x78:break;	//tip vertical arrow upwards	XXXXX
	case 0x79:break;	//tip vertical arrow downwards	XXXXXX
	case 0x7A:break;	//horizontal curly bracket tip down-left,	handled in grammar at overbrace
	case 0x7B:break;	//horizontal curly bracket tip down-right,	same here
	case 0x7C:break;	//horizontal curly bracket tip up-left, handled in grammar at underbrace
	case 0x7D:break;	//horizontal curly bracket tip up-right,	same here
	case 0x7E:break;	//tip vertical double arrow upwards		XXX
	case 0x7F:break;	//tip vertical double arrow downwards XXX

	default:pMathType=mo;pmt(*temp);
	}
	temp++;
}while(*temp) ;
return;
}

void fontMapMathExtA(){
//pxexa, txexa"
	unsigned char* temp=(unsigned char*)yytext;

do{
	switch(*temp){
	case 0x00:
	case 0x01:
	case 0x02:
	case 0x03:
	case 0x04:
	case 0x05:pMathType=mo;pmt(0x2639);break;	//XXX not found in Unicode 4.1,
	case 0x06:	
	case 0x07:pMathType=mo;pmt(0x2293);break;	//square cap
	case 0x08:
	case 0x09:pMathType=mo;pmt(0x222F);break;	//surface integral
	case 0x0A:
	case 0x0B:pMathType=mo;pmt(0x2233);break;	//anti-clockwise contour integral
	case 0x0C:
	case 0x0D:pMathType=mo;pmt(0x2232);break;	//clockwise contour integral
	case 0x0E:
	case 0x0F:pMathType=mo;pmt(0x2A16);break;	//quaternion integral operator

	case 0x10:
	case 0x11:pMathType=mo;pmt(0x00D7);break;	//multiplication sign
	case 0x12:pMathType=mo;pmt(0x27E6);break;	//math left white square bracket
	case 0x13:pMathType=mo;pmt(0x27E7);break;	//math right white square bracket
	case 0x14:pMathType=mo;pmt(0x27E6);break;	//math left white square bracket
	case 0x15:pMathType=mo;pmt(0x27E7);break;	//math right white square bracket
	case 0x16:pMathType=mo;pmt(0x27E6);break;	//math left white square bracket
	case 0x17:pMathType=mo;pmt(0x27E7);break;	//math right white square bracket
	case 0x18:pMathType=mo;pmt(0x27E6);break;	//math left white square bracket
	case 0x19:pMathType=mo;pmt(0x27E7);break;	//math right white square bracket
	case 0x1A:pMathType=mo;pmt(0x27E6);break;	//math left white square bracket
	case 0x1B:pMathType=mo;pmt(0x27E7);break;	//math right white square bracket
	case 0x1C:break;//ignore, left bracket bottom
	case 0x1D:break;//ignore, right bracket bottom
	case 0x1E:break;//ignore, left bracket extension
	case 0x1F:break;//ignore, right bracket extension

	case 0x20:break;//should be horizontal brace extension
	case 0x21:
	case 0x22:pMathType=mo;pmt(0x222C);break;	//double integral
	case 0x23:
	case 0x24:pMathType=mo;pmt(0x222D);break;	//triple integral
	case 0x25:
	case 0x26:pMathType=mo;pmt(0x2A0C);break;	//quad integral
	case 0x27:
	case 0x28:p("<mo>");p(ul2utf8(0x222B));p(ul2utf8(0x2026));p(ul2utf8(0x222B));p("</mo>");break;//integral dots integral
	case 0x29:
	case 0x2A:pMathType=mo;pmt(0x2230);break;	//volume integral
	case 0x2B:
	case 0x2C:pMathType=mo;pmt(0x2233);break;	//anti-clockwise contour integral
	case 0x2D:
	case 0x2E:pMathType=mo;pmt(0x2232);break;	//clockwise contour integral
	case 0x2F:break;//nothing here

	case 0x30:pMathType=mo;pmt(0x27C5);break;	//left s-bag
	case 0x31:pMathType=mo;pmt(0x27C6);break;	//right s-bag
	case 0x32:pMathType=mo;pmt(0x27C5);break;	//left s-bag
	case 0x33:pMathType=mo;pmt(0x27C6);break;	//right s-bag
	case 0x34:pMathType=mo;pmt(0x27C5);break;	//left s-bag
	case 0x35:pMathType=mo;pmt(0x27C6);break;	//right s-bag
	case 0x36:pMathType=mo;pmt(0x27C5);break;	//left s-bag
	case 0x37:pMathType=mo;pmt(0x27C6);break;	//right s-bag
	case 0x38:pMathType=mo;pmt(0x27C5);break;	//left s-bag
	case 0x39:pMathType=mo;pmt(0x27C6);break;	//right s-bag
	case 0x3A:pMathType=mo;pmt(0x27C5);break;	//left s-bag
	case 0x3B:pMathType=mo;pmt(0x27C6);break;	//right s-bag
	case 0x3C:pMathType=mo;pmt(0x27C5);break;	//left s-bag
	case 0x3D:pMathType=mo;pmt(0x27C6);break;	//right s-bag
	case 0x3E:
	case 0x3F:pMathType=mo;pmt(0x2A0F);break;	//integral avergae with slash

	case 0x40://XXX should be anti-clockwise
	case 0x41://XXX should be anti-clockwise
	case 0x42://XXX should be clockwise
	case 0x43:pMathType=mo;pmt(0x222F);break;	//surface integral, XXX should be clockwise
	case 0x44:
	case 0x45:
	case 0x46:
	case 0x47:pMathType=mo;pmt(0x2230);break;	//volume integral, XXX should be oriented
	case 0x48:
	case 0x49:
	case 0x4A:
	case 0x4B:pMathType=mo;pmt(0x222F);break;	//surface integral, XXX should be variations of 0x40-0x43
	case 0x4C:
	case 0x4D:
	case 0x4E:
	case 0x4F:pMathType=mo;pmt(0x2230);break;	//volume integral, XXX should be variations of 0x44-0x47

	case 0x50:
	case 0x51:
	case 0x52:
	case 0x53:pMathType=mo;pmt(0x222F);break;	//surface integral, XXX should be quaternion and oriented
	case 0x54:
	case 0x55:
	case 0x56:
	case 0x57:
	case 0x58:
	case 0x59:
	case 0x5A:
	case 0x5B:
	case 0x5C:
	case 0x5D:
	case 0x5E:
	case 0x5F:break;
	
	//nothing else in the TeX pxexa font;
	}
	temp++;
}while(*temp) ;
return;
}

void fontMapMathSymbol(){
//cmsy, cmbrsy, xccsy
//zeusm, zeusb (+11 glyphs);
//euxm (+-)
//zplmb7y, zplmr7y
//px[b]sy
//tx[b]sy
int staticStyle;

unsigned char* temp=(unsigned char*)yytext;
do{
	switch(*temp){
	case 0x00:pMathType=mo;pmt(0x2212);break;	//minus
	case 0x01:pMathType=mo;pmt(0x22C5);break;	//dot operator
	case 0x02:pMathType=mo;pmt(0x00D7);break;	//times
	case 0x03:pMathType=mo;pmt(0x002a);break;	//asterisk
	case 0x04:pMathType=mo;pmt(0x00F7);break;	//div
	case 0x05:pMathType=mo;pmt(0x22C4);break;	//diamond
	case 0x06:pMathType=mo;pmt(0x00B1);break;	//plus-minus
	case 0x07:pMathType=mo;pmt(0x2213);break;	//minus-plus
	case 0x08:pMathType=mo;pmt(0x2295);break;	//oplus
	case 0x09:pMathType=mo;pmt(0x2296);break;	//ominus
	case 0x0A:pMathType=mo;pmt(0x2297);break;	//otimes
	case 0x0B:pMathType=mo;pmt(0x2298);break;	//odivision
	case 0x0C:pMathType=mo;pmt(0x2299);break;	//odot
	case 0x0D:pMathType=mo;
	if (combiningUnicode=='c')	pmt(0x01); //dirty trick to recover the copyright symbol
	else	pmt(0x25EF);
		break;//bigcirc
	case 0x0E:pMathType=mo;pmt(0x2218);break;	//empty ring
	case 0x0F:pMathType=mo;pmt(0x2219);break;	//filled ring

	case 0x10:pMathType=mo;pmt(0x224D);break;	//equivalent to
	case 0x11:pMathType=mo;//\equiv, identical to
		precomposedNegative(0x2261,0x2262);
		break;
	break;
	case 0x12:pMathType=mo; //subset equal
		precomposedNegative(0x2286,0x2288);
		break;
	case 0x13:pMathType=mo; //superset equal
		precomposedNegative(0x2287,0x2289);
		break;
	case 0x14:pMathType=mo;		//less equal
		precomposedNegative(0x2264,0x2270);
		break;
	case 0x15:pMathType=mo;		//greater equal
		precomposedNegative(0x2265,0x2271);
		break;
	case 0x16:pMathType=mo;	//precedes equal
		precomposedNegative(0x227C,0x22E0);
		break;
	case 0x17:pMathType=mo;	//succeedes equal
		precomposedNegative(0x227D,0x22E1);
		break;
	case 0x18:pMathType=mo;//similar
		precomposedNegative(0x223C,0x2241);
		break;
	case 0x19:pMathType=mo;	//almost equal
		precomposedNegative(0x2248,0x2249);
		break;
	case 0x1A:pMathType=mo; //subset
		precomposedNegative(0x2282,0x2284);
		break;
	case 0x1B:pMathType=mo; //superset
		precomposedNegative(0x2283,0x2285);
		break;
	case 0x1C:pMathType=mo;pmt(0x226A);break;	//much less
	case 0x1D:pMathType=mo;pmt(0x226B);break;	//much greater
	case 0x1E:pMathType=mo;							//precedes
		precomposedNegative(0x227A,0x2280);
		break;
	case 0x1F:pMathType=mo;							//succeedes
		precomposedNegative(0x227B,0x2281);
		break;
	case 0x20:pMathType=mo;pmt(0x2190);break;	//leftarrow
	case 0x21:pMathType=mo;pmt(0x2192);break;	//rightarrow
	case 0x22:pMathType=mo;pmt(0x2191);break;	//uparrow
	case 0x23:pMathType=mo;pmt(0x2193);break;	//downarrow
	case 0x24:pMathType=mo;pmt(0x2194);break;	//leftrightarrow
	case 0x25:pMathType=mo;pmt(0x2197);break;	//nearrow
	case 0x26:pMathType=mo;pmt(0x2198);break;	//searrow
	case 0x27:pMathType=mo;	//asympequal
		precomposedNegative(0x2243, 0x2244);
		break;			
	case 0x28:pMathType=mo;pmt(0x21D0);break;	//left double arrow
	case 0x29:pMathType=mo;pmt(0x21D2);break;	//right double arrow
	case 0x2A:pMathType=mo;pmt(0x21D1);break;	//up double arrow
	case 0x2B:pMathType=mo;pmt(0x21D3);break;	//down double arrow
	case 0x2C:pMathType=mo;pmt(0x21D4);break;	//leftright double arrow
	case 0x2D:pMathType=mo;pmt(0x2196);break;	//nwarrow
	case 0x2E:pMathType=mo;pmt(0x2199);break;	//swarrow
	case 0x2F:pMathType=mo;pmt(0x221D);break;	//propto

	case 0x30:pMathType=mo;pmt(0x2032);break;	//prime
	case 0x31:pMathType=mo;pmt(0x221E);break;	//infinity
	case 0x32:pMathType=mo;//belongs
		precomposedNegative(0x2208,0x2209);
	break;
	case 0x33:pMathType=mo;pmt(0x220B);break;	//contains
	case 0x34:pMathType=mo;pmt(0x25B3);break;	//up triangle
	case 0x35:pMathType=mo;pmt(0x25BD);break;	//down triangle
	case 0x36:combiningUnicode=0x0338;break;	//combining slash
	case 0x37:pMathType=mo;pmt(0x22A6);break;	//assertion
	case 0x38:pMathType=mo;pmt(0x2200);break;	//forall
	case 0x39:pMathType=mo;pmt(0x2203);break;	//exists
	case 0x3A:pMathType=mo;pmt(0x00AC);break;	//not
	case 0x3B:pMathType=mo;pmt(0x2205);break;	//emptyset
	case 0x3C:pMathType=mo;pmt(0x211C);break;	//real part
	case 0x3D:pMathType=mo;pmt(0x2111);break;	//image part
	case 0x3E:pMathType=mo;pmt(0x22A4);break;	//down tack
	case 0x3F:pMathType=mo;pmt(0x22A5);break;	//up tack

	case 0x40:pMathType=mo;pmt(0x2135);break;//aleph
	case 0x41:pMathType=mi;staticStyle=theFont.family;theFont.family=cursive;pmt(*temp);theFont.family=staticStyle;break;//pMathType=mib;pmt(0x1D49C);break;//A script
	case 0x42:pMathType=mi;staticStyle=theFont.family;theFont.family=cursive;pmt(0x212C);theFont.family=staticStyle;break;//B script
	case 0x43:	//pMathType=mib;pmt(0x1D49E);break;//C script
	case 0x44:pMathType=mi;staticStyle=theFont.family;theFont.family=cursive;pmt(*temp);theFont.family=staticStyle;break;//pMathType=mib;pmt(0x1D49F);break;//D script
	case 0x45:pMathType=mi;staticStyle=theFont.family;theFont.family=cursive;pmt(0x2130);theFont.family=staticStyle;break;//E script
	case 0x46:pMathType=mi;staticStyle=theFont.family;theFont.family=cursive;pmt(0x2131);theFont.family=staticStyle;break;//F script
	case 0x47:pMathType=mi;staticStyle=theFont.family;theFont.family=cursive;pmt(*temp);theFont.family=staticStyle;break;//pMathType=mib;pmt(0x1D4A2);break;//G script
	case 0x48:pMathType=mi;staticStyle=theFont.family;theFont.family=cursive;pmt(0x210B);theFont.family=staticStyle;break;//H script
	case 0x49:pMathType=mi;staticStyle=theFont.family;theFont.family=cursive;pmt(0x2110);theFont.family=staticStyle;break;//I script
	case 0x4A:	//pMathType=mib;pmt(0x1D4A5);break;//J script
	case 0x4B:pMathType=mi;staticStyle=theFont.family;theFont.family=cursive;pmt(*temp);theFont.family=staticStyle;break;//pMathType=mib;pmt(0x1D4A6);break;//K script
	case 0x4C:pMathType=mi;staticStyle=theFont.family;theFont.family=cursive;pmt(0x2112);theFont.family=staticStyle;break;//L script
	case 0x4D:pMathType=mi;staticStyle=theFont.family;theFont.family=cursive;pmt(0x2133);theFont.family=staticStyle;break;//M script
	case 0x4E:	//pMathType=mib;pmt(0x1D4A9);break;//N script
	case 0x4F:pMathType=mi;staticStyle=theFont.family;theFont.family=cursive;pmt(*temp);theFont.family=staticStyle;break;//pMathType=mib;pmt(0x1D4AA);break;//O script

	case 0x50:	//pMathType=mi;pmt(0x1D4AB);break;//P script
	case 0x51:pMathType=mi;staticStyle=theFont.family;theFont.family=cursive;pmt(*temp);theFont.family=staticStyle;break;//pMathType=mi;pmt(0x1D4AC);break;//Q script
	case 0x52:pMathType=mi;staticStyle=theFont.family;theFont.family=cursive;pmt(0x211B);theFont.family=staticStyle;break;//R script
	case 0x53:	//pMathType=mi;pmt(0x1D4AE);break;//S script
	case 0x54:	//pMathType=mi;pmt(0x1D4AF);break;//T script
	case 0x55:	//pMathType=mi;pmt(0x1D4B0);break;//U script
	case 0x56:	//pMathType=mi;pmt(0x1D4B1);break;//V script
	case 0x57:	//pMathType=mi;pmt(0x1D4B2);break;//W script
	case 0x58:	//pMathType=mi;pmt(0x1D4B3);break;//X script
	case 0x59:	//pMathType=mi;pmt(0x1D4B4);break;//Y script
	case 0x5A:pMathType=mi;staticStyle=theFont.family;theFont.family=cursive;pmt(*temp);theFont.family=staticStyle;break;//pMathType=mi;pmt(0x1D4B5);break;//Z script
	case 0x5B:pMathType=mo;pmt(0x222A);break;	//cup
	case 0x5C:pMathType=mo;pmt(0x2229);break;	//cap
	case 0x5D:pMathType=mo;pmt(0x228E);break;	//multiset union
	case 0x5E:pMathType=mo;pmt(0x2227);break;	//logical and, wedge
	case 0x5F:pMathType=mo;pmt(0x2228);break;	//logical or, vee

	case 0x60:pMathType=mo; //right tack
		precomposedNegative(0x22A2,0x22AC);
		break;
	case 0x61:pMathType=mo;pmt(0x22A3);break;	//left tack
	case 0x62:pMathType=mo;pmt(0x230A);break;	//left floor
	case 0x63:pMathType=mo;pmt(0x230B);break;	//right floor
	case 0x64:pMathType=mo;pmt(0x2308);break;	//left ceiling
	case 0x65:pMathType=mo;pmt(0x2309);break;	//right ceiling
	case 0x66:pMathType=mo;pmt(0x007B);break;	//left brace
	case 0x67:pMathType=mo;pmt(0x007D);break;	//right brace
	case 0x68:pMathType=mo;pmt(0x2329);break;	//left angle bracket
	case 0x69:pMathType=mo;pmt(0x232A);break;	//right angle bracket
	case 0x6A:pMathType=mo;pmt(0x007C);break;	//divides, vert
	case 0x6B:pMathType=mo;pmt(0x2225);break;	//parallel
	case 0x6C:pMathType=mo;pmt(0x2195);break;	//up down arrow
	case 0x6D:pMathType=mo;pmt(0x21D5);break;	//up down double arrow
	case 0x6E:pMathType=mo;pmt(0x005C);break;	//backslash
	case 0x6F:pMathType=mo;pmt(0x2240);break;	//wreath product

	case 0x70:pMathType=mo;pmt(0x2713);break;	//square root
	case 0x71:pMathType=mo;pmt(0x2210);break;	//binary product
	case 0x72:pMathType=mo;pmt(0x2207);break;	//nabla
	case 0x73:pMathType=mo;pmt(0x2228);break;	//integral
	case 0x74:pMathType=mo;pmt(0x2294);break;	//square cup
	case 0x75:pMathType=mo;pmt(0x2293);break;	//square cap
	case 0x76:pMathType=mo;	//square image equal
		precomposedNegative(0x2291,0x22E2);
		break;
	case 0x77:pMathType=mo;	//square original equal
		precomposedNegative(0x2292,0x22E3);
		break;
	case 0x78:pMathType=mo;pmt(0x00A7);break;	//section
	case 0x79:pMathType=mo;pmt(0x2020);break;	//dagger
	case 0x7A:pMathType=mo;pmt(0x2021);break;	//ddagger
	case 0x7B:pMathType=mo;pmt(0x0086);break;	//paragraph
	case 0x7C:pMathType=mo;pmt(0x2663);break;	//black club suit
	case 0x7D:pMathType=mo;pmt(0x2662);break;	//white diamond suit
	case 0x7E:pMathType=mo;pmt(0x2661);break;	//white heart suit
	case 0x7F:pMathType=mo;pmt(0x2660);break;	//black spade suit
	}
	temp++;
}while(*temp) ;
return;
}


void fontMapMathItalic(){
//cmmi[b], cmbrmb, cmbrmi
//xccmi, ccmi
//zeurm, zeurb (+/zplmb7m3 glyphs);
//px[mi,mi1, bmi,bmi1]
//zplmb7m, zplmr7m
//rpx[bmi,mi],rtx[mi, bmi]
//tx[b]mi[1]

int staticFontFamily=theFont.family;
int staticFontStyle=theFont.style;
unsigned char* temp=(unsigned char*)yytext;

do{
	switch(*temp){
	case 0x00:pMathType=mi;theFont.style=italic;pmt(0x0393);theFont.style=staticFontStyle;break;	//Gamma
	case 0x01:pMathType=mi;theFont.style=italic;pmt(0x0394);theFont.style=staticFontStyle;break;	//Delta
	case 0x02:pMathType=mi;theFont.style=italic;pmt(0x0398);theFont.style=staticFontStyle;break;	//Theta
	case 0x03:pMathType=mi;theFont.style=italic;pmt(0x039B);theFont.style=staticFontStyle;break;	//Lambda
	case 0x04:pMathType=mi;theFont.style=italic;pmt(0x039E);theFont.style=staticFontStyle;break;	//Xi
	case 0x05:pMathType=mi;theFont.style=italic;pmt(0x03A0);theFont.style=staticFontStyle;break;	//Pi
	case 0x06:pMathType=mi;theFont.style=italic;pmt(0x03A3);theFont.style=staticFontStyle;break;	//Sigma
	case 0x07:pMathType=mi;theFont.style=italic;pmt(0x03D2);theFont.style=staticFontStyle;break;	//Upsilon with hook
	case 0x08:pMathType=mi;theFont.style=italic;pmt(0x03A6);theFont.style=staticFontStyle;break;	//Phi
	case 0x09:pMathType=mi;theFont.style=italic;pmt(0x03A8);theFont.style=staticFontStyle;break;	//Psi
	case 0x0A:pMathType=mi;theFont.style=italic;pmt(0x03A9);theFont.style=staticFontStyle;break;	//Omega
	case 0x0B:pMathType=mi;theFont.style=italic;pmt(0x03B1);theFont.style=staticFontStyle;break;	//alpha
	case 0x0C:pMathType=mi;theFont.style=italic;pmt(0x03B2);theFont.style=staticFontStyle;break;	//beta
	case 0x0D:pMathType=mi;theFont.style=italic;pmt(0x03B3);theFont.style=staticFontStyle;break;	//gamma
	case 0x0E:pMathType=mi;theFont.style=italic;pmt(0x03B4);theFont.style=staticFontStyle;break;	//delta
	case 0x0F:pMathType=mi;theFont.style=italic;pmt(0x03B5);theFont.style=staticFontStyle;break;	//epsilon

	case 0x10:pMathType=mi;theFont.style=italic;pmt(0x03B6);theFont.style=staticFontStyle;break;	//zeta
	case 0x11:pMathType=mi;theFont.style=italic;pmt(0x03B7);theFont.style=staticFontStyle;break;	//eta
	case 0x12:pMathType=mi;theFont.style=italic;pmt(0x03B8);theFont.style=staticFontStyle;break;	//theta
	case 0x13:pMathType=mi;theFont.style=italic;pmt(0x03B9);theFont.style=staticFontStyle;break;	//iota
	case 0x14:pMathType=mi;theFont.style=italic;pmt(0x03BA);theFont.style=staticFontStyle;break;	//kappa
	case 0x15:pMathType=mi;theFont.style=italic;pmt(0x03BB);theFont.style=staticFontStyle;break;	//lambda
	case 0x16:pMathType=mi;theFont.style=italic;pmt(0x03BC);theFont.style=staticFontStyle;break;	//mu
	case 0x17:pMathType=mi;theFont.style=italic;pmt(0x03BD);theFont.style=staticFontStyle;break;	//nu
	case 0x18:pMathType=mi;theFont.style=italic;pmt(0x03BE);theFont.style=staticFontStyle;break;	//xi
	case 0x19:pMathType=mi;theFont.style=italic;pmt(0x03C0);theFont.style=staticFontStyle;break;	//pi
	case 0x1A:pMathType=mi;theFont.style=italic;pmt(0x03C1);theFont.style=staticFontStyle;break;	//ro
	case 0x1B:pMathType=mi;theFont.style=italic;pmt(0x03C3);theFont.style=staticFontStyle;break;	//sigma
	case 0x1C:pMathType=mi;theFont.style=italic;pmt(0x03C4);theFont.style=staticFontStyle;break;	//tau
	case 0x1D:pMathType=mi;theFont.style=italic;pmt(0x03C5);theFont.style=staticFontStyle;break;	//upsilon
	case 0x1E:pMathType=mi;theFont.style=italic;pmt(0x03C6);theFont.style=staticFontStyle;break;	//phi
	case 0x1F:pMathType=mi;theFont.style=italic;pmt(0x03C7);theFont.style=staticFontStyle;break;	//chi

	case 0x20:pMathType=mi;theFont.style=italic;pmt(0x03C8);theFont.style=staticFontStyle;break;	//psi
	case 0x21:pMathType=mi;theFont.style=italic;pmt(0x03C9);theFont.style=staticFontStyle;break;	//omega
	case 0x22:pMathType=mi;theFont.style=italic;pmt(0x025B);theFont.style=staticFontStyle;break;	//latin epsilon
	case 0x23:pMathType=mi;theFont.style=italic;pmt(0x03D1);theFont.style=staticFontStyle;break;	//script theta
	case 0x24:pMathType=mi;theFont.style=italic;pmt(0x03D6);theFont.style=staticFontStyle;break;	//varpi
	case 0x25:pMathType=mi;theFont.style=italic;pmt(0x03F1);theFont.style=staticFontStyle;break;	//varrho
	case 0x26:pMathType=mi;theFont.style=italic;pmt(0x03C2);theFont.style=staticFontStyle;break;	//final sigma
	case 0x27:pMathType=mi;theFont.style=italic;pmt(0x03C6);theFont.style=staticFontStyle;break;	//italic phi
	case 0x28:pMathType=mo;pmt(0x21BC);break;	//left harpoon up
	case 0x29:pMathType=mo;pmt(0x21BD);break;	//left harpoon down
	case 0x2A:pMathType=mo;pmt(0x21C0);break;	//right harpoon up
	case 0x2B:pMathType=mo;pmt(0x21C1);break;	//right harpoon down
	case 0x2C:pMathType=mo;pmt(0x02BF);break;	//left half ring
	case 0x2D:pMathType=mo;pmt(0x02BE);break;	//right half ring
	case 0x2E:pMathType=mo;pmt(0x25B9);break;	//right triangle small
	case 0x2F:pMathType=mo;pmt(0x25C3);break;	//left triangle small

	case 0x30:
	case 0x31:
	case 0x32:
	case 0x33:
	case 0x34:
	case 0x35:
	case 0x36:
	case 0x37:
	case 0x38:
	case 0x39:pMathType=mn;pmt(*temp);break;//digits
	case 0x3A:pMathType=mo;pmt(0x002E);break;//dot
	case 0x3B:pMathType=mo;pmt(0x002C);break;//comma
	case 0x3C://less than
		if(combiningUnicode==0x0338) { 
			combiningUnicode=0;
			pmt(0x226F);
		}	else	p("<mo>&lt;</mo>");
		break;
	case 0x3D:pMathType=mo;pmt(0x002F);break;//division
	case 0x3E: //greater than
		if(combiningUnicode==0x0338) { 
			combiningUnicode=0;
			pmt(0x226F);
		}	else	p("<mo>&gt;</mo>");
		break;
	case 0x3F:pMathType=mo;pmt(0x25C6);break;	//star operator

	case 0x40:pMathType=mo;pmt(0x2202);break;	//partial diff

	case 0x5B:pMathType=mo;pmt(0x266D);break;	//music flat
	case 0x5C:pMathType=mo;pmt(0x266E);break;	//music natural
	case 0x5D:pMathType=mo;pmt(0x266F);break;	//music sharp
	case 0x5E:pMathType=mo;pmt(0x203F);break;	//character tie
	case 0x5F:pMathType=mo;pmt(0x2040);break;	//under tie

	case 0x60:pMathType=mo;pmt(0x2113);break;	//ell script

	case 0x7B:pMathType=mi;theFont.style=italic;pmt(0x0131);theFont.style=staticFontStyle;break;	//dotless i
	case 0x7C:pMathType=mi;theFont.style=italic;pmt(0x0237);theFont.style=staticFontStyle;break;	//dotless j
	case 0x7D:pMathType=mo;
		staticFontFamily=theFont.family;
		theFont.family=cursive;
		pmt(0x2118);
		theFont.family=staticFontFamily;
		break;	//script capital P
	case 0x7E:pMathType=mo;pmt(0x20d7);break;	//combining right arrow above, XXX cmmi is spacing though
	case 0x7F:pMathType=mo;pmt(0x2040);break;	//tie
	default:
		pMathType=mi;theFont.style=italic;pmt(*temp);theFont.style=staticFontStyle;
	}
	temp++;
}while(*temp);
return;
}

void fontMapMathItalicA(){
//px[b]mia, tx[b]mia
	unsigned char* temp=(unsigned char*)yytext;
	int staticFontFamily;
	
do{
	switch(*temp){
	case 0x00:pMathType=mo;pmt(0x0393);break;//Gamma
	case 0x01:pMathType=mo;pmt(0x0394);break;//Delta
	case 0x02:pMathType=mo;pmt(0x0398);break;//Theta
	case 0x03:pMathType=mo;pmt(0x039B);break;//Lambda
	case 0x04:pMathType=mo;pmt(0x039E);break;//Xi
	case 0x05:pMathType=mo;pmt(0x03A0);break;//Pi
	case 0x06:pMathType=mo;pmt(0x03A3);break;//Sigma
	case 0x07:pMathType=mo;pmt(0x03D2);break;//Upsilon with hook
	case 0x08:pMathType=mo;pmt(0x03A6);break;//Phi
	case 0x09:pMathType=mo;pmt(0x03A8);break;//Psi
	case 0x0A:pMathType=mo;pmt(0x03A9);break;//Omega
	case 0x0B:pMathType=mo;pmt(0x03B1);break;//alpha
	case 0x0C:pMathType=mo;pmt(0x03B2);break;//beta
	case 0x0D:pMathType=mo;pmt(0x03B3);break;//gamma
	case 0x0E:pMathType=mo;pmt(0x03B4);break;//delta
	case 0x0F:pMathType=mo;pmt(0x03B5);break;//epsilon

	case 0x10:pMathType=mo;pmt(0x03B6);break;//zeta
	case 0x11:pMathType=mo;pmt(0x03B7);break;//eta
	case 0x12:pMathType=mo;pmt(0x03B8);break;//theta
	case 0x13:pMathType=mo;pmt(0x03B9);break;//iota
	case 0x14:pMathType=mo;pmt(0x03BA);break;//kappa
	case 0x15:pMathType=mo;pmt(0x03BB);break;//lambda
	case 0x16:pMathType=mo;pmt(0x03BC);break;//mu
	case 0x17:pMathType=mo;pmt(0x03BD);break;//nu
	case 0x18:pMathType=mo;pmt(0x03BE);break;//xi
	case 0x19:pMathType=mo;pmt(0x03C0);break;//pi
	case 0x1A:pMathType=mo;pmt(0x03C1);break;//ro
	case 0x1B:pMathType=mo;pmt(0x03C3);break;//sigma
	case 0x1C:pMathType=mo;pmt(0x03C4);break;//tau
	case 0x1D:pMathType=mo;pmt(0x03C5);break;//upsilon
	case 0x1E:pMathType=mo;pmt(0x03C6);break;//phi
	case 0x1F:pMathType=mo;pmt(0x03C7);break;//chi

	case 0x20:pMathType=mo;pmt(0x03C8);break;//psi
	case 0x21:pMathType=mo;pmt(0x03C9);break;//omega
	case 0x22:pMathType=mo;pmt(0x025B);break;//latin epsilon
	case 0x23:pMathType=mo;pmt(0x03D1);break;//script theta
	case 0x24:pMathType=mo;pmt(0x03D6);break;//varpi
	case 0x25:pMathType=mo;pmt(0x03F1);break;//varrho
	case 0x26:pMathType=mo;pmt(0x03C2);break;//final sigma
	case 0x27:pMathType=mo;pmt(0x03C6);break;//italic phi
	
	//nothing here
	
	case 0x31:pMathType=mi;pmt(0x0261);break;//varg, latin g
	case 0x32:pMathType=mi;pmt(0x0079);break;//\yl, only in tx
	case 0x33:pMathType=mi;pmt(0x0076);break;//\vl, only in tx
	case 0x34:pMathType=mi;pmt(0x0077);break;//\wl, only in tx
	
	//nothing here
	
	case 0x41://pmt(0x1D504);break;//fraktur A
	case 0x42://pmt(0x1D505);break;//fraktur B
	case 0x43://pmt(0x212D);break;//fraktur C
	case 0x44://pmt(0x1D507);break;//fraktur D
	case 0x45://pmt(0x1D508);break;//fraktur E
	case 0x46://pmt(0x1D509);break;//fraktur F
	case 0x47://pmt(0x1D50A);break;//fraktur G
	case 0x48://pmt(0x210C);break;//fraktur H
	case 0x49://pmt(0x2111);break;//fraktur I
	case 0x4A://pmt(0x1D50D);break;//fraktur J
	case 0x4B://pmt(0x1D50E);break;//fraktur K
	case 0x4C://pmt(0x1D50F);break;//fraktur L
	case 0x4D://pmt(0x1D510);break;//fraktur M
	case 0x4E://pmt(0x1D511);break;//fraktur N
	case 0x4F://pmt(0x1D512);break;//fraktur O

	case 0x50://pmt(0x2119);break;//pmt(0x1D513);break;//fraktur P
	case 0x51://pmt(0x211A);break;//pmt(0x1D514);break;//fraktur Q
	case 0x52://pmt(0x211C);break;//fraktur R
	case 0x53://pmt(0x1D516);break;//fraktur S
	case 0x54://pmt(0x1D517);break;//fraktur T
	case 0x55://pmt(0x1D518);break;//fraktur U
	case 0x56://pmt(0x1D519);break;//fraktur V
	case 0x57://pmt(0x1D51A);break;//fraktur W
	case 0x58://pmt(0x1D51B);break;//fraktur X
	case 0x59://pmt(0x1D51C);break;//fraktur Y
	case 0x5A://pmt(0x2128);break;//fraktur Z
		pMathType=mo;staticFontFamily=theFont.family;
		theFont.family=fraktur;pmt(*temp);
		theFont.family=staticFontFamily;
		break;

	//nothing
				
	case 0x61://pmt(0x1D586);break;//fraktur a
	case 0x62://pmt(0x1D587);break;//fraktur b
	case 0x63://pmt(0x1D588);break;//fraktur c
	case 0x64://pmt(0x1D589);break;//fraktur d
	case 0x65://pmt(0x1D58A);break;//fraktur e
	case 0x66://pmt(0x1D58B);break;//fraktur f
	case 0x67://pmt(0x1D58C);break;//fraktur g
	case 0x68://pmt(0x1D58D);break;//fraktur h
	case 0x69://pmt(0x1D58E);break;//fraktur i
	case 0x6A://pmt(0x1D58F);break;//fraktur j
	case 0x6B://pmt(0x1D590);break;//fraktur k
	case 0x6C://pmt(0x1D591);break;//fraktur k
	case 0x6D://pmt(0x1D592);break;//fraktur m
	case 0x6E://pmt(0x1D593);break;//fraktur n
	case 0x6F://pmt(0x1D594);break;//fraktur o

	case 0x70://pmt(0x1D595);break;//fraktur p
	case 0x71://pmt(0x1D596);break;//fraktur q
	case 0x72://pmt(0x1D597);break;//fraktur r
	case 0x73://pmt(0x1D598);break;//fraktur s
	case 0x74://pmt(0x1D599);break;//fraktur t
	case 0x75://pmt(0x1D59A);break;//fraktur u
	case 0x76://pmt(0x1D59B);break;//fraktur v
	case 0x77://pmt(0x1D59C);break;//fraktur w
	case 0x78://pmt(0x1D59D);break;//fraktur x
	case 0x79://pmt(0x1D59E);break;//fraktur y
	case 0x7A://pmt(0x1D59F);break;//fraktur z
		pMathType=mo;staticFontFamily=theFont.family;
		theFont.family=fraktur;pmt(*temp);
		theFont.family=staticFontFamily;
		break;
		
	//nothing
	case 0x7F:pMathType=mo;pmt(0x2040);break;//tie

	//only txmia from here
	//nothing
	case 0x81:
	case 0x82:
	case 0x83:
	case 0x84:
	case 0x85:
	case 0x86:
	case 0x87:
	case 0x88:
	case 0x89:
	case 0x8A:
	case 0x8B:
	case 0x8C:
	case 0x8D:
	case 0x8E:
	case 0x8F:

	case 0x90:
	case 0x91:
	case 0x92:
	case 0x93:
	case 0x94:
	case 0x95:
	case 0x96:
	case 0x97:
	case 0x98:
	case 0x99:
	case 0x9A://pMathType=mo;pmt(*temp-0x20);break;//ds A-Z
		pMathType=mo;staticFontFamily=theFont.family;
		theFont.family=doubleStruck;pmt(*temp-0x20);
		theFont.family=staticFontFamily;
		break;
	
	//nothing

	case 0xAB:pMathType=mo;pmt('k');break;//ds k
	//nothing
	}
	temp++;
}while(*temp);
return;
}




void fontMapMsam(){
//msam, px[b]sya, tx[b]sya, xccam, cmbras

unsigned char* temp=(unsigned char*)yytext;

do{
	switch(*temp){
	case 0x00:pMathType=mo;pmt(0x22A1);break;//squared dot
	case 0x01:pMathType=mo;pmt(0x229E);break;//squared plus
	case 0x02:pMathType=mo;pmt(0x22A0);break;//squared times
	case 0x03:pMathType=mo;pmt(0x25A1);break;//white square (d'Alembertian :()
	case 0x04:pMathType=mo;pmt(0x25A0);break;//black square
	case 0x05:pMathType=mo;pmt(0x00B7);break;//center dot
	case 0x06:pMathType=mo;pmt(0x25CA);break;//lozenge
	case 0x07:pMathType=mo;pmt(0x29EB);break;//black lozenge
	case 0x08:pMathType=mo;pmt(0x21BB);break;//circlearrowright
	case 0x09:pMathType=mo;pmt(0x21BA);break;//circlearrowleft
	case 0x0A:pMathType=mo;pmt(0x21CC);break;//rightleftharpoons
	case 0x0B:pMathType=mo;pmt(0x21CB);break;//leftrightharpoons
	case 0x0C:pMathType=mo;pmt(0x229F);break;//squared minus
	case 0x0D:pMathType=mo;	//Vdash
		precomposedNegative(0x22A9,0x22AE);
		break;
	case 0x0E:pMathType=mo;pmt(0x22AA);break;//Vvdash
	case 0x0F:pMathType=mo;	//vDash
		precomposedNegative(0x22A8,0x22AD);
		break;

	case 0x10:pMathType=mo;pmt(0x21A0);break;//twoheadrightarrow
	case 0x11:pMathType=mo;pmt(0x219E);break;//twoheadleftarrow
	case 0x12:pMathType=mo;pmt(0x21C7);break;//left paired arrows
	case 0x13:pMathType=mo;pmt(0x21C9);break;//right paired arrows
	case 0x14:pMathType=mo;pmt(0x21C8);break;//up paired arrows
	case 0x15:pMathType=mo;pmt(0x21CA);break;//down paired arrows
	case 0x16:pMathType=mo;pmt(0x21BE);break;//up harpoon right barb
	case 0x17:pMathType=mo;pmt(0x21C2);break;//down harpoon right barb
	case 0x18:pMathType=mo;pmt(0x21BF);break;//up harpoon left barb
	case 0x19:pMathType=mo;pmt(0x21C3);break;//down harpoon left barb
	case 0x1A:pMathType=mo;pmt(0x21A3);break;//rightarrowtail
	case 0x1B:pMathType=mo;pmt(0x21A2);break;//leftarrowtail
	case 0x1C:pMathType=mo;pmt(0x21C6);break;//left over right arrows
	case 0x1D:pMathType=mo;pmt(0x21C4);break;//right over left arrows
	case 0x1E:pMathType=mo;pmt(0x21B0);break;//uparrow left tip
	case 0x1F:pMathType=mo;pmt(0x21B1);break;//uparrow right tip

	case 0x20:pMathType=mo;pmt(0x21DD);break;//right squiggle arrow
	case 0x21:pMathType=mo;pmt(0x21AD);break;//leftright wave arrow
	case 0x22:pMathType=mo;pmt(0x21AB);break;//left arrow loop
	case 0x23:pMathType=mo;pmt(0x21AC);break;//right arrow loop
	case 0x24:pMathType=mo;pmt(0x2257);break;//ring equal
	case 0x25:pMathType=mo;pmt(0x227F);break;//succeedes equivalent
	case 0x26:pMathType=mo;									//greater equivalent
						precomposedNegative(0x2273,0x2275);
						break;
	case 0x27:pMathType=mo;pmt(0x2267);break;//greater over equal
	case 0x28:pMathType=mo;pmt(0x22B8);break;//multimap
	case 0x29:pMathType=mo;pmt(0x2234);break;//therefore
	case 0x2A:pMathType=mo;pmt(0x2235);break;//because
	case 0x2B:pMathType=mo;pmt(0x2251);break;//geometric equal
	case 0x2C:pMathType=mo;pmt(0x225C);break;//delta equal
	case 0x2D:pMathType=mo;pmt(0x227E);break;//precedes equiv
	case 0x2E:pMathType=mo;									//less equiv
						precomposedNegative(0x2272,0x2274);
						break;
	case 0x2F:pMathType=mo;pmt(0x2AB7);break;//precapprox

	case 0x30:pMathType=mo;pmt(0x22DC);break;//equal less
	case 0x31:pMathType=mo;pmt(0x22DD);break;//equal greater
	case 0x32:pMathType=mo;pmt(0x22DE);break;//equal preceds
	case 0x33:pMathType=mo;pmt(0x22DF);break;//equal succeedes
	case 0x34:pMathType=mo;	//precedes equal
		precomposedNegative(0x227C,0x22E0);
		break;
	case 0x35:pMathType=mo;pmt(0x2266);break;//less over equal
	case 0x36:pMathType=mo;pmt(0x2A7D);break;//leqslant
	case 0x37:pMathType=mo;									//less greater
						precomposedNegative(0x2276,0x2278);
						break;
	case 0x38:pMathType=mo;pmt(0x2035);break;//back prime
	case 0x39:pMathType=mo;pmt(0x2012);break;//figure dash
	case 0x3A:pMathType=mo;pmt(0x2253);break;//image approx
	case 0x3B:pMathType=mo;pmt(0x2252);break;//approx image
	case 0x3C:pMathType=mo;	//succeeds equal
		precomposedNegative(0x227D,0x22E1);
		break;
	case 0x3D:pMathType=mo;pmt(0x2267);break;//greater over equal
	case 0x3E:pMathType=mo;pmt(0x2A7E);break;//greater equal slant
	case 0x3F:pMathType=mo;									//greater less
						precomposedNegative(0x2277,0x2279);
						break;
	case 0x40:pMathType=mo;pmt(0x228F);break;//square subset
	case 0x41:pMathType=mo;pmt(0x2290);break;//square superset
	case 0x42:pMathType=mo;	//normal subgroup
		precomposedNegative(0x22B2,0x22EA);
		break;
	case 0x43:pMathType=mo;	//contains as normal subgroup
		precomposedNegative(0x22B3,0x22EB);
		break;
	case 0x44:pMathType=mo;	//contains as normal subgroup equal
		precomposedNegative(0x22B5,0x22ED);
		break;
	case 0x45:pMathType=mo;	//normal subgroup equal
		precomposedNegative(0x22B4,0x22EC);
		break;
	case 0x46:pMathType=mo;pmt(0x2605);break;//bigstar
	case 0x47:pMathType=mo;pmt(0x226C);break;//between
	case 0x48:pMathType=mo;pmt(0x25BE);break;//black triangle down
	case 0x49:pMathType=mo;pmt(0x25B8);break;//black triangle right
	case 0x4A:pMathType=mo;pmt(0x25C2);break;//black triangle left
	case 0x4B:pMathType=mo;pmt(0x20D7);break;//combining arrow right
	case 0x4C:pMathType=mo;pmt(0x20D6);break;//combining arrow left
	case 0x4D:pMathType=mo;pmt(0x25B5);break;//white triangle up
	case 0x4E:pMathType=mo;pmt(0x25B4);break;//black triangle up
	case 0x4F:pMathType=mo;pmt(0x25BF);break;//white triangle down

	case 0x50:pMathType=mo;pmt(0x2256);break;//ring in equal to
	case 0x51:pMathType=mo;pmt(0x22DA);break;//less equal greater
	case 0x52:pMathType=mo;pmt(0x22DB);break;//greater equal less
	case 0x53:pMathType=mo;pmt(0x2A8B);break;//less eqqual greater
	case 0x54:pMathType=mo;pmt(0x2A8C);break;//greater eqqual less
	case 0x55:pMathType=mo;pmt(0x00A5);break;//yuan
	case 0x56:pMathType=mo;pmt(0x21DB);break;//right triple arrow
	case 0x57:pMathType=mo;pmt(0x21DA);break;//left triple arrow
	case 0x58:pMathType=mo;pmt(0x2713);break;//check mark
	case 0x59:pMathType=mo;pmt(0x22BB);break;//xor
	case 0x5A:pMathType=mo;pmt(0x22BC);break;//nand
	case 0x5B:pMathType=mo;pmt(0x2306);break;//perspective
	case 0x5C:pMathType=mo;pmt(0x2220);break;//angle
	case 0x5D:pMathType=mo;pmt(0x2221);break;//measured angle
	case 0x5E:pMathType=mo;pmt(0x2222);break;//arc angle
	case 0x5F:pMathType=mo;pmt(0x221D);break;//propto

	case 0x60:pMathType=mo;pmt(0x2323);break;//ssmile
	case 0x61:pMathType=mo;pmt(0x2322);break;//sfrown
	case 0x62:pMathType=mo;pmt(0x22D0);break;//double subset
	case 0x63:pMathType=mo;pmt(0x22D1);break;//double superset
	case 0x64:pMathType=mo;pmt(0x22D2);break;//double union
	case 0x65:pMathType=mo;pmt(0x22D3);break;//double intersection
	case 0x66:pMathType=mo;pmt(0x22CF);break;//curly logical and
	case 0x67:pMathType=mo;pmt(0x22CE);break;//curly logical or
	case 0x68:pMathType=mo;pmt(0x22CB);break;//left semidirect product
	case 0x69:pMathType=mo;pmt(0x22CC);break;//right semidirect product
	case 0x6A:pMathType=mo;pmt(0x2AC5);break;//subseteqq
	case 0x6B:pMathType=mo;pmt(0x2AC6);break;//supseteqq
	case 0x6C:pMathType=mo;pmt(0x224F);break;//difference
	case 0x6D:pMathType=mo;pmt(0x224E);break;//geometrical equivalent
	case 0x6E:pMathType=mo;pmt(0x22D8);break;//very much less
	case 0x6F:pMathType=mo;pmt(0x22D9);break;//very much greater

	case 0x70:pMathType=mo;pmt(0x231C);break;//top left corner
	case 0x71:pMathType=mo;pmt(0x231D);break;//top right corner
	case 0x72:pMathType=mo;pmt(0x24C7);break;//circle R
	case 0x73:pMathType=mo;pmt(0x24C8);break;//circle S
	case 0x74:pMathType=mo;pmt(0x22D4);break;//pitchfork
	case 0x75:pMathType=mo;pmt(0x2214);break;//dot plus
	case 0x76:pMathType=mo;pmt(0x223D);break;//reversed tilde
	case 0x77:pMathType=mo;pmt(0x22CD);break;//reversed tilde equal
	case 0x78:pMathType=mo;pmt(0x231E);break;//bottom left corner
	case 0x79:pMathType=mo;pmt(0x231F);break;//bottom right corner
	case 0x7A:pMathType=mo;pmt(0x2720);break;//maltese cross
	case 0x7B:pMathType=mo;pmt(0x2201);break;//complement
	case 0x7C:pMathType=mo;pmt(0x22BA);break;//intercal
	case 0x7D:pMathType=mo;pmt(0x229A);break;//circled ring
	case 0x7E:pMathType=mo;pmt(0x229B);break;//circled asterisk
	case 0x7F:pMathType=mo;pmt(0x229D);break;//circled dash

	}
	temp++;
}while(*temp) ;
return;
}
	

void fontMapMsbm(){
//msbm, px[b]syb, tx[b]syb, xccbm, cmbrbs
int staticFontFamily;
unsigned char* temp=(unsigned char*)yytext;

do{
	switch(*temp){
	case 0x00:pMathType=mo;pmt(0x2268);break;//less not equal
	case 0x01:pMathType=mo;pmt(0x2269);break;//greater not equal
	case 0x02:pMathType=mo;pmt(0x2270);break;//not less not equal
	case 0x03:pMathType=mo;pmt(0x2271);break;//not greater not equal
	case 0x04:pMathType=mo;pmt(0x226E);break;//not less
	case 0x05:pMathType=mo;pmt(0x226F);break;//not greater
	case 0x06:pMathType=mo;pmt(0x2280);break;//not precede
	case 0x07:pMathType=mo;pmt(0x2281);break;//not succceed
	case 0x08:pMathType=mo;pmt(0x2268);break;//less than not equal
	case 0x09:pMathType=mo;pmt(0x2269);break;//greater than not equal
	case 0x0A:pMathType=mo;pmt(0x2270);break;//not less not equal
	case 0x0B:pMathType=mo;pmt(0x2271);break;//not greater not equal
	case 0x0C:pMathType=mo;pmt(0x2A87);break;//less not equal
	case 0x0D:pMathType=mo;pmt(0x2A88);break;//greater not equal
	case 0x0E:p("<mo>");p(ul2utf8(0x2AAF));p(ul2utf8(0x0338));p("</mo>");break;//not precedes not equal
	case 0x0F:p("<mo>");p(ul2utf8(0x2AB0));p(ul2utf8(0x0338));p("</mo>");break;//not succeeds not equal

	case 0x10:pMathType=mo;pmt(0x22E7);break;//precedes not equivalent
	case 0x11:pMathType=mo;pmt(0x22E8);break;//succeeds not equivalent
	case 0x12:pMathType=mo;pmt(0x22E6);break;//less not equivalent
	case 0x13:pMathType=mo;pmt(0x22E7);break;//greater not equivalent
	case 0x14:p("<mo>");p(ul2utf8(0x2266));p(ul2utf8(0x0338));p("</mo>");break;//not less not equal
	case 0x15:p("<mo>");p(ul2utf8(0x2267));p(ul2utf8(0x0338));p("</mo>");break;//not greater not equal
	case 0x16:pMathType=mo;pmt(0x2AB5);break;//precedes not equal
	case 0x17:pMathType=mo;pmt(0x2AB6);break;//succeedes not equal
	case 0x18:pMathType=mo;pmt(0x2AB9);break;//precedes not approx
	case 0x19:pMathType=mo;pmt(0x2ABA);break;//succeeds not approx
	case 0x1A:pMathType=mo;pmt(0x2A89);break;//less not approx
	case 0x1B:pMathType=mo;pmt(0x2A8A);break;//greater not approx
	case 0x1C:pMathType=mo;pmt(0x2241);break;//not tilde
	case 0x1D:pMathType=mo;pmt(0x2247);break;//not approximate not equal
	case 0x1E:pMathType=mo;pmt(0x2571);break;//diagup
	case 0x1F:pMathType=mo;pmt(0x2572);break;//diagdown

	case 0x20:p("<mo>");p(ul2utf8(0x228A));p(ul2utf8(0xFE00));p("</mo>");break;//var subset not equal
	case 0x21:p("<mo>");p(ul2utf8(0x228B));p(ul2utf8(0xFE00));p("</mo>");break;//var supset not equal
	case 0x22:p("<mo>");p(ul2utf8(0x2AC5));p(ul2utf8(0x0338));p("</mo>");break;//not subset not eqqual
	case 0x23:p("<mo>");p(ul2utf8(0x2AC6));p(ul2utf8(0x0338));p("</mo>");break;//not superset not eqqual
	case 0x24:pMathType=mo;pmt(0x2ACB);break;//subset not eqqual
	case 0x25:pMathType=mo;pmt(0x2ACC);break;//superset not eqqual
	case 0x26:p("<mo>");p(ul2utf8(0x2ACB));p(ul2utf8(0xFE00));p("</mo>");break;//var subset not eqqual
	case 0x27:p("<mo>");p(ul2utf8(0x2ACC));p(ul2utf8(0xFE00));p("</mo>");break;//var superset not eqqual
	case 0x28:pMathType=mo;pmt(0x228A);break;//subset not equal
	case 0x29:pMathType=mo;pmt(0x228B);break;//superset not equal
	case 0x2A:pMathType=mo;pmt(0x2288);break;//not subset not equal
	case 0x2B:pMathType=mo;pmt(0x2289);break;//not superset not equal
	case 0x2C:pMathType=mo;pmt(0x2226);break;//not parallel
	case 0x2D:pMathType=mo;pmt(0x2224);break;//not divide
	case 0x2E:pMathType=mo;pmt(0x2224);break;//short not divide
	case 0x2F:pMathType=mo;pmt(0x2226);break;//short not parallel

	case 0x30:pMathType=mo;pmt(0x22AC);break;//does not prove
	case 0x31:pMathType=mo;pmt(0x22AE);break;//does not force
	case 0x32:pMathType=mo;pmt(0x22AD);break;//not true
	case 0x33:pMathType=mo;pmt(0x22AF);break;//nVDash
	case 0x34:pMathType=mo;pmt(0x22ED);break;//not triangle right not equal
	case 0x35:pMathType=mo;pmt(0x22EC);break;//not triangle left not equal
	case 0x36:pMathType=mo;pmt(0x22EA);break;//not triangle left
	case 0x37:pMathType=mo;pmt(0x22EC);break;//not triangle right
	case 0x38:pMathType=mo;pmt(0x219A);break;//not left arrow
	case 0x39:pMathType=mo;pmt(0x219B);break;//not right arrow
	case 0x3A:pMathType=mo;pmt(0x21CD);break;//not left double arrow
	case 0x3B:pMathType=mo;pmt(0x21CF);break;//not right double arrow
	case 0x3C:pMathType=mo;pmt(0x21CE);break;//not left right double arrow
	case 0x3D:pMathType=mo;pmt(0x21AE);break;//not left right arrow
	case 0x3E:pMathType=mo;pmt(0x22C7);break;//division times
	case 0x3F:pMathType=mo;pmt(0x2205);break;//var empty set

	case 0x40:pMathType=mo;pmt(0x2204);break;//not exist
	case 0x41:
	case 0x42:
	case 0x43:
	case 0x44:
	case 0x45:
	case 0x46:
	case 0x47:
	case 0x48:
	case 0x49:
	case 0x4A:
	case 0x4B:
	case 0x4C:
	case 0x4D:
	case 0x4E:
	case 0x4F:

	case 0x50:
	case 0x51:
	case 0x52:
	case 0x53:
	case 0x54:
	case 0x55:
	case 0x56:
	case 0x57:
	case 0x58:
	case 0x59:
	case 0x5A:pMathType=mo;
			staticFontFamily=theFont.family;
			theFont.family=doubleStruck;
			pmt(*temp);
			theFont.family=staticFontFamily;
			break;//double A-Z
	case 0x5B:pMathType=mo;pmt('^');break;//
	case 0x5C:pMathType=mo;pmt('^');break;//
	case 0x5D:pMathType=mo;pmt('~');break;//
	case 0x5E:pMathType=mo;pmt('~');break;//
	
	//nothing
	
	case 0x60:pMathType=mo;pmt(0x2132);break;//turned capital F
	case 0x61:pMathType=mo;pmt(0x2141);break;//turned sans-serif capital G

	case 0x66:pMathType=mo;pmt(0x2127);break;//mho
	case 0x67:pMathType=mo;pmt(0x00D0);break;//eth
	case 0x68:pMathType=mo;pmt(0x2242);break;//minus tilde
	case 0x69:pMathType=mo;pmt(0x2136);break;//beth
	case 0x6A:pMathType=mo;pmt(0x2137);break;//gimel
	case 0x6B:pMathType=mo;pmt(0x2138);break;//daleth
	case 0x6C:pMathType=mo;pmt(0x22D6);break;//less dot
	case 0x6D:pMathType=mo;pmt(0x22D7);break;//greater dot
	case 0x6E:pMathType=mo;pmt(0x22C9);break;//left normal factor semidirect product
	case 0x6F:pMathType=mo;pmt(0x2216);break;//right normal factor semidirect product

	case 0x70:pMathType=mo;pmt(0x2223);break;//divides
	case 0x71:pMathType=mo;pmt(0x2225);break;//parallel to
	case 0x72:pMathType=mo;pmt(0x005C);break;//integer divide
	case 0x73:pMathType=mo;								//similar
		precomposedNegative(0x223C, 0x2241);
		break;
	case 0x74:pMathType=mo;									//thickapprox
		precomposedNegative(0x2248, 0x2249);
		break;
	case 0x75:pMathType=mo;pmt(0x224A);break;//approxeq
	case 0x76:pMathType=mo;pmt(0x2AB8);break;//succapprox
	case 0x77:pMathType=mo;pmt(0x2AB7);break;//precapprox
	case 0x78:pMathType=mo;pmt(0x21B6);break;//curve arrow left
	case 0x79:pMathType=mo;pmt(0x21B7);break;//curve arrow right
	case 0x7A:pMathType=mo;pmt(0x03DD);break;//digamma
	case 0x7B:pMathType=mo;pmt(0x03F0);break;//varkappa
	case 0x7C:pMathType=mo;
		staticFontFamily=theFont.family;
		theFont.family=doubleStruck;
		pmt(0x006b);
		theFont.family=staticFontFamily;
		break;//bbbk
	case 0x7D:pMathType=mo;pmt(0x210F);break;//hslash
	case 0x7E:pMathType=mo;pmt(0x210F);break;//hbar
	case 0x7F:pMathType=mo;pmt(0x03F6);break;//backepsilon

	}
	temp++;
}while(*temp) ;
return;
}

void fontMapMathSymbolC(){
//tx[b]syc,px[b]syc
unsigned char* temp=(unsigned char*)yytext;

do{
	switch(*temp){
	case 0x00:pMathType=mo;pmt(0x22A3);break;//left tack
	case 0x01:pMathType=mo;pmt(0x22A7);break;//models
	case 0x02:pMathType=mo;pmt(0x2AE4);break;//vertical bar left double turnstile
	case 0x03:pMathType=mo;pmt(0x22A9);break;//forces
	case 0x04:pMathType=mo;pmt(0x2AE3);break;//double vertical bar left turnstile
	case 0x05:pMathType=mo;pmt(0x22AB);break;//double vertical bar right double turnstile
	case 0x06:pMathType=mo;pmt(0x2AE5);break;//double vertical bar left double turnstile
	case 0x07:pMathType=mo;pmt(0x25CB);break;//white circle
	case 0x08:pMathType=mo;pmt(0x25CF);break;//black circle
	case 0x09:pMathType=mo;pmt(0x2AFD);break;//double solidus, varparallel
	case 0x0A:pMathType=mo;pmt(0x244A);break;//OCR double backslash, nvarparallelinv
	case 0x0B:p("<mo>");p(ul2utf8(0x2AFD));p(ul2utf8(0x0338));p("</mo>");break;//negated double solidus, nvarparallel
	case 0x0C:p("<mo>");p(ul2utf8(0x244A));p(ul2utf8(0x0338));p("</mo>");break;//negated OCR double backslash, nvarparallelinv
	case 0x0D:p("<mo>");p(":");p(ul2utf8(0x2248));p("</mo>");break;//XXX,colon almost equal,\colonapprox
	case 0x0E:p("<mo>");p(":");p(ul2utf8(0x223C));p("</mo>");break;//XXX,colon similar, \colonsim
	case 0x0F:p("<mo>");p("::");p(ul2utf8(0x2248));p("</mo>");break;//XXX,double colon almost equal,\Colonapprox

	case 0x10:p("<mo>");p("::");p(ul2utf8(0x223C));p("</mo>");break;//double colon similar,\Colonsim
	case 0x11:pMathType=mo;pmt(0x2250);break;//approaches the limit,\doteq
	case 0x12:pMathType=mo;pmt(0x27DC);break;//left multimap
	case 0x13:pMathType=mo;pmt(0x29DF);break;//double-ended multimap
	case 0x14:p("<mo>");p(ul2utf8(0x2212));p(ul2utf8(0x2022));p("</mo>");break;//XXX=minus+bullet,\multimapdot
	case 0x15:p("<mo>");p(ul2utf8(0x2022));p(ul2utf8(0x2212));p("</mo>");break;//XXX,\multimapdotinv
	case 0x16:p("<mo>");p(ul2utf8(0x2022));p(ul2utf8(0x2212));p(ul2utf8(0x2022));p("</mo>");break;//XXX,\multimapdotboth
	case 0x17:pMathType=mo;pmt(0x22B6);break;//original of
	case 0x18:pMathType=mo;pmt(0x22B7);break; //image of
	case 0x19:pMathType=mo;pmt(0x22AB);break;//double vertical bar double turnstile right
	case 0x1A:p("<mo>");p("|");p(ul2utf8(0x22AB));p("</mo>");break; //XXX, triple vbar double turnstile right
	case 0x1B:pMathType=mo;pmt(0x2245);break; //\cong
	case 0x1C:pMathType=mo;pmt(0x2AAF);break; //\preceqq
	case 0x1D:pMathType=mo;pmt(0x2AB0);break; //\succeqq
	case 0x1E:p("<mo>");p(ul2utf8(0x227E));p(ul2utf8(0x0338));p("</mo>");break; //\nprecsim
	case 0x1F:p("<mo>");p(ul2utf8(0x227F));p(ul2utf8(0x0338));p("</mo>");break; //\nsuccsim

	case 0x20:pMathType=mo;pmt(0x2274);break;//\nlesssim
	case 0x21:pMathType=mo;pmt(0x2275);break;//\ngtrsim
	case 0x22:p("<mo>");p(ul2utf8(0x2A85));p(ul2utf8(0x0338));p("</mo>");break;//XXX,\nlessapprox
	case 0x23:p("<mo>");p(ul2utf8(0x2A86));p(ul2utf8(0x0338));p("</mo>");break;//XXX,\ngtrapprox
	case 0x24:pMathType=mo;pmt(0x22E0);break;//\npreccurlyeq
	case 0x25:pMathType=mo;pmt(0x22E1);break;//\nsucccurlyeq
	case 0x26:pMathType=mo;pmt(0x2278);break;//\ngtrless
	case 0x27:pMathType=mo;pmt(0x2279);break;//\nlessgtr
	case 0x28:p("<mo>");p(ul2utf8(0x224F));p(ul2utf8(0x0338));p("</mo>");break;//\nbumpeq
	case 0x29:p("<mo>");p(ul2utf8(0x224E));p(ul2utf8(0x0338));p("</mo>");break;//\nBumpeq
	case 0x2A:p("<mo>");p(ul2utf8(0x223D));p(ul2utf8(0x0338));p("</mo>");break;//\nbacksim
	case 0x2B:p("<mo>");p(ul2utf8(0x224C));p(ul2utf8(0x0338));p("</mo>");break;//\nbacksimeq
	case 0x2C:pMathType=mo;pmt(0x2260);break;//\neq
	case 0x2D:pMathType=mo;pmt(0x226D);break;//\nasymp
	case 0x2E:pMathType=mo;pmt(0x2262);break;//\nequiv
	case 0x2F:pMathType=mo;pmt(0x2241);break;//\nsim

	case 0x30:pMathType=mo;pmt(0x2249);break;//\napprox
	case 0x31:pMathType=mo;pmt(0x2284);break;//\nsubset
	case 0x32:pMathType=mo;pmt(0x2285);break;//\nsupset
	case 0x33:p("<mo>");p(ul2utf8(0x226A));p(ul2utf8(0x0338));p("</mo>");break;//\nll
	case 0x34:p("<mo>");p(ul2utf8(0x226B));p(ul2utf8(0x0338));p("</mo>");break;//\ngg
	case 0x35:pMathType=mo;pmt(0x2249);break;//\nthickapprox
	case 0x36:pMathType=mo;pmt(0x224A);break;//\napproxeq
	case 0x37:p("<mo>");p(ul2utf8(0x2AB7));p(ul2utf8(0x0338));p("</mo>");break;//\nprecapprox
	case 0x38:p("<mo>");p(ul2utf8(0x2AB8));p(ul2utf8(0x0338));p("</mo>");break;//\nsuccapprox
	case 0x39:p("<mo>");p(ul2utf8(0x2AB3));p(ul2utf8(0x0338));p("</mo>");break;//\npreceqq
	case 0x3A:p("<mo>");p(ul2utf8(0x2AB4));p(ul2utf8(0x0338));p("</mo>");break;//\nsucceqq
	case 0x3B:pMathType=mo;pmt(0x2244);break;//\nsimeq 
	case 0x3C:pMathType=mo;pMathType=mo;pmt(0x2209);break;//\notin
	case 0x3D:pmt(0x220C);break;//\notni
	case 0x3E:p("<mo>");p(ul2utf8(0x22D0));p(ul2utf8(0x0338));p("</mo>");break;//\nSubset
	case 0x3F:p("<mo>");p(ul2utf8(0x22D1));p(ul2utf8(0x0338));p("</mo>");break;//\nSupset

	case 0x40:pMathType=mo;pmt(0x22E2);break;//\nsqsubseteq
	case 0x41:pMathType=mo;pmt(0x22E3);break;//\nsqsupseteq
	case 0x42:pMathType=mo;pmt(0x2254);break;//\coloneqq
	case 0x43:pMathType=mo;pmt(0x2255);break;//\eqqcolon
	case 0x44:p("<mo>");p(":-");p("</mo>");break;//XXX,\coloneq
	case 0x45:pMathType=mo;pmt(0x2239);break;//\eqcolon
	case 0x46:pMathType=mo;pmt(0x2A74);break;//\Coloneqq
	case 0x47:p("<mo>");p("=::");p("</mo>");break;//XXX,\Eqqcolon

	case 0x48:p("<mo>");p("::-");p("</mo>");break;//\Coloneq
	case 0x49:p("<mo>");p("-::");p("</mo>");break;//\Eqcolon
	case 0x4A:pMathType=mo;pmt(0x297D);break;//XXX, \strictif
	case 0x4B:pMathType=mo;pmt(0x297C);break;//XXX, \strictfi
	case 0x4C:p("<mo>");p(ul2utf8(0x297C));p(ul2utf8(0x297D));p("</mo>");break;//\strictiff
	case 0x4D:pMathType=mo;pmt(0x2639);break;//XXX not found in Unicode 4.1=frown,\invamp
	case 0x4E:pMathType=mo;pmt(0x27C5);break;//\lbag
	case 0x4F:pMathType=mo;pmt(0x27C6);break;//\rbag
	
	case 0x50:pMathType=mo;pmt(0x27C5);break;//\Lbag
	case 0x51:pMathType=mo;pmt(0x27C6);break;//\Rbag
	case 0x52:pMathType=mo;pmt(0x29C0);break;//\circledless
	case 0x53:pMathType=mo;pmt(0x29C1);break;//\circledgtr
	case 0x54:p("<mo>");p(ul2utf8(0x2227));p(ul2utf8(0x20DD));p("</mo>");break;//\circledwedge
	case 0x55:p("<mo>");p(ul2utf8(0x2228));p(ul2utf8(0x20DD));p("</mo>");break;//\circledvee
	case 0x56:pMathType=mo;pmt(0x29B6);break;//\circledbar
	case 0x57:pMathType=mo;pmt(0x29B8);break;//\circledbslash
	case 0x58:pMathType=mo;pmt(0x22C9);break;//XXX?,\lJoin
	case 0x59:pMathType=mo;pmt(0x22CA);break;//XXX?,\rJoin
	case 0x5A:pMathType=mo;pmt(0x2A1D);break;//\Join
	case 0x5B:pMathType=mo;pmt(0x2639);break;//XXX not found in Unicode 4.1,\openJoin
	case 0x5C:pMathType=mo;pmt(0x22C8);break;//\lrtimes
	case 0x5D:pMathType=mo;pmt(0x2A09);break;//\opentimes
	case 0x5E:pMathType=mo;pmt(0x25C7);break;//\Diamond
	case 0x5F:pMathType=mo;pmt(0x25C6);break;//\Diamondblack

	case 0x60:pMathType=mo;pmt(0x22C2);break;//XXX n-ary intersection,\nplus
	case 0x61:p("<mo>");p(ul2utf8(0x228F));p(ul2utf8(0x0338));p("</mo>");break;//\nsqsubset
	case 0x62:p("<mo>");p(ul2utf8(0x2290));p(ul2utf8(0x0338));p("</mo>");break;//\nsqsupset
	case 0x63:pMathType=mo;pmt(0x21E0);break;//\dashleftarrow
	case 0x64:pMathType=mo;pmt(0x21E2);break;//\dashrightarrow
	case 0x65:pMathType=mo;pmt(0x2639);break;//XXX not found in Unicode 4.1,\dashleftrightarrow
	case 0x66:pMathType=mo;pmt(0x21DC);break;//\leftsquigarrow
	case 0x67:p("<mo>");p(ul2utf8(0x21A0));p(ul2utf8(0x0338));p("</mo>");break;//\ntwoheadrightarrow
	case 0x68:p("<mo>");p(ul2utf8(0x219E));p(ul2utf8(0x0338));p("</mo>");break;//\ntwoheadleftarrow
	case 0x69:pMathType=mo;pmt(0x29C6);break;//\boxast
	case 0x6A:pMathType=mo;pmt(0x2342);break;//\boxbslash
	case 0x6B:p("<mo>");p("|");p(ul2utf8(0x20DE));p("</mo>");break;//\boxbar
	case 0x6C:pMathType=mo;pmt(0x2341);break;//\boxslash
	case 0x6D:pMathType=mo;pmt(0x2639);break;//XXX not found in Unicode 4.1=frown,\Wr
	case 0x6E:pMathType=mo;pmt(0x019B);break;//\lambdaslash
	case 0x6F:pMathType=mo;pmt(0x019B);break;//\lambdabar
	
	case 0x70:pMathType=mo;pmt(0x2667);break;//\varclubsuit
	case 0x71:pMathType=mo;pmt(0x2666);break;//\vardiamondsuit
	case 0x72:pMathType=mo;pmt(0x2665);break;//\varheartsuit
	case 0x73:pMathType=mo;pmt(0x2664);break;//\varspadesuit
	case 0x74:pMathType=mo;pmt(0x2B01);break;//\Nearrow
	case 0x75:pMathType=mo;pmt(0x2B02);break;//\Searrow
	case 0x76:pMathType=mo;pmt(0x2B00);break;//\Nwarrow
	case 0x77:pMathType=mo;pmt(0x2B03);break;//\Swarrow
	case 0x78:pMathType=mo;pmt(0x2AEA);break;//\Top
	case 0x79:pMathType=mo;pmt(0x2AEB);break;//\Bot,\Perp
	case 0x7A:pMathType=mo;pmt(0x223C);break;//\leadstoext
	case 0x7B:pMathType=mo;pmt(0x219D);break;//\leadsto
	case 0x7C:pMathType=mo;pmt(0x2639);break;//XXX not found in Unicode 4.1,\sqcupplus
	case 0x7D:pMathType=mo;pmt(0x2639);break;//XXX not found in Unicode 4.1,\sqcapplus
	case 0x7E:pMathType=mo;pmt(0x301A);break;//\llbracket
	case 0x7F:pMathType=mo;pmt(0x301B);break;//\rrbracket
	
	case 0x80:p("<mo>");p(ul2utf8(0x25A1));p(ul2utf8(0x2192));p("</mo>");break;//\boxright
	case 0x81:p("<mo>");p(ul2utf8(0x2190));p(ul2utf8(0x25A1));p("</mo>");break;//\boxleft
	case 0x82:p("<mo>");p(ul2utf8(0x22A1));p(ul2utf8(0x2192));p("</mo>");break;//\boxdotright
	case 0x83:p("<mo>");p(ul2utf8(0x2190));p(ul2utf8(0x22A1));p("</mo>");break;//\boxdotleft
	case 0x84:p("<mo>");p(ul2utf8(0x22C4));p(ul2utf8(0x2192));p("</mo>");break;//\Diamondright
	case 0x85:p("<mo>");p(ul2utf8(0x2190));p(ul2utf8(0x22C4));p("</mo>");break;//\Diamondleft
	case 0x86:p("<mo>");p(ul2utf8(0x27D0));p(ul2utf8(0x2192));p("</mo>");break;//\Diamonddotright
	case 0x87:p("<mo>");p(ul2utf8(0x2190));p(ul2utf8(0x27D0));p("</mo>");break;//\Diamonddotleft
	case 0x88:p("<mo>");p(ul2utf8(0x25A1));p(ul2utf8(0x21D2));p("</mo>");break;//\boxRight
	case 0x89:p("<mo>");p(ul2utf8(0x21D0));p(ul2utf8(0x25A1));p("</mo>");break;//\boxLeft
	case 0x8A:p("<mo>");p(ul2utf8(0x22A1));p(ul2utf8(0x21D2));p("</mo>");break;//\boxdotRight
	case 0x8B:p("<mo>");p(ul2utf8(0x21D0));p(ul2utf8(0x22A1));p("</mo>");break;//\boxdotLeft
	case 0x8C:p("<mo>");p(ul2utf8(0x22C4));p(ul2utf8(0x21D2));p("</mo>");break;//\DiamondRight
	case 0x8D:p("<mo>");p(ul2utf8(0x21D0));p(ul2utf8(0x22C4));p("</mo>");break;//\DiamondLeft
	case 0x8E:p("<mo>");p(ul2utf8(0x27D0));p(ul2utf8(0x21D2));p("</mo>");break;//\DiamonddotRight
	case 0x8F:p("<mo>");p(ul2utf8(0x21D0));p(ul2utf8(0x27D0));p("</mo>");break;//\DiamonddotLeft

	case 0x90:pMathType=mo;pmt(0x27D0);break;//\Diamonddot
	case 0x91:p("<mo>");p(ul2utf8(0x25CB));p(ul2utf8(0x2192));p("</mo>");break;//\circleright
	case 0x92:p("<mo>");p(ul2utf8(0x2190));p(ul2utf8(0x25CB));p("</mo>");break;//\circleleft
	case 0x93:p("<mo>");p(ul2utf8(0x2299));p(ul2utf8(0x2192));p("</mo>");break;//\circledotright
	case 0x94:p("<mo>");p(ul2utf8(0x2190));p(ul2utf8(0x2299));p("</mo>");break;//\circledotleft
	case 0x95:pMathType=mo;pmt(0x2639);break;//XXX not found in Unicode 4.1,\multimapbothvert
	case 0x96:pMathType=mo;pmt(0x2639);break;//XXX not found in Unicode 4.1,\multimapdotbothvert
	case 0x97:pMathType=mo;pmt(0x2639);break;//XXX not found in Unicode 4.1,\multimapdotbothBvert
	case 0x98:pMathType=mo;pmt(0x2639);break;//XXX not found in Unicode 4.1,\multimapdotbothAvert
	default:pMathType=mo;pmt(*temp);
	}
	temp++;
}while(*temp);
return;
}

void fontMapCmTeX(){
//cmtex
unsigned char* temp=(unsigned char*)yytext;
	do{
		switch(*temp){
		case 0x00:pMathType=mo;pmt(0x00B7);break;//center dot
		case 0x01:pMathType=mo;pmt(0x2193);break;//downwards arrow
		case 0x02:pMathType=mi;pmt(0x0381);break;//alpha
		case 0x03:pMathType=mi;pmt(0x0382);break;//beta
		case 0x04:pMathType=mo;pmt(0x2227);break;//logical and
		case 0x05:pMathType=mo;pmt(0x00AC);break;//not sign
		case 0x06:pMathType=mo;pmt(0x2208);break;//element of
		case 0x07:pMathType=mi;pmt(0x03C0);break;//pi
		case 0x08:pMathType=mi;pmt(0x03BB);break;//lambda
		case 0x09:pMathType=mi;pmt(0x03B3);break;//gamma
		case 0x0A:pMathType=mi;pmt(0x03B4);break;//delta
		case 0x0B:pMathType=mo;pmt(0x2191);break;//upwards arrow
		case 0x0C:pMathType=mo;pmt(0x00B1);break;//plus-minus
		case 0x0D:pMathType=mo;pmt(0x2295);break;//circled plus,\oplus
		case 0x0E:pMathType=mn;pmt(0x221E);break;//infinity
		case 0x0F:pMathType=mo;pmt(0x2202);break;//partial differential

		case 0x10:pMathType=mo;pmt(0x2282);break;//subset of
		case 0x11:pMathType=mo;pmt(0x2283);break;//superset of
		case 0x12:pMathType=mo;pmt(0x2229);break;//intersection
		case 0x13:pMathType=mo;pmt(0x222A);break;//union
		case 0x14:pMathType=mo;pmt(0x2200);break;//for all
		case 0x15:pMathType=mo;pmt(0x2203);break;//there exists
		case 0x16:pMathType=mo;pmt(0x2297);break;//circled times,\otimes
		case 0x17:pMathType=mo;pmt(0x21C6);break;//left arrow over right arrow
		case 0x18:pMathType=mo;pmt(0x2190);break;//left arrow
		case 0x19:pMathType=mo;pmt(0x2192);break;//right arrow
		case 0x1A:pMathType=mo;pmt(0x2260);break;//not equal
		case 0x1B:pMathType=mo;pmt(0x25CA);break;//lozenge
		case 0x1C:pMathType=mo;pmt(0x2264);break;//less than or equal
		case 0x1D:pMathType=mo;pmt(0x2265);break;//greater than or equal
		case 0x1E:pMathType=mo;pmt(0x2261);break;//identical to
		case 0x1F:pMathType=mo;pmt(0x2228);break;//logical or

		case 0x20:break;//XXX:space?,nothing
		case 0x21:pMathType=mo;pmt(*temp);break;//right double quotation mark
		case 0x22:pMathType=mo;pmt(0x201D);break;//right double quotation mark
		case 0x23:pMathType=mo;pmt(*temp);break;//sharp
		case 0x24:pMathType=mo;pmt(*temp);break;//$
		case 0x25:pMathType=mo;pmt(*temp);break;//%
		case 0x26:
				if (mathmode && !mathText){
					p("<mo>&amp;</mo>");
				}else 
					p("&amp;");
			break;//ampersand
		case 0x27:pMathType=mo;pmt(*temp);break;//'
		case 0x28:pMathType=mo;pmt(*temp);break;//(
		case 0x29:pMathType=mo;pmt(*temp);break;//)
		case 0x2A:
		case 0x2B:
		case 0x2C:inhibitspace=0;pMathType=mo;pmt(*temp);break;
		case 0x2D:
		case 0x2E:
		case 0x2F:pMathType=mo;pmt(*temp);break;
		case 0x30:
		case 0x31:
		case 0x32:
		case 0x33:
		case 0x34:
		case 0x35:
		case 0x36:
		case 0x37:
		case 0x38:
		case 0x39:pMathType=mn;pmt(*temp);break;
		case 0x3A:
		case 0x3B:pMathType=mo;pmt(*temp);break;
		case 0x3C:pMathType=mo;pmt(0x2039);break;//angle quotation
		case 0x3D:pMathType=mo;//equal
			precomposedNegative(*temp, 0x2260);
			break;
		case 0x3E:pMathType=mo;pmt(0x203A);break;//angle quotation
		case 0x3F:pMathType=mo;pmt(*temp);break;//question sign
		case 0x40:pMathType=mo;pmt(*temp);break;//at sign

		case 0x5B:pMathType=mo;pmt(*temp);break;//left bracket
		case 0x5C:pMathType=mo;pmt(*temp);break;//left double quotation mark
		case 0x5D:pMathType=mo;pmt(*temp);break;//right bracket
		case 0x5E:pMathType=mo;pmt(*temp);break;//^
		case 0x5F:pMathType=mo;pmt(*temp);break;//dot above

		case 0x60:pMathType=mo;pmt(*temp);break;//`

		case 0x7B:pMathType=mo;pmt(*temp);break;//left brace
		case 0x7C:pMathType=mo;pmt(*temp);break;//vertical bar
		case 0x7D:pMathType=mo;pmt(*temp);break;//right brace
		case 0x7E:pMathType=mo;pmt(*temp);break;//tilde
		case 0x7F:pMathType=mo;pmt(0x222B);break;//integral sign
		default:pMathType=mo;pmt(*temp);
		}
		temp++;
	}while(*temp);
	return;
}


void fontMapLasy(){
unsigned char* temp=(unsigned char*)yytext;
do{
	switch(*temp){
	//nothing here
	case 0x01:pMathType=mo;pmt(0x22B2);break;//normal subgroup of
	case 0x02:pMathType=mo;pmt(0x22B4);break;//normal subgroup of or equal to
	case 0x03:pMathType=mo;pmt(0x22B3);break;//contains as normal subgroup
	case 0x04:pMathType=mo;pmt(0x22B5);break;//contains as normal subgroup or equal to
	//nothing here
	case 0x28:pMathType=mo;pmt(0x227A);break;//precedes
	case 0x29:pMathType=mo;pmt(0x227B);break;//succeeds
	case 0x2A:pMathType=mo;pmt(0x22CF);break;//curly logical and
	case 0x2B:pMathType=mo;pmt(0x22CE);break;//curly logical or
	//nothing here
	
	case 0x30:pMathType=mo;pmt(0x2127);break;//inverted ohm greek omega
	case 0x31:pMathType=mo;pmt(0x22C8);break;//bowtie
	case 0x32:pMathType=mo;pmt(0x25A1);break;//white square
	case 0x33:pMathType=mo;pmt(0x25C7);break;//white diamond
	//nothing here
	
	case 0x3A:break;//XXX,extension to a squiggle arrow
	case 0x3B:pMathType=mo;pmt(0x21DD);break;//right squiggle arrow
	case 0x3C:pMathType=mo;pmt(0x228F);break;//square image of
	case 0x3D:pMathType=mo;pmt(0x2290);break;//square original of
	}
	temp++;
}while(*temp);
return;
}

void fontMapWasy(){
//wasy[b]
unsigned char* temp=(unsigned char*)yytext;
do{
	switch(*temp){
	case 0x00:pMathType=mo;pmt(0x25B3);break;//up-triangle white
	case 0x01:pMathType=mo;pmt(0x22B2);break;//normal subgroup of
	case 0x02:pMathType=mo;pmt(0x22B4);break;//normal subgroup of or equal to
	case 0x03:pMathType=mo;pmt(0x22B3);break;//contains as normal subgroup
	case 0x04:pMathType=mo;pmt(0x22B5);break;//contains as normal subgroup or equal to
	case 0x05:pMathType=mo;pmt(0x2234);break;//therefore
	case 0x06:pMathType=mo;pmt(0x2315);break;//recorder
	case 0x07:pMathType=mo;pmt(0x260E);break;//black telephone
	case 0x08:pMathType=mo;pmt(0x2713);break;//check mark
	case 0x09:pMathType=mo;pmt(0x27AA);break;//right \pointer
	case 0x0A:pMathType=mo;pmt(0x237E);break;//\bell
	case 0x0B:pMathType=mo;pmt(0x266A);break;//\eighthnote
	case 0x0C:pMathType=mo;pmt(0x2669);break;//\quarternote
	case 0x0D:pMathType=mo;pmt(0x1D15E);break;//\halfnote
	case 0x0E:pMathType=mo;pmt(0x1D15D);break;//\fullnote musical
	case 0x0F:pMathType=mo;pmt(0x266B);break;//\twonotes, beamed eigththnotes
	
	case 0x10:pMathType=mo;pmt(0x25C0);break;//left-triangle black
	case 0x11:pMathType=mo;pmt(0x25B6);break;//right-triangle black
	case 0x12:pMathType=mo;pmt(0x2607);break;//lightning
	case 0x13:pMathType=mo;pmt(0x260A);break;//ascending note
	case 0x14:pMathType=mo;pmt(0x260B);break;//descending note
	case 0x15:pMathType=mo;pmt(0x2349);break;//APL\invdiameter
	case 0x16:pMathType=mo;pmt(0x235F);break;//XXX?,circle star, \APLlog
	case 0x17:pMathType=mo;pmt(0x2648);break;//\vernal, XXX is it \aries?
	case 0x18:pMathType=mo;pmt(0x2310);break;//reversed not, \invneg
	case 0x19:pMathType=mo;pmt(0x2640);break;//\venus
	case 0x1A:pMathType=mo;pmt(0x2642);break;//male sign, \mars
	case 0x1B:pMathType=mo;pmt(0x00A4);break;//\currency
	case 0x1C:pMathType=mo;pmt(0x231A);break;//\clock
	case 0x1D:pMathType=mo;pmt(0x221D);break;//\propto
	case 0x1E:pMathType=mo;pmt(0x2222);break;//\varangle
	case 0x1F:pMathType=mo;pmt(0x2300);break;//\diameter
	
	case 0x20:pMathType=mo;pmt(0x26AB);break;//black circle
	case 0x21:pMathType=mo;pmt(0x27F3);break;//\rightturn
	case 0x22:pMathType=mo;pmt(0x27F2);break;//\leftturn
	case 0x23:pMathType=mo;pmt(0x26AC);break;//white circle
	case 0x24:pMathType=mo;pmt(0x263E);break;//\leftmoon
	case 0x25:pMathType=mo;pmt(0x263D);break;//\rightmoon
	case 0x26:pMathType=mo;pmt(0x2641);break;//\earth
	case 0x27:pMathType=mo;pmt(0x263F);break;//\mercury
	case 0x28:pMathType=mo;pmt(0x2039);break;//left quot angle
	case 0x29:pMathType=mo;pmt(0x203A);break;//right quot angle
	case 0x2A:pMathType=mo;pmt(0x2303);break;//up arrowhead
	case 0x2B:pMathType=mo;pmt(0x2304);break;//down arrowhead
	case 0x2C:pMathType=mo;pmt(0x263A);break;//\whitesmiley
	case 0x2D:pMathType=mo;pmt(0x263B);break;//\blacksmiley
	case 0x2E:pMathType=mo;pmt(0x263C);break;//\sun
	case 0x2F:pMathType=mo;pmt(0x2639);break;//\frownie
	
	case 0x30:pMathType=mo;pmt(0x2127);break;//inverted ohm sign
	case 0x31:pMathType=mo;pmt(0x22C8);break;//\Bowtie
	case 0x32:pMathType=mo;pmt(0x2395);break;//\APLbox
	case 0x33:pMathType=mo;pmt(0x25C7);break;//\Diamond
	case 0x34:pMathType=mo;pmt(0x2612);break;//\XBox
	case 0x35:pMathType=mo;pmt(0x25CA);break;//\lozenge
	case 0x36:pMathType=mo;pmt(0x2720);break;//maltese cross, \kreuz
	case 0x37:pMathType=mo;pmt(0x2394);break;//software function, \hexagon
	case 0x38:pMathType=mo;pmt(0x2639);break;//XXX :( not found in Unicode 4.1,\octagon
	case 0x39:pMathType=mo;pmt(0x232C);break;//XXX?,benzene,\varhexagon
	case 0x3A:pMathType=mo;pmt(0x223C);break;//APL tilde,\APLnot
	case 0x3B:pMathType=mo;pmt(0x219D);break;//rightwards wave arrow
	case 0x3C:pMathType=mo;pmt(0x228F);break;//square image of
	case 0x3D:pMathType=mo;pmt(0x2290);break;//square original of
	case 0x3E:pMathType=mo;pmt(0x2272);break;//less-than or equivalent to
	case 0x3F:pMathType=mo;pmt(0x2273);break;//greater-than or equivalent to
	
	case 0x40:pMathType=mo;pmt(0x224B);break;//triple tilde
	case 0x41:pMathType=mo;pmt(0x2217);break;//XXX,asterisk operator,\hexstar
	case 0x42:pMathType=mo;pmt(0x2217);break;//XXX not in Unicode4.1,asterisk operator,\varhexstar
	case 0x43:pMathType=mo;pmt(0x2721);break;//\davidsstar
	case 0x44:pMathType=mo;pmt(0x2639);break;//XXX :( not found in Unicode 4.1,\pentagon
	case 0x45:pMathType=mo;pmt(0x2639);break;//XXX :( not found in Unicode 4.1,\APLstar
	case 0x46:pMathType=mo;pmt(0x25BD);break;//\APL down, white triangle down 
	case 0x47:pMathType=mo;pmt(0x25D6);break;//left half black circle,\leftcircle
	case 0x48:pMathType=mo;pmt(0x25D7);break;//right half black circle,\rightcircle
	case 0x49:pMathType=mo;pmt(0x25D6);break;//XXX: should be white, left half black circle,\leftcircle
	case 0x4A:pMathType=mo;pmt(0x25D7);break;//XXX: should be white, right half black circle,\rightcircle
	case 0x4B:pMathType=mo;pmt(0x25B2);break;//black up triangle, \UParrow
	case 0x4C:pMathType=mo;pmt(0x25BC);break;//black down triangle, \DOWNarrow
	case 0x4D:
	case 0x4E:
	case 0x4F:break;//nothing

	case 0x50:pMathType=mo;pmt(0x2639);break;//XXX:not found in U4.1,\gluonelement
	case 0x51:pMathType=mo;pmt(0x2639);break;//XXX:not found in U4.1,\gluonbelement
	case 0x52:pMathType=mo;pmt(0x2639);break;//XXX:not found in U4.1,\gluoneelement
	case 0x53:
	case 0x54:break;//nothing
	case 0x55:pMathType=mo;pmt(0x01DD);break;//small letter turned e, \inve
	case 0x56:pMathType=mo;pmt(0x260C);break;//conjunction
	case 0x57:pMathType=mo;pmt(0x260D);break;//opposition
	case 0x58:pMathType=mo;pmt(0x2643);break;//jupiter
	case 0x59:pMathType=mo;pmt(0x2644);break;//saturn
	case 0x5A:pMathType=mo;pmt(0x2645);break;//uranus
	case 0x5B:pMathType=mo;pmt(0x2646);break;//neptune
	case 0x5C:pMathType=mo;pmt(0x2647);break;//pluto
	case 0x5D:pMathType=mo;pmt(0x2649);break;//taurus
	case 0x5E:pMathType=mo;pmt(0x264A);break;//gemini
	case 0x5F:pMathType=mo;pmt(0x264B);break;//cancer

	case 0x60:pMathType=mo;pmt(0x264D);break;//virgo
	case 0x61:pMathType=mo;pmt(0x264E);break;//libra
	case 0x62:pMathType=mo;pmt(0x264F);break;//scorpius
	case 0x63:pMathType=mo;pmt(0x2650);break;//saggitarius
	case 0x64:pMathType=mo;pmt(0x2651);break;//capricorn
	case 0x65:pMathType=mo;pmt(0x2652);break;//aquarius
	case 0x66:pMathType=mo;pmt(0x2653);break;//pisces
	case 0x67:pMathType=mo;pmt(0x00A2);break;//cent sign
	case 0x68:pMathType=mo;pmt(0x2030);break;//\permil
	case 0x69:pMathType=mo;pmt(0x00FE);break;//\thorn
	case 0x6A:pMathType=mo;pmt(0x00DE);break;//\THORN
	case 0x6B:pMathType=mo;pmt(0x00F0);break;//eth, \dh
	case 0x6C:pMathType=mo;pmt(0x0254);break;//\openo
	case 0x6D:pMathType=mo;pmt(0x2639);break;//XXX:not found in U4.1,\ataribox
	case 0x6E:pMathType=mo;pmt(0x2350);break;//\APLuparrowbox
	case 0x6F:pMathType=mo;pmt(0x2357);break;//\APLdownarrowbox

	case 0x70:pMathType=mo;pmt(0x2347);break;//\APLleftarrowbox
	case 0x71:pMathType=mo;pmt(0x2348);break;//\APLrightarrowbox
	case 0x72:pMathType=mo;pmt(0x222B);break;//integral, \int
	case 0x73:pMathType=mo;pmt(0x222C);break;//\iint
	case 0x74:pMathType=mo;pmt(0x222D);break;//\iiint
	case 0x75:pMathType=mo;pmt(0x222E);break;//\oint
	case 0x76:pMathType=mo;pmt(0x222F);break;//\oiint
	case 0x77:pMathType=mo;pmt(0x222B);break;//integral, \int
	case 0x78:pMathType=mo;pmt(0x222C);break;//\iint
	case 0x79:pMathType=mo;pmt(0x222D);break;//\iiint
	case 0x7A:pMathType=mo;pmt(0x222E);break;//\oint
	case 0x7B:pMathType=mo;pmt(0x222F);break;//\oiint
	case 0x7C:pMathType=mo;pmt('|');break;//|
	case 0x7D:pMathType=mo;pmt(0x235E);break;//XXX:?, APL quote,\APLinput
	case 0x7E:pMathType=mo;pmt(0x2395);break;//APL quad,\APLbox
	case 0x7F:pMathType=mo;pmt(0x2639);break;//XXX:not found in U4.1,\APLcomment

	}
	temp++;
}while(*temp);
return;
}

void fontMap7c(){//eufm
unsigned char* temp=(unsigned char*)yytext;
int staticFontFamily;

	do{
		switch(*temp){
		case 0x00:pMathType=mo;
			staticFontFamily=theFont.family;
			theFont.family=fraktur;
			pmt(0x0076);
			theFont.family=staticFontFamily;
		break;//v, should be pmt(0x1D533),FIXME not sure
		case 0x01:pMathType=mo;
			staticFontFamily=theFont.family;
			theFont.family=fraktur;
			pmt(0x0064);
			theFont.family=staticFontFamily;
		break;//d, should be pmt(0x1D521),FIXME not sure
		case 0x02:pMathType=mo;
			staticFontFamily=theFont.family;
			theFont.family=fraktur;
			pmt(0x0066);
			theFont.family=staticFontFamily;
		break;//f, should be pmt(0x1D523),FIXME not sure
		case 0x03:pMathType=mo;
			staticFontFamily=theFont.family;
			theFont.family=fraktur;
			pmt(0x0066);
			theFont.family=staticFontFamily;
		break;//f, should be pmt(0x1D523),FIXME not sure
		case 0x04:pMathType=mo;
			staticFontFamily=theFont.family;
			theFont.family=fraktur;
			pmt(0x0067);
			theFont.family=staticFontFamily;
		break;//g, should be pmt(0x1D524),FIXME not sure
		case 0x05:pMathType=mo;
			staticFontFamily=theFont.family;
			theFont.family=fraktur;
			pmt(0x006B);
			theFont.family=staticFontFamily;
		break;//k, should be pmt(0x1D528),FIXME not sure
		case 0x06:pMathType=mo;
			staticFontFamily=theFont.family;
			theFont.family=fraktur;
			pmt(0x0074);
			theFont.family=staticFontFamily;
		break;//t, should be pmt(0x1D531),FIXME not sure
		case 0x07:pMathType=mo;
			staticFontFamily=theFont.family;
			theFont.family=fraktur;
			pmt(0x0075);
			theFont.family=staticFontFamily;
		break;//u, should be pmt(0x1D532),FIXME not sure
		
		//nothing
		
		case 0x12:pMathType=mo;pmt(0x2018);break;//leftquote
		case 0x13:pMathType=mo;pmt(0x2019);break;//rightquote
		
		//nothing
		
		case 0x21:pMathType=mo;pmt(*temp);break;//!
		
		//nothing
		
		case 0x26:
			if (mathmode && !mathText){
				p("<mo>&amp;</mo>");
			}else 
				p("&amp;");
			break;//ampersand
		case 0x27:
			if (mathmode && !mathText){
				p("<mo>&apos;</mo>");
			}else 
				p("&apos;");
			break;//single quote, apostrophe
		case 0x28:pMathType=mo;pmt(*temp);break;//(
		case 0x29:pMathType=mo;pmt(*temp);break;//)
		case 0x2A:
		case 0x2B:
		case 0x2C:inhibitspace=0;pMathType=mo;pmt(*temp);break;
		case 0x2D:
		case 0x2E:
		case 0x2F:pMathType=mo;pmt(*temp);break;

		case 0x30:
		case 0x31:
		case 0x32:
		case 0x33:
		case 0x34:
		case 0x35:
		case 0x36:
		case 0x37:
		case 0x38:
		case 0x39:pMathType=mn;pmt(*temp);break;
		case 0x3A:
		case 0x3B:pMathType=mo;pmt(*temp);break;//;
		//nothing
		case 0x3D:pMathType=mo; //equal
			precomposedNegative(*temp, 0x2260);
			break;
		//nothing
		case 0x3F:

		case 0x41:
		case 0x42:pMathType=mo;staticFontFamily=theFont.family;
			theFont.family=fraktur;pmt(*temp);
			theFont.family=staticFontFamily;
			break;
		case 0x43:pMathType=mo;pmt(0x212D);break;//fraktur C
		case 0x44:
		case 0x45:
		case 0x46:
		case 0x47:pMathType=mo;staticFontFamily=theFont.family;
			theFont.family=fraktur;pmt(*temp);
			theFont.family=staticFontFamily;
			break;
		case 0x48:pMathType=mo;pmt(0x210C);break;//fraktur H
		case 0x49:pMathType=mo;pmt(0x2111);break;//fraktur I
		case 0x4A:
		case 0x4B:
		case 0x4C:
		case 0x4D:
		case 0x4E:
		case 0x4F:

		case 0x50:
		case 0x51:pMathType=mo;staticFontFamily=theFont.family;
			theFont.family=fraktur;pmt(*temp);
			theFont.family=staticFontFamily;
			break;
		case 0x52:pMathType=mo;pmt(0x211C);break;//fraktur R
		case 0x53:
		case 0x54:
		case 0x55:
		case 0x56:
		case 0x57:
		case 0x58:
		case 0x59:pMathType=mo;staticFontFamily=theFont.family;
			theFont.family=fraktur;pmt(*temp);
			theFont.family=staticFontFamily;
			break;
		case 0x5A:pMathType=mo;pmt(0x2128);break;//fraktur Z

		case 0x5B:pMathType=mo;pmt(*temp);break;//[
		//nothing
		case 0x5D:pMathType=mo;pmt(*temp);break;//]
		case 0x5E:pMathType=mo;pmt(*temp);break;//^
		
		//nothing

		case 0x61:
		case 0x62:
		case 0x63:
		case 0x64:
		case 0x65:
		case 0x66:
		case 0x67:
		case 0x68:
		case 0x69:
		case 0x6A:
		case 0x6B:
		case 0x6C:
		case 0x6D:
		case 0x6E:
		case 0x6F:

		case 0x70:
		case 0x71:
		case 0x72:
		case 0x73:
		case 0x74:
		case 0x75:
		case 0x76:
		case 0x77:
		case 0x78:
		case 0x79:
		case 0x7A:pMathType=mo;staticFontFamily=theFont.family;
			theFont.family=fraktur;pmt(*temp);
			theFont.family=staticFontFamily;
			break;	//pmt(0x1D59F);break;//fraktur a-z
		//nothing
		case 0x7D:pMathType=mo;pmt(0x0022);break;//quotation mark, (XXX)
		//nothing

		}
		temp++;
	}while(*temp) ;
	return;
}

/* mappings to be integrated later

		if (strstr(currentFont,"eurm")){//identical to cmmi, but upright
		do{
			switch(*temp){
			case 0x00:pMathType=mo;pmt(0x0393);break;//Gamma
			case 0x01:pMathType=mo;pmt(0x0394);break;//Delta
			case 0x02:pMathType=mo;pmt(0x0398);break;//Theta
			case 0x03:pMathType=mo;pmt(0x039B);break;//Lambda
			case 0x04:pMathType=mo;pmt(0x039E);break;//Xi
			case 0x05:pMathType=mo;pmt(0x03A0);break;//Pi
			case 0x06:pMathType=mo;pmt(0x03A3);break;//Sigma
			case 0x07:pMathType=mo;pmt(0x03D2);break;//Upsilon with hook
			case 0x08:pMathType=mo;pmt(0x03A6);break;//Phi
			case 0x09:pMathType=mo;pmt(0x03A8);break;//Psi
			case 0x0A:pMathType=mo;pmt(0x03A9);break;//Omega
			case 0x0B:pMathType=mo;pmt(0x03B1);break;//alpha
			case 0x0C:pMathType=mo;pmt(0x03B2);break;//beta
			case 0x0D:pMathType=mo;pmt(0x03B3);break;//gamma
			case 0x0E:pMathType=mo;pmt(0x03B4);break;//delta
			case 0x0F:pMathType=mo;pmt(0x03B5);break;//epsilon

			case 0x10:pMathType=mo;pmt(0x03B6);break;//zeta
			case 0x11:pMathType=mo;pmt(0x03B7);break;//eta
			case 0x12:pMathType=mo;pmt(0x03B8);break;//theta
			case 0x13:pMathType=mo;pmt(0x03B9);break;//iota
			case 0x14:pMathType=mo;pmt(0x03BA);break;//kappa
			case 0x15:pMathType=mo;pmt(0x03BB);break;//lambda
			case 0x16:pMathType=mo;pmt(0x03BC);break;//mu
			case 0x17:pMathType=mo;pmt(0x03BD);break;//nu
			case 0x18:pMathType=mo;pmt(0x03BE);break;//xi
			case 0x19:pMathType=mo;pmt(0x03C0);break;//pi
			case 0x1A:pMathType=mo;pmt(0x03C1);break;//ro
			case 0x1B:pMathType=mo;pmt(0x03C3);break;//sigma
			case 0x1C:pMathType=mo;pmt(0x03C4);break;//tau
			case 0x1D:pMathType=mo;pmt(0x03C5);break;//upsilon
			case 0x1E:pMathType=mo;pmt(0x03C6);break;//phi
			case 0x1F:pMathType=mo;pmt(0x03C7);break;//chi

			case 0x20:pMathType=mo;pmt(0x03C8);break;//psi
			case 0x21:pMathType=mo;pmt(0x03C9);break;//omega
			case 0x22:pMathType=mo;pmt(0x025B);break;//latin epsilon
			case 0x23:pMathType=mo;pmt(0x03D1);break;//script theta
			case 0x24:pMathType=mo;pmt(0x03D6);break;//varpi

			//nothing here

			case 0x30:
			case 0x31:
			case 0x32:
			case 0x33:
			case 0x34:
			case 0x35:
			case 0x36:
			case 0x37:
			case 0x38:
			case 0x39:pMathType=mn;pmt(*temp);break;//digits
			case 0x3A:pMathType=mo;pmt(0x002E);break;//dot
			case 0x3B:pMathType=mo;pmt(0x002C);break;//comma
			case 0x3C://less than
				if(combiningUnicode==0x0338) { 
					combiningUnicode=0;
					pmt(0x226F);
				}	else	p("<mo mathvariant=\"normal\">&lt;</mo>");
				break;
			case 0x3D:pMathType=mo;pmt(0x002F);break;//division
			case 0x3E: //greater than
				if(combiningUnicode==0x0338) { 
					combiningUnicode=0;
					pmt(0x226F);
				}	else	p("<mo mathvariant=\"normal\">&gt;</mo>");
				break;
			//nothing here
			
			case 0x40:pMathType=mo;pmt(0x2202);break;//partial diff

			//nothing here

			case 0x60:pMathType=mo;pmt(0x2113);break;//ell script

			case 0x7B:pMathType=mo;pmt(0x0131);break;//imath
			case 0x7C:pMathType=mo;pmt(0x006A);break;//jmath,pmt(0x0237);break;//jmath
			case 0x7D:pMathType=mos;pmt('P');break;//pMathType=mo;pmt(0x2188);break;//script capital P
			//nothing here
			
			default:pMathType=mo;pmt(*temp);
			}
			temp++;
		}while(*temp);
		return;
	}

	
	if (strstr(currentFont,"wncyr")){//cyrillic
		do{
			switch(*temp){
			case 0x00:pMathType=mo;pmt(0x040A);break;//NJE
			case 0x01:pMathType=mo;pmt(0x0409);break;//LJE
			case 0x02:pMathType=mo;pmt(0x040F);break;//DZHE
			case 0x03:pMathType=mo;pmt(0x042D);break;//E
			case 0x04:pMathType=mo;pmt(0x0406);break;//I
			case 0x05:pMathType=mo;pmt(0x0404);break;//Ukrainian IE
			case 0x06:pMathType=mo;pmt(0x0402);break;//DJE
			case 0x07:pMathType=mo;pmt(0x040B);break;//TSHE
			case 0x08:pMathType=mo;pmt(0x045A);break;//nje
			case 0x09:pMathType=mo;pmt(0x0459);break;//lje
			case 0x0A:pMathType=mo;pmt(0x045F);break;//dzhe
			case 0x0B:pMathType=mo;pmt(0x044D);break;//e
			case 0x0C:pMathType=mo;pmt(0x0456);break;//i
			case 0x0D:pMathType=mo;pmt(0x0454);break;//ukrainian ie
			case 0x0E:pMathType=mo;pmt(0x0452);break;//dje
			case 0x0F:pMathType=mo;pmt(0x045B);break;//tshe

			case 0x10:pMathType=mo;pmt(0x042E);break;//YU
			case 0x11:pMathType=mo;pmt(0x0416);break;//ZHE
			case 0x12:pMathType=mo;pmt(0x0419);break;//short I
			case 0x13:pMathType=mo;pmt(0x0401);break;//IO
			case 0x14:pMathType=mo;pmt(0x0474);break;//IZHITSA
			case 0x15:pMathType=mo;pmt(0x0472);break;//FITA
			case 0x16:pMathType=mo;pmt(0x0405);break;//DZE
			case 0x17:pMathType=mo;pmt(0x042F);break;//YA
			case 0x18:pMathType=mo;pmt(0x044E);break;//yu
			case 0x19:pMathType=mo;pmt(0x0436);break;//zhe
			case 0x1A:pMathType=mo;pmt(0x0439);break;//short i
			case 0x1B:pMathType=mo;pmt(0x0451);break;//io
			case 0x1C:pMathType=mo;pmt(0x0475);break;//izhitsa
			case 0x1D:pMathType=mo;pmt(0x0473);break;//fita
			case 0x1E:pMathType=mo;pmt(0x0455);break;//dze
			case 0x1F:pMathType=mo;pmt(0x044F);break;//ya

			case 0x20:pMathType=mo;pmt(0x00A8);break;//diaeresis
			case 0x21:pMathType=mo;pmt(*temp);break;//!
			case 0x22:pMathType=mo;pmt(0x201D);break;//right double quotation mark
			case 0x23:pMathType=mo;pmt(0x0462);break;//YAT
			case 0x24:pMathType=mo;pmt(0x02D8);break;//breve XXX should be breve1
			case 0x25:pMathType=mo;pmt(*temp);break;//%
			case 0x26:pMathType=mo;pmt(0x00B4);break;//acute 
			case 0x27:pMathType=mo;pmt(0x2019);break;//quoteright
			case 0x28:pMathType=mo;pmt(*temp);break;//(
			case 0x29:pMathType=mo;pmt(*temp);break;//)
			case 0x2A:pMathType=mo;pmt(*temp);break;//ascii multiplication
			case 0x2B:pMathType=mo;pmt(0x0463);break;//yat
			case 0x2C:inhibitspace=0;pMathType=mo;pmt(*temp);break;
			case 0x2D://-
			case 0x2E://.
			case 0x2F:pMathType=mo;pmt(*temp);break;//slash

			case 0x30:
			case 0x31:
			case 0x32:
			case 0x33:
			case 0x34:
			case 0x35:
			case 0x36:
			case 0x37:
			case 0x38:
			case 0x39:pMathType=mn;pmt(*temp);break;//arabic numerals
			case 0x3A:pMathType=mo;pmt(*temp);break;//:
			case 0x3B:pMathType=mo;pmt(*temp);break;//;
			case 0x3C:pMathType=mo;pmt(0x00AB);break;//guillemet left 
			case 0x3D:pMathType=mo;pmt(0x0131);break;//imath
			case 0x3E:pMathType=mo;pmt(0x00BB);break;//guillemet right 
			case 0x3F:pMathType=mo;pmt(*temp);break;//?

			case 0x40:pMathType=mo;pmt(0x02D8);break;//breve 
			case 0x41:pMathType=mo;pmt(0x0410);break;//A
			case 0x42:pMathType=mo;pmt(0x0411);break;//BE
			case 0x43:pMathType=mo;pmt(0x0426);break;//TSE
			case 0x44:pMathType=mo;pmt(0x0414);break;//DE
			case 0x45:pMathType=mo;pmt(0x0415);break;//IE
			case 0x46:pMathType=mo;pmt(0x0424);break;//EF
			case 0x47:pMathType=mo;pmt(0x0413);break;//GHE
			case 0x48:pMathType=mo;pmt(0x0425);break;//HA
			case 0x49:pMathType=mo;pmt(0x0418);break;//I
			case 0x4A:pMathType=mo;pmt(0x0408);break;//JE
			case 0x4B:pMathType=mo;pmt(0x041A);break;//KA
			case 0x4C:pMathType=mo;pmt(0x041B);break;//EL
			case 0x4D:pMathType=mo;pmt(0x041C);break;//EM
			case 0x4E:pMathType=mo;pmt(0x041D);break;//EN
			case 0x4F:pMathType=mo;pmt(0x041E);break;//O

			case 0x50:pMathType=mo;pmt(0x041F);break;//PE
			case 0x51:pMathType=mo;pmt(0x0427);break;//CHE
			case 0x52:pMathType=mo;pmt(0x0420);break;//ER
			case 0x53:pMathType=mo;pmt(0x0421);break;//ES
			case 0x54:pMathType=mo;pmt(0x0422);break;//TE
			case 0x55:pMathType=mo;pmt(0x0423);break;//U
			case 0x56:pMathType=mo;pmt(0x0412);break;//VE
			case 0x57:pMathType=mo;pmt(0x0429);break;//SHCHA
			case 0x58:pMathType=mo;pmt(0x0428);break;//SHA
			case 0x59:pMathType=mo;pmt(0x042B);break;//YERU
			case 0x5A:pMathType=mo;pmt(0x0417);break;//ZE
			
			case 0x5B:pMathType=mo;pmt(*temp);break;//left bracket
			case 0x5C:pMathType=mo;pmt(0x201C);break;//left double quotation mark
			case 0x5D:pMathType=mo;pmt(*temp);break;//right bracket
			case 0x5E:pMathType=mo;pmt(0x044C);break;//soft sign
			case 0x5F:pMathType=mo;pmt(0x044A);break;//hard sign

			case 0x60:pMathType=mo;pmt(*temp);break;//`
			case 0x61:pMathType=mo;pmt(0x0430);break;//a 
			case 0x62:pMathType=mo;pmt(0x0431);break;//be
			case 0x63:pMathType=mo;pmt(0x0446);break;//tse
			case 0x64:pMathType=mo;pmt(0x0434);break;//de
			case 0x65:pMathType=mo;pmt(0x0435);break;//ie
			case 0x66:pMathType=mo;pmt(0x0444);break;//ef
			case 0x67:pMathType=mo;pmt(0x0433);break;//ghe
			case 0x68:pMathType=mo;pmt(0x0445);break;//ha
			case 0x69:pMathType=mo;pmt(0x0438);break;//i
			case 0x6A:pMathType=mo;pmt(0x0458);break;//je
			case 0x6B:pMathType=mo;pmt(0x043A);break;//ka
			case 0x6C:pMathType=mo;pmt(0x043B);break;//el
			case 0x6D:pMathType=mo;pmt(0x043C);break;//em
			case 0x6E:pMathType=mo;pmt(0x043D);break;//en
			case 0x6F:pMathType=mo;pmt(0x043E);break;//o
			case 0x70:pMathType=mo;pmt(0x043F);break;//pe
			case 0x71:pMathType=mo;pmt(0x0447);break;//che
			case 0x72:pMathType=mo;pmt(0x0440);break;//er
			case 0x73:pMathType=mo;pmt(0x0441);break;//es
			case 0x74:pMathType=mo;pmt(0x0442);break;//te
			case 0x75:pMathType=mo;pmt(0x0443);break;//u
			case 0x76:pMathType=mo;pmt(0x0432);break;//ve
			case 0x77:pMathType=mo;pmt(0x0449);break;//shcha
			case 0x78:pMathType=mo;pmt(0x0448);break;//sha
			case 0x79:pMathType=mo;pmt(0x044B);break;//yeru
			case 0x7A:pMathType=mo;pmt(0x0437);break;//ze
			
			case 0x7B:pMathType=mo;pmt(0x2013);break;//en dash
			case 0x7C:pMathType=mo;pmt(0x2014);break;//em dash
			case 0x7D:pMathType=mo;pmt(0x2116);break;//numero sign
			case 0x7E:pMathType=mo;pmt(0x044C);break;//soft
			case 0x7F:pMathType=mo;pmt(0x044A);break;//hard
			default:pMathType=mo;pmt(*temp);
			}
			temp++;
		}while(*temp);
		return;
	}

	if (strstr(currentFont,"wncyi")){//cyrillic
		do{
			switch(*temp){
			case 0x00:pMathType=mi;pmt(0x040A);break;//NJE
			case 0x01:pMathType=mi;pmt(0x0409);break;//LJE
			case 0x02:pMathType=mi;pmt(0x040F);break;//DZHE
			case 0x03:pMathType=mi;pmt(0x042D);break;//E
			case 0x04:pMathType=mi;pmt(0x0406);break;//I
			case 0x05:pMathType=mi;pmt(0x0404);break;//Ukrainian IE
			case 0x06:pMathType=mi;pmt(0x0402);break;//DJE
			case 0x07:pMathType=mi;pmt(0x040B);break;//TSHE
			case 0x08:pMathType=mi;pmt(0x045A);break;//nje
			case 0x09:pMathType=mi;pmt(0x0459);break;//lje
			case 0x0A:pMathType=mi;pmt(0x045F);break;//dzhe
			case 0x0B:pMathType=mi;pmt(0x044D);break;//e
			case 0x0C:pMathType=mi;pmt(0x0456);break;//i
			case 0x0D:pMathType=mi;pmt(0x0454);break;//ukrainian ie
			case 0x0E:pMathType=mi;pmt(0x0452);break;//dje
			case 0x0F:pMathType=mi;pmt(0x045B);break;//tshe

			case 0x10:pMathType=mi;pmt(0x042E);break;//YU
			case 0x11:pMathType=mi;pmt(0x0416);break;//ZHE
			case 0x12:pMathType=mi;pmt(0x0419);break;//short I
			case 0x13:pMathType=mi;pmt(0x0401);break;//IO
			case 0x14:pMathType=mi;pmt(0x0474);break;//IZHITSA
			case 0x15:pMathType=mi;pmt(0x0472);break;//FITA
			case 0x16:pMathType=mi;pmt(0x0405);break;//DZE
			case 0x17:pMathType=mi;pmt(0x042F);break;//YA
			case 0x18:pMathType=mi;pmt(0x044E);break;//yu
			case 0x19:pMathType=mi;pmt(0x0436);break;//zhe
			case 0x1A:pMathType=mi;pmt(0x0439);break;//short i
			case 0x1B:pMathType=mi;pmt(0x0451);break;//io
			case 0x1C:pMathType=mi;pmt(0x0475);break;//izhitsa
			case 0x1D:pMathType=mi;pmt(0x0473);break;//fita
			case 0x1E:pMathType=mi;pmt(0x0455);break;//dze
			case 0x1F:pMathType=mi;pmt(0x044F);break;//ya

			case 0x20:pMathType=moi;pmt(0x00A8);break;//diaeresis
			case 0x21:pMathType=moi;pmt(*temp);break;//!
			case 0x22:pMathType=moi;pmt(0x201D);break;//right double quotation mark
			case 0x23:pMathType=mi;pmt(0x0462);break;//YAT
			case 0x24:pMathType=moi;pmt(0x02D8);break;//breve XXX should be breve1
			case 0x25:pMathType=moi;pmt(*temp);break;//%
			case 0x26:pMathType=moi;pmt(0x00B4);break;//acute 
			case 0x27:pMathType=moi;pmt(0x2019);break;//quoteright
			case 0x28:pMathType=ldi;pmt(*temp);break;//(
			case 0x29:pMathType=rdi;pmt(*temp);break;//)
			case 0x2A:pMathType=moi;pmt(*temp);break;//ascii multiplication sign
			case 0x2B:pMathType=mi;pmt(0x0463);break;//yat
			case 0x2C:inhibitspace=0;pMathType=moi;pmt(*temp);break;
			case 0x2D://-
			case 0x2E://.
			case 0x2F:pMathType=moi;pmt(*temp);break;//slash

			case 0x30:
			case 0x31:
			case 0x32:
			case 0x33:
			case 0x34:
			case 0x35:
			case 0x36:
			case 0x37:
			case 0x38:
			case 0x39:pMathType=mni;pmt(*temp);break;//arabic numerals
			case 0x3A:pMathType=moi;pmt(*temp);break;//:
			case 0x3B:pMathType=moi;pmt(*temp);break;//;
			case 0x3C:pMathType=moi;pmt(0x00AB);break;//guillemet left 
			case 0x3D:pMathType=moi;pmt(0x0131);break;//imath
			case 0x3E:pMathType=moi;pmt(0x00BB);break;//guillemet right 
			case 0x3F:pMathType=moi;pmt(*temp);break;//?

			case 0x40:pMathType=moi;pmt(0x02D8);break;//breve 
			case 0x41:pMathType=mi;pmt(0x0410);break;//A
			case 0x42:pMathType=mi;pmt(0x0411);break;//BE
			case 0x43:pMathType=mi;pmt(0x0426);break;//TSE
			case 0x44:pMathType=mi;pmt(0x0414);break;//DE
			case 0x45:pMathType=mi;pmt(0x0415);break;//IE
			case 0x46:pMathType=mi;pmt(0x0424);break;//EF
			case 0x47:pMathType=mi;pmt(0x0413);break;//GHE
			case 0x48:pMathType=mi;pmt(0x0425);break;//HA
			case 0x49:pMathType=mi;pmt(0x0418);break;//I
			case 0x4A:pMathType=mi;pmt(0x0408);break;//JE
			case 0x4B:pMathType=mi;pmt(0x041A);break;//KA
			case 0x4C:pMathType=mi;pmt(0x041B);break;//EL
			case 0x4D:pMathType=mi;pmt(0x041C);break;//EM
			case 0x4E:pMathType=mi;pmt(0x041D);break;//EN
			case 0x4F:pMathType=mi;pmt(0x041E);break;//O

			case 0x50:pMathType=mi;pmt(0x041F);break;//PE
			case 0x51:pMathType=mi;pmt(0x0427);break;//CHE
			case 0x52:pMathType=mi;pmt(0x0420);break;//ER
			case 0x53:pMathType=mi;pmt(0x0421);break;//ES
			case 0x54:pMathType=mi;pmt(0x0422);break;//TE
			case 0x55:pMathType=mi;pmt(0x0423);break;//U
			case 0x56:pMathType=mi;pmt(0x0412);break;//VE
			case 0x57:pMathType=mi;pmt(0x0429);break;//SHCHA
			case 0x58:pMathType=mi;pmt(0x0428);break;//SHA
			case 0x59:pMathType=mi;pmt(0x042B);break;//YERU
			case 0x5A:pMathType=mi;pmt(0x0417);break;//ZE
			
			case 0x5B:pMathType=ldi;pmt(*temp);break;//left bracket
			case 0x5C:pMathType=ldi;pmt(0x201C);break;//left double quotation mark
			case 0x5D:pMathType=rdi;pmt(*temp);break;//right bracket
			case 0x5E:pMathType=moi;pmt(0x044C);break;//soft sign
			case 0x5F:pMathType=moi;pmt(0x044A);break;//hard sign

			case 0x60:pMathType=moi;pmt(*temp);break;//`
			case 0x61:pMathType=mi;pmt(0x0430);break;//a 
			case 0x62:pMathType=mi;pmt(0x0431);break;//be
			case 0x63:pMathType=mi;pmt(0x0446);break;//tse
			case 0x64:pMathType=mi;pmt(0x0434);break;//de
			case 0x65:pMathType=mi;pmt(0x0435);break;//ie
			case 0x66:pMathType=mi;pmt(0x0444);break;//ef
			case 0x67:pMathType=mi;pmt(0x0433);break;//ghe
			case 0x68:pMathType=mi;pmt(0x0445);break;//ha
			case 0x69:pMathType=mi;pmt(0x0438);break;//i
			case 0x6A:pMathType=mi;pmt(0x0458);break;//je
			case 0x6B:pMathType=mi;pmt(0x043A);break;//ka
			case 0x6C:pMathType=mi;pmt(0x043B);break;//el
			case 0x6D:pMathType=mi;pmt(0x043C);break;//em
			case 0x6E:pMathType=mi;pmt(0x043D);break;//en
			case 0x6F:pMathType=mi;pmt(0x043E);break;//o
			case 0x70:pMathType=mi;pmt(0x043F);break;//pe
			case 0x71:pMathType=mi;pmt(0x0447);break;//che
			case 0x72:pMathType=mi;pmt(0x0440);break;//er
			case 0x73:pMathType=mi;pmt(0x0441);break;//es
			case 0x74:pMathType=mi;pmt(0x0442);break;//te
			case 0x75:pMathType=mi;pmt(0x0443);break;//u
			case 0x76:pMathType=mi;pmt(0x0432);break;//ve
			case 0x77:pMathType=mi;pmt(0x0449);break;//shcha
			case 0x78:pMathType=mi;pmt(0x0448);break;//sha
			case 0x79:pMathType=mi;pmt(0x044B);break;//yeru
			case 0x7A:pMathType=mi;pmt(0x0437);break;//ze
			
			case 0x7B:pMathType=moi;pmt(0x2013);break;//en dash
			case 0x7C:pMathType=moi;pmt(0x2014);break;//em dash
			case 0x7D:pMathType=moi;pmt(0x2116);break;//numero sign
			case 0x7E:pMathType=moi;pmt(0x044C);break;//soft
			case 0x7F:pMathType=moi;pmt(0x044A);break;//hard
			default:pMathType=mi;pmt(*temp);
			}
			temp++;
		}while(*temp);
		return;
	}
			
	if (strstr(currentFont,"eusm")){
		do{
			switch(*temp){
			case 0x00:pMathType=mo;pmt('-');break;//-
			//nothing
			case 0x18:pMathType=mo;pmt(0x223C);break;//\sim
			//nothing
			case 0x3A:pMathType=mo;pmt(0x00AC);break;//\neg
			//nothing
			case 0x3C:pMathType=mo;pmt(0x211C);break;//real part
			case 0x3D:pMathType=mo;pmt(0x2111);break;//image part
			//nothing
			case 0x40:pMathType=mo;pmt(0x2135);break;//\aleph transfinite
			case 0x41:
			case 0x42:
			case 0x43:
			case 0x44:
			case 0x45:
			case 0x46:
			case 0x47:
			case 0x48:
			case 0x49:
			case 0x4A:
			case 0x4B:
			case 0x4C:
			case 0x4D:
			case 0x4E:
			case 0x4F:
			
			case 0x50:
			case 0x51:
			case 0x52:
			case 0x53:
			case 0x54:
			case 0x55:
			case 0x56:
			case 0x57:
			case 0x58:
			case 0x59:
			case 0x5A:pMathType=mos;pmt(*temp);break;//A-Z script, straight
			//nothing
			case 0x5E:pMathType=mos;pmt(0x2227);break;//and
			case 0x5F:pMathType=mos;pmt(0x2228);break;//or
			
			//nothing
			case 0x66:pMathType=lds;pmt('{');break;//{
			case 0x67:pMathType=rds;pmt('}');break;//}
			//nothing
			case 0x6A:pMathType=mos;pmt('|');break;//
			//nothing
			case 0x6E:pMathType=mos;pmt('\\');break;//
			//nothing
			case 0x78:pMathType=mos;pmt(0x00A7);break;//section sign
			
			}
			temp++;
		}while(*temp);
		return;
	}

	if (strstr(currentFont,"euex")){
		do{
			switch(*temp){
			//nothing
			case 0x08:pMathType=ld;pmt('{');break;//
			case 0x09:pMathType=rd;pmt('}');break;//
			case 0x0A:pMathType=ld;pmt('{');break;//
			case 0x0B:pMathType=rd;pmt('}');break;//
			case 0x0C:pMathType=ld;pmt('{');break;//
			case 0x0D:pMathType=rd;pmt('}');break;//
			case 0x0E:pMathType=ld;pmt('{');break;//
			case 0x0F:pMathType=rd;pmt('}');break;//
			//nothing
			case 0x18:pMathType=mo;pmt(0x21BC);break;//left harpoon barb up
			case 0x19:pMathType=mo;pmt(0x21BD);break;//left harpoon barb down
			case 0x1A:pMathType=mo;pmt(0x21C0);break;//right harpoon barb up
			case 0x1B:pMathType=mo;pmt(0x21C1);break;//right harpoon barb down
			//nothing
			case 0x20:pMathType=mo;pmt(0x2190);break;//left arrow
			case 0x21:pMathType=mo;pmt(0x2192);break;//right arrow
			case 0x22:pMathType=mo;pmt(0x2191);break;//up arrow
			case 0x23:pMathType=mo;pmt(0x2193);break;//down arrow
			case 0x24:pMathType=mo;pmt(0x2194);break;//left right arrow
			case 0x25:pMathType=mo;pmt(0x2197);break;//N-E arrow
			case 0x26:pMathType=mo;pmt(0x2198);break;//S-E arrow
			//nothing
			case 0x28:pMathType=mo;pmt(0x21D0);break;//left double arrow
			case 0x29:pMathType=mo;pmt(0x21D2);break;//right double arrow
			case 0x2A:pMathType=mo;pmt(0x21D1);break;//up double arrow
			case 0x2B:pMathType=mo;pmt(0x21D3);break;//down double arrow
			case 0x2C:pMathType=mo;pmt(0x21D4);break;//left right double arrow
			case 0x2D:pMathType=mo;pmt(0x2196);break;//N-W arrow
			case 0x2E:pMathType=mo;pmt(0x2199);break;//S-W arrow
			//nothing
			case 0x31:pMathType=mo;pmt(0x221E);break;//infinity
			
			case 0x38:pMathType=ld;pmt('{');break;//infinity
			//XXX, let the extensions out and mark only the margins
			//XXX, scaling is done by the mathplayer
			case 0x3B:pMathType=rd;pmt('{');break;//infinity
			
			//nothing
			
			case 0x48:
			case 0x49:pMathType=mo;pmt(0x222E);break;//\oint
			//nothing
			
			case 0x50:pMathType=mo;pmt(0x2211);break;//sum
			case 0x51:pMathType=mo;pmt(0x220F);break;//product
			case 0x52:pMathType=mo;pmt(0x222B);break;//\int
			//nothing
			case 0x58:pMathType=mo;pmt(0x2211);break;//sum
			case 0x59:pMathType=mo;pmt(0x220F);break;//product
			case 0x5A:pMathType=mo;pmt(0x222B);break;//\int
			//nothing
			case 0x60:
			case 0x61:pMathType=mo;pmt(0x220F);break;//n-ary coproduct
			//nothing
			//nothing
			case 0x6C:pMathType=mo;pmt(0x2195);break;//up down arrow
			case 0x6D:pMathType=mo;pmt(0x21D5);break;//up down double arrow
			
			//nothing, XXX, brace extensions, let the player do it
			
			}
			temp++;
		}while(*temp);
		return;
	}
		
	if (strstr(currentFont,"rsfs")){
		do{
			switch(*temp){
			
			case 0x7F:pMathType=mo;pmt(0x2040);break;//tie
			
			default: pMathType=mis;pmt('Z');break;//pMathType=mi;pmt(0x1D4B5);break;//A-Z script; 
			}
			temp++;
		}while(*temp);
		return;
	}
	
		
	if (strstr(currentFont,"lassdc")){
		do{
			switch(*temp){
			case 0x00:pMathType=mobss;pmt(0x0060);break;//grave accent
			case 0x01:pMathType=mobss;pmt(0x00B4);break;//acute accent
			case 0x02:pMathType=mobss;pmt(0x005E);break;//hat
			case 0x03:pMathType=mobss;pmt(0x007E);break;//tilde
			case 0x04:pMathType=mobss;pmt(0x0308);break;//XXX, it is combining, should be put in combineAccent
			case 0x05:pMathType=mobss;pmt(0x02DD);break;//double acute accent
			case 0x06:pMathType=mobss;pmt(0x02DA);break;//ring above
			case 0x07:pMathType=mobss;pmt(0x02C7);break;//caron, hacek
			case 0x08:pMathType=mobss;pmt(0x02D8);break;//breve
			case 0x09:pMathType=mobss;pmt(0x00AF);break;//macron
			case 0x0A:pMathType=mobss;pmt(0x02D9);break;//dot above
			case 0x0B:pMathType=mobss;pmt(0x00B8);break;//cedilla
			case 0x0C:pMathType=mobss;pmt(0x02DB);break;//ogonek
			case 0x0D:pMathType=mobss;pmt(0x201A);break;//single low quot-mark
			case 0x0E:pMathType=mobss;pmt(0x2329);break;//left angle
			case 0x0F:pMathType=mobss;pmt(0x232A);break;//right angle
			

			case 0x10:pMathType=ldbss;pmt(0x201C);break;//left double quotation mark
			case 0x11:pMathType=ldbss;pmt(0x201D);break;//right double quotation mark
			case 0x12:pMathType=mobss;pmt(0x0311);break;//frown, combining inverted breve
			case 0x13:pMathType=mobss;pmt(0x030F);break;//combining double breve
			case 0x14:pMathType=mobss;pmt(0x0306);break;//combining breve, XXX should be cyrillic breve
			case 0x15:pMathType=mobss;pmt(0x2013);break;//en dash
			case 0x16:pMathType=mobss;pmt(0x2014);break;//em dash
			case 0x17:pMathType=mobss;pmt(0xE003F);break;//XXX, error mark: I chose TAG question mark
			case 0x18:pMathType=mobss;pmt('0');break;//XXX, pmzero???
			case 0x19:pMathType=mobss;pmt(0x0131);break;//imath
			case 0x1A:pMathType=mobss;pmt(0x006A);break;//jmath,pmt(0x0237);break;//jmath
			case 0x1B:pMathType=mobss;pmt('f');pMathType=mo;pmt('f');break;//p(ul2utf8(0xFB00));break;//ligature ff
			case 0x1C:pMathType=mobss;pmt('f');pMathType=mo;pmt('i');break;//p(ul2utf8(0xFB01));break;//ligature fi
			case 0x1D:pMathType=mobss;pmt('f');pMathType=mo;pmt('l');break;//p(ul2utf8(0xFB02));break;//ligature fl
			case 0x1E:pMathType=mobss;pmt('f');pMathType=mo;pmt('f');pMathType=mo;pmt('i');break;//p(ul2utf8(0xFB03));break;//ligature ffi
			case 0x1F:pMathType=mobss;pmt('f');pMathType=mo;pmt('f');pMathType=mo;pmt('l');break;//p(ul2utf8(0xFB04));break;//ligature ffl

			case 0x20:pMathType=mobss;pmt(0x2423);break;//graphic for space
			case 0x21:pMathType=mobss;pmt(*temp);break;//!
			case 0x22:pMathType=mobss;pmt(0x201D);break;//right double quotation mark
			case 0x23:
			case 0x24:
			case 0x25:pMathType=mobss;pmt(*temp);break;
			case 0x26:
				if (mathmode && !mathText){
					p("<mo mathvariant=\"bold-sans-serif\">&amp;</mo>");
				}else 
					p("&amp;");
				break;//ampersand
			case 0x27:pMathType=mobss;pmt(0x2019);break;//quoteright
			case 0x28:pMathType=ldbss;pmt(*temp);break;//(
			case 0x29:pMathType=rdbss;pmt(*temp);break;//)
			case 0x2A:
			case 0x2B:
			case 0x2C:inhibitspace=0;pMathType=mo;pmt(*temp);break;
			case 0x2D:
			case 0x2E:
			case 0x2F:pMathType=mobss;pmt(*temp);break;

			case 0x30:
			case 0x31:
			case 0x32:
			case 0x33:
			case 0x34:
			case 0x35:
			case 0x36:
			case 0x37:
			case 0x38:
			case 0x39:pMathType=mnbss;pmt(*temp);break;
			case 0x3A:pMathType=mobss;pmt(*temp);break;//:
			case 0x3B:pMathType=mobss;pmt(*temp);break;//;
			case 0x3C://less than
				if(combiningUnicode==0x0338) { 
					combiningUnicode=0;
					pmt(0x226F);
				}	else	p("<mo mathvariant=\"bold-sans-serif\">&lt;</mo>");
				break;
			case 0x3D:pMathType=mobss;pmt(0x002F);break;//division
			case 0x3E: //greater than
				if(combiningUnicode==0x0338) { 
					combiningUnicode=0;
					pmt(0x226F);
				}	else	p("<mo mathvariant=\"bold-sans-serif\">&gt;</mo>");
				break;
			case 0x3F:pMathType=mobss;pmt(*temp);break;//?

			case 0x40:pMathType=mobss;pmt(*temp);break;//@

			case 0x5B:pMathType=ldbss;pmt(*temp);break;//[
			case 0x5C:pMathType=mobss;pmt(*temp);break;//backslash
			case 0x5D:pMathType=rdbss;pmt(*temp);break;//]
			
			case 0x5E:pMathType=mobss;pmt(*temp);break;//^
			case 0x5F:pMathType=mobss;pmt(*temp);break;//_
			case 0x60:pMathType=mobss;pmt(*temp);break;//`
			case 0x61:
			case 0x7A:break;//ascii small letters

			case 0x7B:pMathType=ldbss;pmt(*temp);break;//left brace
			case 0x7C:pMathType=mobss;pmt(*temp);break;//vertical bar
			case 0x7D:pMathType=rdbss;pmt(*temp);break;//right brace
			case 0x7E:pMathType=mobss;pmt(*temp);break;//tilde
			case 0x7F:pMathType=mobss;pmt(0x2012);break;//figure dash
			
			//cyrillic
			case 0x80:pMathType=mobss;pmt(0x0490);break;//GHE with upturn
			case 0x81:pMathType=mobss;pmt(0x0492);break;//GHE with stroke
			case 0x82:pMathType=mobss;pmt(0x0494);break;//GHE with midhook
			case 0x83:pMathType=mobss;pmt(0x040B);break;//TSHE
			case 0x84:pMathType=mobss;pmt(0x04BA);break;//SHHA
			case 0x85:pMathType=mobss;pmt(0x0496);break;//ZHE with descender
			case 0x86:pMathType=mobss;pmt(0x0498);break;//ZE with descender
			case 0x87:pMathType=mobss;pmt(0x0409);break;//LJE
			case 0x88:pMathType=mobss;pmt(0x0407);break;//YI
			case 0x89:pMathType=mobss;pmt(0x049A);break;//KA with descender
			case 0x8A:pMathType=mobss;pmt(0x04A1);break;//KA bashkir
			case 0x8B:pMathType=mobss;pmt(0x049C);break;//KA with vertical stroke
			case 0x8C:pMathType=mobss;pmt(0x04D4);break;//ligature A IE
			case 0x8D:pMathType=mobss;pmt(0x04A2);break;//EN with descender
			case 0x8E:pMathType=mobss;pmt(0x04A4);break;//ligature EN GHE
			case 0x8F:pMathType=mobss;pmt(0x0405);break;//DZE

			case 0x90:pMathType=mobss;pmt(0x0472);break;//FITA
			case 0x91:pMathType=mobss;pmt(0x04AA);break;//ES with descendent
			case 0x92:pMathType=mobss;pmt(0x040E);break;//short U
			case 0x93:pMathType=mobss;pmt(0x04AE);break;//straight U
			case 0x94:pMathType=mobss;pmt(0x04B0);break;//straight U with stroke
			case 0x95:pMathType=mobss;pmt(0x04B2);break;//HA with descender
			case 0x96:pMathType=mobss;pmt(0x040F);break;//DZHE
			case 0x97:pMathType=mobss;pmt(0x04B8);break;//CHE with vertical stroke
			case 0x98:pMathType=mobss;pmt(0x04B6);break;//CHE with descender
			case 0x99:pMathType=mobss;pmt(0x0404);break;//ukrainian IE
			case 0x9A:pMathType=mobss;pmt(0x04D8);break;//SCHWA
			case 0x9B:pMathType=mobss;pmt(0x040A);break;//NJE
			case 0x9C:pMathType=mobss;pmt(0x0451);break;//IO
			case 0x9D:pMathType=mobss;pmt(0x2116);break;//numero sign
			case 0x9E:pMathType=mobss;pmt(0x00A4);break;//currency sign
			case 0x9F:pMathType=mobss;pmt(0x00A7);break;//section sign

			case 0xA0:pMathType=mobss;pmt(0x0491);break;//ghe with upturn
			case 0xA1:pMathType=mobss;pmt(0x0493);break;//ghe with stroke
			case 0xA2:pMathType=mobss;pmt(0x0495);break;//ghe with midhook
			case 0xA3:pMathType=mobss;pmt(0x045B);break;//tshe
			case 0xA4:pMathType=mobss;pmt(0x04BB);break;//shha
			case 0xA5:pMathType=mobss;pmt(0x0497);break;//zhe with descender
			case 0xA6:pMathType=mobss;pmt(0x0499);break;//ze with descender
			case 0xA7:pMathType=mobss;pmt(0x0459);break;//lje
			case 0xA8:pMathType=mobss;pmt(0x0457);break;//yi
			case 0xA9:pMathType=mobss;pmt(0x0498);break;//ka with descender
			case 0xAA:pMathType=mobss;pmt(0x04A1);break;//ka bashkir
			case 0xAB:pMathType=mobss;pmt(0x049D);break;//ka with vertical stroke
			case 0xAC:pMathType=mobss;pmt(0x04D5);break;//ligature A IE
			case 0xAD:pMathType=mobss;pmt(0x04A3);break;//en with descender
			case 0xAE:pMathType=mobss;pmt(0x04A5);break;//ligature en ghe
			case 0xAF:pMathType=mobss;pmt(0x0455);break;//dze
			
			case 0xB0:pMathType=mobss;pmt(0x0473);break;//fita
			case 0xB1:pMathType=mobss;pmt(0x04AB);break;//es with descendent
			case 0xB2:pMathType=mobss;pmt(0x045E);break;//short u
			case 0xB3:pMathType=mobss;pmt(0x04AF);break;//straight u
			case 0xB4:pMathType=mobss;pmt(0x04B1);break;//straight u with stroke
			case 0xB5:pMathType=mobss;pmt(0x04B3);break;//ha with descender
			case 0xB6:pMathType=mobss;pmt(0x045F);break;//dzhe
			case 0xB7:pMathType=mobss;pmt(0x04B9);break;//che with vertical stroke
			case 0xB8:pMathType=mobss;pmt(0x04B7);break;//che with descender
			case 0xB9:pMathType=mobss;pmt(0x0454);break;//ukrainian IE
			case 0xBA:pMathType=mobss;pmt(0x04D9);break;//schwa
			case 0xBB:pMathType=mobss;pmt(0x045A);break;//nje
			case 0xBC:pMathType=mobss;pmt(0x0451);break;//io
			case 0xBD:pMathType=moss;pmt(0x201E);break;//low double comma quot-mark
			case 0xBE:pMathType=moss;pmt(0x00AB);break;//guillemet left 
			case 0xBF:pMathType=mobss;pmt(0x00BB);break;//guillemet right

			case 0xC0:pMathType=mobss;pmt(0x0410);break;//A
			case 0xC1:pMathType=mobss;pmt(0x0411);break;//BE
			case 0xC2:pMathType=mobss;pmt(0x0412);break;//VE
			case 0xC3:pMathType=mobss;pmt(0x0413);break;//GHE
			case 0xC4:pMathType=mobss;pmt(0x0414);break;//DE
			case 0xC5:pMathType=mobss;pmt(0x0415);break;//IE
			case 0xC6:pMathType=mobss;pmt(0x0416);break;//ZHE
			case 0xC7:pMathType=mobss;pmt(0x0417);break;//ZE
			case 0xC8:pMathType=mobss;pmt(0x0418);break;//I
			case 0xC9:pMathType=mobss;pmt(0x0419);break;//short I
			case 0xCA:pMathType=mobss;pmt(0x041A);break;//KA
			case 0xCB:pMathType=mobss;pmt(0x041B);break;//EL
			case 0xCC:pMathType=mobss;pmt(0x041C);break;//EM
			case 0xCD:pMathType=mobss;pmt(0x041D);break;//EN
			case 0xCE:pMathType=mobss;pmt(0x041E);break;//O
			case 0xCF:pMathType=mobss;pmt(0x041F);break;//PE

			case 0xD0:pMathType=mobss;pmt(0x0420);break;//ER
			case 0xD1:pMathType=mobss;pmt(0x0421);break;//ES
			case 0xD2:pMathType=mobss;pmt(0x0422);break;//TE
			case 0xD3:pMathType=mobss;pmt(0x0423);break;//U
			case 0xD4:pMathType=mobss;pmt(0x0424);break;//EF
			case 0xD5:pMathType=mobss;pmt(0x0425);break;//HA
			case 0xD6:pMathType=mobss;pmt(0x0426);break;//TSE
			case 0xD7:pMathType=mobss;pmt(0x0427);break;//CHE
			case 0xD8:pMathType=mobss;pmt(0x0428);break;//SHA
			case 0xD9:pMathType=mobss;pmt(0x0429);break;//SHCHA
			case 0xDA:pMathType=mobss;pmt(0x042A);break;//HARD sign
			case 0xDB:pMathType=mobss;pmt(0x042B);break;//YERU
			case 0xDC:pMathType=mobss;pmt(0x042C);break;//SOFT sign
			case 0xDD:pMathType=mobss;pmt(0x042D);break;//E
			case 0xDE:pMathType=mobss;pmt(0x042E);break;//YU
			case 0xDF:pMathType=mobss;pmt(0x042F);break;//YA
			
			case 0xE0:pMathType=mobss;pmt(0x0430);break;//a
			case 0xE1:pMathType=mobss;pmt(0x0431);break;//be
			case 0xE2:pMathType=mobss;pmt(0x0432);break;//ve
			case 0xE3:pMathType=mobss;pmt(0x0433);break;//ghe
			case 0xE4:pMathType=mobss;pmt(0x0434);break;//de
			case 0xE5:pMathType=mobss;pmt(0x0435);break;//ie
			case 0xE6:pMathType=mobss;pmt(0x0436);break;//zhe
			case 0xE7:pMathType=mobss;pmt(0x0437);break;//ze
			case 0xE8:pMathType=mobss;pmt(0x0438);break;//i
			case 0xE9:pMathType=mobss;pmt(0x0439);break;//short i
			case 0xEA:pMathType=mobss;pmt(0x043A);break;//ka
			case 0xEB:pMathType=mobss;pmt(0x043B);break;//el
			case 0xEC:pMathType=mobss;pmt(0x043C);break;//em
			case 0xED:pMathType=mobss;pmt(0x043D);break;//en
			case 0xEE:pMathType=mobss;pmt(0x043E);break;//o
			case 0xEF:pMathType=mobss;pmt(0x043F);break;//pe

			case 0xF0:pMathType=mobss;pmt(0x0440);break;//er
			case 0xF1:pMathType=mobss;pmt(0x0441);break;//es
			case 0xF2:pMathType=mobss;pmt(0x0442);break;//te
			case 0xF3:pMathType=mobss;pmt(0x0443);break;//u
			case 0xF4:pMathType=mobss;pmt(0x0444);break;//ef
			case 0xF5:pMathType=mobss;pmt(0x0445);break;//ha
			case 0xF6:pMathType=mobss;pmt(0x0446);break;//tse
			case 0xF7:pMathType=mobss;pmt(0x0447);break;//che
			case 0xF8:pMathType=mobss;pmt(0x0448);break;//sha
			case 0xF9:pMathType=mobss;pmt(0x0449);break;//shcha
			case 0xFA:pMathType=mobss;pmt(0x044A);break;//hard sign
			case 0xFB:pMathType=mobss;pmt(0x044B);break;//yeru
			case 0xFC:pMathType=mobss;pmt(0x044C);break;//soft sign
			case 0xFD:pMathType=mobss;pmt(0x044D);break;//e
			case 0xFE:pMathType=mobss;pmt(0x044E);break;//yu
			case 0xFF:pMathType=mobss;pmt(0x044F);break;//ya
			
			default:pMathType=mobss;pmt(*temp);
			}
			temp++;
		}while(*temp);
		return;
	}


*/

char* ul2utf8(unsigned int unicode){
	unsigned int mask=0x3F;
	unsigned char u1,u2=0x80,u3=0x80,u4=0x80,u5=0x80,u6=0x80;
	static char s[7];
	if (unicode>=0x04000000) u1=126;
		else if (unicode>=0x00200000) u1=62;
			else if (unicode>=0x00010000) u1=30;
				else if (unicode>=0x00000800) u1=14;
					else if (unicode>=0x00000080) u1=6;
						else u1=0;
	switch(u1){
		case 0:
			u1=unicode;
			sprintf(s,"%c",u1);
			break;
		case 6:
			u2+=unicode & mask;
			u1=(u1<<5)+(unicode>>6 & mask>>1);
			sprintf(s,"%c%c",u1,u2);
			break;
		case 14:
			u3+=unicode & mask;
			u2+=unicode>>6 & mask;
			u1=(u1<<4)+(unicode>>12 & mask>>2);
			sprintf(s,"%c%c%c",u1,u2,u3);
			break;
		case 30:
			u4+=unicode & mask;
			u3+=unicode>>6 & mask;
			u2+=unicode>>12 & mask;
			u1=(u1<<3)+(unicode>>18 & mask>>3);
			sprintf(s,"%c%c%c%c",u1,u2,u3,u4);
			break;
		case 62:
			u5+=unicode & mask;
			u4+=unicode>>6 & mask;
			u3+=unicode>>12 & mask;
			u2+=unicode>>18 & mask;
			u1=(u1<<2)+(unicode>>24 & mask>>4);
			sprintf(s,"%c%c%c%c%c",u1,u2,u3,u4,u5);
			break;
		case 126:
			u6+=unicode & mask;
			u5+=unicode>>6 & mask;
			u4+=unicode>>12 & mask;
			u3+=unicode>>18 & mask;
			u2+=unicode>>24 & mask;
			u1=(u1<<1)+(unicode>>30 & mask>>5);
			sprintf(s,"%c%c%c%c%c%c",u1,u2,u3,u4,u5,u6);
			break;
	}
	return s;
}


void pmt(unsigned int unicode){
	if (mathmode && !mathText && !mathOp){
		if (unicode!=blockthis) blockthis=0xFFFF;
		else return;
		switch(pMathType){
		case mi:
			switch(theFont.family){
			case serif:
				switch (theFont.style){
				case upright:
					switch (theFont.weight){
					case hairline: 
					case extraLight:
					case light: 
					case book: 
					case normalWeight: 
					case medium:
						p("<mo>");
					break;	//normal
					case demiBold:
					case semiBold:
					case bold: 
					case extraBold: 
					case heavy: 
					case black: 
					case ultraBlack:
					case poster:
						p("<mo mathvariant=\"bold\">");
					break;	//bold
					}
				break;	//upright
				case italic: 
				case oblique:	
					switch (theFont.weight){
					case hairline: 
					case extraLight:
					case light: 
					case book: 
					case normalWeight: 
					case medium:
						p("<mi>");
					break;	//normal
					case demiBold:
					case semiBold:
					case bold: 
					case extraBold: 
					case heavy: 
					case black: 
					case ultraBlack:
					case poster:
						p("<mi mathvariant=\"bold-italic\">");
					break;	//bold
					}
				break;	//italic
				}
			break;	//serif
			case sans:
				switch (theFont.style){
				case upright:
					switch (theFont.weight){
					case hairline: 
					case extraLight:
					case light: 
					case book: 
					case normalWeight: 
					case medium:
						p("<mo mathvariant=\"sans-serif\">");
					break;	//normal
					case demiBold:
					case semiBold:
					case bold: 
					case extraBold: 
					case heavy: 
					case black: 
					case ultraBlack:
					case poster:
						p("<mo mathvariant=\"bold-sans-serif\">");
					break;	//bold
					}
				break;	//upright
				case italic: 
				case oblique:	
					switch (theFont.weight){
					case hairline: 
					case extraLight:
					case light: 
					case book: 
					case normalWeight: 
					case medium:
						p("<mi mathvariant=\"sans-serif-italic\">");
					break;	//normal
					case demiBold:
					case semiBold:
					case bold: 
					case extraBold: 
					case heavy: 
					case black: 
					case ultraBlack:
					case poster:
						p("<mi mathvariant=\"sans-serif-bold-italic\">");
					break;	//bold
					}
				break;	//italic
				}
			break;	//sans
			case monospace:
				switch (theFont.style){
				case upright:
					p("<mo mathvariant=\"monospace\">");
				break;	//upright
				case italic: 
				case oblique:	
					p("<mi mathvariant=\"monospace\">");
				break;	//italic
				}
			break;	//monospace
			case cursive:
				switch (theFont.style){
				case upright:
					switch (theFont.weight){
					case hairline: 
					case extraLight:
					case light: 
					case book: 
					case normalWeight: 
					case medium:
						p("<mo mathvariant=\"script\">");
					break;	//normalWeight
					case demiBold:
					case semiBold:
					case bold: 
					case extraBold: 
					case heavy: 
					case black: 
					case ultraBlack:
					case poster:
						p("<mo mathvariant=\"bold-script\">");
					break;	//bold
					}
				break;	//upright
				case italic: 
				case oblique:	
					switch (theFont.weight){
					case hairline: 
					case extraLight:
					case light: 
					case book: 
					case normalWeight: 
					case medium:
						p("<mi mathvariant=\"script\">");
					break;	//normal
					case demiBold:
					case semiBold:
					case bold: 
					case extraBold: 
					case heavy: 
					case black: 
					case ultraBlack:
					case poster:
						p("<mi mathvariant=\"bold-script\">");
					break;	//bold
					}
				break;	//italic
				}
			break;	//cursive
			case doubleStruck:
				switch (theFont.style){
				case upright:
					p("<mo mathvariant=\"double-struck\">");
				break;	//upright
				case italic: 
				case oblique:	
					p("<mi mathvariant=\"double-struck\">");
				break;	//italic
				}
			break;	//doubleStruck
			case fraktur:	
				switch (theFont.style){
				case upright:
					switch (theFont.weight){
					case hairline: 
					case extraLight:
					case light: 
					case book: 
					case normalWeight: 
					case medium:
						p("<mo mathvariant=\"fraktur\">");
					break;	//normal
					case demiBold:
					case semiBold:
					case bold: 
					case extraBold: 
					case heavy: 
					case black: 
					case ultraBlack:
					case poster:
						p("<mo mathvariant=\"bold-fraktur\">");
					break;	//bold
					}
				break;	//upright
				case italic: 
				case oblique:	
					switch (theFont.weight){
					case hairline: 
					case extraLight:
					case light: 
					case book: 
					case normalWeight: 
					case medium:
						p("<mi mathvariant=\"fraktur\">");
					break;	//normal
					case demiBold:
					case semiBold:
					case bold: 
					case extraBold: 
					case heavy: 
					case black: 
					case ultraBlack:
					case poster:
						p("<mi mathvariant=\"bold-fraktur\">");
					break;	//bold
					}
				break;	//italic
				}
			break;	//fraktur
			case fantasy:	//ignore
			break;
			}
		break;	//mi
		case mo:
			switch(theFont.family){
			case serif:
				switch (theFont.style){
				case upright:
					switch (theFont.weight){
					case hairline: 
					case extraLight:
					case light: 
					case book: 
					case normalWeight: 
					case medium:
						p("<mo>");
					break;	//normal
					case demiBold:
					case semiBold:
					case bold: 
					case extraBold: 
					case heavy: 
					case black: 
					case ultraBlack:
					case poster:
						p("<mo mathvariant=\"bold\">");
					break;	//bold
					}
				break;	//upright
				case italic: 
				case oblique:	
					switch (theFont.weight){
					case hairline: 
					case extraLight:
					case light: 
					case book: 
					case normalWeight: 
					case medium:
						p("<mo mathvariant=\"italic\">");
					break;	//normal
					case demiBold:
					case semiBold:
					case bold: 
					case extraBold: 
					case heavy: 
					case black: 
					case ultraBlack:
					case poster:
						p("<mo mathvariant=\"bold-italic\">");
					break;	//bold
					}
				break;	//italic
				}
			break;	//serif
			case sans:
				switch (theFont.style){
				case upright:
					switch (theFont.weight){
					case hairline: 
					case extraLight:
					case light: 
					case book: 
					case normalWeight: 
					case medium:
						p("<mo mathvariant=\"sans-serif\">");
					break;	//normal
					case demiBold:
					case semiBold:
					case bold: 
					case extraBold: 
					case heavy: 
					case black: 
					case ultraBlack:
					case poster:
						p("<mo mathvariant=\"bold-sans-serif\">");
					break;	//bold
					}
				break;	//upright
				case italic: 
				case oblique:	
					switch (theFont.weight){
					case hairline: 
					case extraLight:
					case light: 
					case book: 
					case normalWeight: 
					case medium:
						p("<mo mathvariant=\"sans-serif-italic\">");
					break;	//normal
					case demiBold:
					case semiBold:
					case bold: 
					case extraBold: 
					case heavy: 
					case black: 
					case ultraBlack:
					case poster:
						p("<mo mathvariant=\"sans-serif-bold-italic\">");
					break;	//bold
					}
				break;	//italic
				}
			break;	//sans
			case monospace:
					p("<mo mathvariant=\"monospace\">");//XXX, wha', no italic here?
			break;	//monospace
			case cursive:
				switch (theFont.weight){
				case hairline: 
				case extraLight:
				case light: 
				case book: 
				case normalWeight: 
				case medium:
					p("<mo mathvariant=\"script\">");
				break;	//normal
				case demiBold:
				case semiBold:
				case bold: 
				case extraBold: 
				case heavy: 
				case black: 
				case ultraBlack:
				case poster:
					p("<mo mathvariant=\"bold-script\">");
				break;	//bold
				}
			break;	//cursive
			case doubleStruck:
				p("<mo mathvariant=\"double-struck\">");
			break;	//doubleStruck
			case fraktur:	
				switch (theFont.weight){
				case hairline: 
				case extraLight:
				case light: 
				case book: 
				case normalWeight: 
				case medium:
					p("<mo mathvariant=\"fraktur\">");
				break;	//normal
				case demiBold:
				case semiBold:
				case bold: 
				case extraBold: 
				case heavy: 
				case black: 
				case ultraBlack:
				case poster:
					p("<mo mathvariant=\"bold-fraktur\">");
				break;	//bold
				}
			break;	//fraktur
			case fantasy:	//ignore
			break;
			}
		break;	//mo
		case mn:
			fixDigits();//XXX needs fixing itself :), currently ignores number formatting
			break;
		case ld:
		case ld_b:
			if(!mDelimiter) p("<mrow>");
			switch(theFont.family){
			case serif:
				switch (theFont.style){
				case upright:
					switch (theFont.weight){
					case hairline: 
					case extraLight:
					case light: 
					case book: 
					case normalWeight: 
					case medium:
						p("<mo>");
					break;	//normal
					case demiBold:
					case semiBold:
					case bold: 
					case extraBold: 
					case heavy: 
					case black: 
					case ultraBlack:
					case poster:
						p("<mo mathvariant=\"bold\">");
					break;	//bold
					}
				break;	//upright
				case italic: 
				case oblique:	
					switch (theFont.weight){
					case hairline: 
					case extraLight:
					case light: 
					case book: 
					case normalWeight: 
					case medium:
						p("<mo mathvariant=\"italic\">");
					break;	//normal
					case demiBold:
					case semiBold:
					case bold: 
					case extraBold: 
					case heavy: 
					case black: 
					case ultraBlack:
					case poster:
						p("<mo mathvariant=\"bold-italic\">");
					break;	//bold
					}
				break;	//italic
				}
			break;	//serif
			case sans:
				switch (theFont.style){
				case upright:
					switch (theFont.weight){
					case hairline: 
					case extraLight:
					case light: 
					case book: 
					case normalWeight: 
					case medium:
						p("<mo mathvariant=\"sans-serif\">");
					break;	//normal
					case demiBold:
					case semiBold:
					case bold: 
					case extraBold: 
					case heavy: 
					case black: 
					case ultraBlack:
					case poster:
						p("<mo mathvariant=\"bold-sans-serif\">");
					break;	//bold
					}
				break;	//upright
				case italic: 
				case oblique:	
					switch (theFont.weight){
					case hairline: 
					case extraLight:
					case light: 
					case book: 
					case normalWeight: 
					case medium:
						p("<mo mathvariant=\"sans-serif-italic\">");
					break;	//normal
					case demiBold:
					case semiBold:
					case bold: 
					case extraBold: 
					case heavy: 
					case black: 
					case ultraBlack:
					case poster:
						p("<mo mathvariant=\"sans-serif-bold-italic\">");
					break;	//bold
					}
				break;	//italic
				}
			break;	//sans
			case monospace:
					p("<mo mathvariant=\"monospace\">");//XXX, wha', no italic here?
			break;	//monospace
			case cursive:
				switch (theFont.weight){
				case hairline: 
				case extraLight:
				case light: 
				case book: 
				case normalWeight: 
				case medium:
					p("<mo mathvariant=\"script\">");
				break;	//normal
				case demiBold:
				case semiBold:
				case bold: 
				case extraBold: 
				case heavy: 
				case black: 
				case ultraBlack:
				case poster:
					p("<mo mathvariant=\"bold-script\">");
				break;	//bold
				}
			break;	//cursive
			case doubleStruck:
				p("<mo mathvariant=\"double-struck\">");
			break;	//doubleStruck
			case fraktur:	
				switch (theFont.weight){
				case hairline: 
				case extraLight:
				case light: 
				case book: 
				case normalWeight: 
				case medium:
					p("<mo mathvariant=\"fraktur\">");
				break;	//normal
				case demiBold:
				case semiBold:
				case bold: 
				case extraBold: 
				case heavy: 
				case black: 
				case ultraBlack:
				case poster:
					p("<mo mathvariant=\"bold-fraktur\">");
				break;	//bold
				}
			break;	//fraktur
			case fantasy:	//ignore
			break;
			}
		break;//ld,ld_b
		case rd:	
		case rd_b:
			if(!mDelimiter) p("</mrow>");
			switch(theFont.family){
			case serif:
				switch (theFont.style){
				case upright:
					switch (theFont.weight){
					case hairline: 
					case extraLight:
					case light: 
					case book: 
					case normalWeight: 
					case medium:
						p("<mo>");
					break;	//normal
					case demiBold:
					case semiBold:
					case bold: 
					case extraBold: 
					case heavy: 
					case black: 
					case ultraBlack:
					case poster:
						p("<mo mathvariant=\"bold\">");
					break;	//bold
					}
				break;	//upright
				case italic: 
				case oblique:	
					switch (theFont.weight){
					case hairline: 
					case extraLight:
					case light: 
					case book: 
					case normalWeight: 
					case medium:
						p("<mo mathvariant=\"italic\">");
					break;	//normal
					case demiBold:
					case semiBold:
					case bold: 
					case extraBold: 
					case heavy: 
					case black: 
					case ultraBlack:
					case poster:
						p("<mo mathvariant=\"bold-italic\">");
					break;	//bold
					}
				break;	//italic
				}
			break;	//serif
			case sans:
				switch (theFont.style){
				case upright:
					switch (theFont.weight){
					case hairline: 
					case extraLight:
					case light: 
					case book: 
					case normalWeight: 
					case medium:
						p("<mo mathvariant=\"sans-serif\">");
					break;	//normal
					case demiBold:
					case semiBold:
					case bold: 
					case extraBold: 
					case heavy: 
					case black: 
					case ultraBlack:
					case poster:
						p("<mo mathvariant=\"bold-sans-serif\">");
					break;	//bold
					}
				break;	//upright
				case italic: 
				case oblique:	
					switch (theFont.weight){
					case hairline: 
					case extraLight:
					case light: 
					case book: 
					case normalWeight: 
					case medium:
						p("<mo mathvariant=\"sans-serif-italic\">");
					break;	//normal
					case demiBold:
					case semiBold:
					case bold: 
					case extraBold: 
					case heavy: 
					case black: 
					case ultraBlack:
					case poster:
						p("<mo mathvariant=\"sans-serif-bold-italic\">");
					break;	//bold
					}
				break;	//italic
				}
			break;	//sans
			case monospace:
					p("<mo mathvariant=\"monospace\">");//XXX, wha', no italic here?
			break;	//monospace
			case cursive:
				switch (theFont.weight){
				case hairline: 
				case extraLight:
				case light: 
				case book: 
				case normalWeight: 
				case medium:
					p("<mo mathvariant=\"script\">");
				break;	//normal
				case demiBold:
				case semiBold:
				case bold: 
				case extraBold: 
				case heavy: 
				case black: 
				case ultraBlack:
				case poster:
					p("<mo mathvariant=\"bold-script\">");
				break;	//bold
				}
			break;	//cursive
			case doubleStruck:
				p("<mo mathvariant=\"double-struck\">");
			break;	//doubleStruck
			case fraktur:	
				switch (theFont.weight){
				case hairline: 
				case extraLight:
				case light: 
				case book: 
				case normalWeight: 
				case medium:
					p("<mo mathvariant=\"fraktur\">");
				break;	//normal
				case demiBold:
				case semiBold:
				case bold: 
				case extraBold: 
				case heavy: 
				case black: 
				case ultraBlack:
				case poster:
					p("<mo mathvariant=\"bold-fraktur\">");
				break;	//bold
				}
			break;	//fraktur
			case fantasy:	//ignore
			break;
			}
		break;	//rd,rd_b
		case ld_x:
		case rd_x:
		case ld_e:
		case rd_e:
		break;
	}

		p(ul2utf8(unicode));
		if (combiningUnicode) {
			p(ul2utf8(combiningUnicode));
			combiningUnicode=0;
		}

		switch(pMathType){
			case mi:
				switch (theFont.style){
				case upright:
					p("</mo>");
				break;	//upright
				case italic: 
				case oblique:	
					p("</mi>");
				break;	//italic
				}
			break;	//mi
			case mo:
				p("</mo>");
			break;
			case mn:
				p("</mn>");
			break;
			case ld:
			case ld_e:
				p("</mo>"); 
				if(!mDelimiter) p("<mrow>");
				Wraps[depth]++;
			break;
			case rd:
			case rd_e:
				p("</mo>");
				if(!mDelimiter) p("</mrow>");
//				if (Wraps[depth]==0)
//					die("right delimiter consumed too early\n");
				Wraps[depth]--;
			break;
			case ld_b:
			case rd_b:
			case ld_x:
			case rd_x:
			break;
		}
	}else {
		p(ul2utf8(unicode));
		if (combiningUnicode) {
			contractTextAccent();			
			combiningUnicode=0;
		}
	}
	return;
}

void saveAccent(char accent){
	//if (strstr(theFont.name,"cmr")|| strstr(theFont.name,"cmbx")|| strstr(theFont.name,"pplr")|| strstr(theFont.name,"cmcsc")){
	if (theFont.map==fontMap7t){
			switch(accent){
			case 0x12:combiningUnicode=0x0300;break;//grave accent
			case 0x13:combiningUnicode=0x0301;break;//acute accent
			case 0x14:combiningUnicode=0x030C;break;//caron, hacek
			case 0x15:combiningUnicode=0x0306;break;//breve
			case 0x16:combiningUnicode=0x0304;break;//macron
			case 0x17:combiningUnicode=0x030A;break;//ring above
			case 0x18:combiningUnicode=0x0327;break;//cedilla below 
			case 0x20:combiningUnicode=0x0337;break;//short solidus overlay
			case 0x5E:combiningUnicode=0x0302;break;//circumflex
			case 0x5F:combiningUnicode=0x0307;break;//dot above
			case 0x63:combiningUnicode=0x0063;break;//special case 'c' from copyright
			case 0x7D:combiningUnicode=0x030B;break;//long hungarian umlaut, combining double acute accent
			case 0x7E:combiningUnicode=0x0342;break;//tilde
			case 0x7F:combiningUnicode=0x0308;break;//diaeresis
			}
	}
	if (theFont.map==fontMapMathItalic){
		switch(accent){
			case 0x7F:combiningUnicode=0x2040;break;//tie
		}
	}
	return;
}

void saveAccentUnder(char accent){
	if (theFont.map==fontMap7t){
			switch(accent){
			case 0x16:combiningUnicode=0x0331;break;//macron below
			case 0x18:combiningUnicode=0x0327;break;//cedilla below
			case 0x2E:combiningUnicode=0x0323;break;//dot below
			}
	}
	return;
}

void InferContent(){
	char*from,utf8Operator[100];

	//divide
	from=doc_math;
	do{
	from=content(from,">/<","<apply><divide/><ci>","</ci></apply>");
	}while(from);

	//plus
	from=doc_math;
	do{
	from=content(from,">+<","<apply><plus/><ci>","</ci></apply>");
	}while(from);

	//minus
	from=doc_math;
	strcpy(utf8Operator,">");
	strcat(utf8Operator,ul2utf8(0x2212));
	strcat(utf8Operator,"<");
	do{
	from=content(from,utf8Operator,"<apply><minus/><ci>","</ci></apply>");
	}while(from);
	
	//begin relations 
	//equal
	from=doc_math;
	do{
	from=content(from,">=<","<apply><eq/><ci>","</ci></apply>");
	}while(from);
	
	//not equal
	from=doc_math;
	strcpy(utf8Operator,">");
	strcat(utf8Operator,ul2utf8(0x2260));
	strcat(utf8Operator,"<");
	do{
	from=content(from,utf8Operator,"<apply><neq/><ci>","</ci></apply>");
	}while(from);
	
	//greater than
	from=doc_math;
	do{
	from=content(from,">&gt;<","<apply><gt/><ci>","</ci></apply>");
	}while(from);

	//less than
	from=doc_math;
	do{
	from=content(from,">&lt;<","<apply><lt/><ci>","</ci></apply>");
	}while(from);
	
	//greater than or equal
	from=doc_math;
	strcpy(utf8Operator,">");
	strcat(utf8Operator,ul2utf8(0x2265));
	strcat(utf8Operator,"<");
	do{
	from=content(from,utf8Operator,"<apply><geq/><ci>","</ci></apply>");
	}while(from);
	
	//less than or equal
	from=doc_math;
	strcpy(utf8Operator,">");
	strcat(utf8Operator,ul2utf8(0x2264));
	strcat(utf8Operator,"<");
	do{
	from=content(from,utf8Operator,"<apply><leq/><ci>","</ci></apply>");
	}while(from);
	
	//equivalent
	from=doc_math;
	strcpy(utf8Operator,">");
	strcat(utf8Operator,ul2utf8(0x224D));
	strcat(utf8Operator,"<");
	do{
	from=content(from,utf8Operator,"<apply><equivalent/><ci>","</ci></apply>");
	}while(from);
	
	//approx
	from=doc_math;
	strcpy(utf8Operator,">");
	strcat(utf8Operator,ul2utf8(0x224A));
	strcat(utf8Operator,"<");
	do{
	from=content(from,utf8Operator,"<apply><approx/><ci>","</ci></apply>");
	}while(from);
	
	//end relations 
}

char* content(char*from,char*what, char*bas, char*eas){
	/* look for 'what' in 'from',
	find the previous argument and insert 'bas', then '</ci><ci>',
	then find the next argument and insert and 'eas'
	*/

	char *temp,*tail,*lock,*check;
	temp=lock=check=strstr(from,what);
	if (temp==NULL) return NULL;

	//ensure we're not at the end of a container
	check=strstr(++check,">");
	if (check==strstr(check,"><")){
		if (IsMMLContainerEnd(++check)) return ++lock;
	}else
		return ++lock;

	//ensure we're not at the beginning of a container
	while(*temp--!='<'){if (temp==from) return(++lock);};
	while(*temp--!='<'){if (temp==from) return(++lock);};
	if (IsMMLContainerStart(++temp)) return ++lock;

	lock=strstr(temp,what);
	lock=strstr(++lock,">");
	tail=(char*)malloc(strlen(++lock)+1);
	strcpy(tail,lock);
	lock=strstr(temp,"><");
	*++lock=0;
	lock=(char*)malloc(strlen(temp)+1);
	strcpy(lock,"<");
	strcat(lock,temp+2);
	temp=MatchTagLeft(temp,lock);
	free(lock);
	Insert(temp,bas);
	strcat(temp,"</ci><ci>");
	lock=strrchr(temp,0);
	strcat(temp,tail);
	free(tail);

	//'lock' points now to the beginning of the second argument
	temp=lock;
	temp=MatchTagRight(strstr(temp,"<"));
	Insert(temp,eas);
	return ++lock;
}

void beginSuperScript(){
	char*temp=strrchr(doc_math,0),*tail,*lock;
	lock=temp;
	//go to last closing tag
	while (strstr(temp,"</")!=temp) {
		if (temp==doc_math) {
			if (mathOp){	//a decorated operator
				Insert(temp,"<msup><mrow>");
				p("</mo></mrow><mrow><mo>");
			}else	//the author used $^
				Insert(temp,"<msup><mrow><mi> </mi></mrow><mrow>");
			return; 
		}
		if (strstr(temp,"<mrow")==temp || strstr(temp,"<mtd")==temp) {
			temp=strstr(temp,">");temp++;
			Insert(temp,"<msup><mrow><mi> </mi></mrow><mrow>");
			return; //the author used {}^ 
		}
		temp--;
	}
	
	
	if ((tail=strstr(temp," RD "))){
		temp=SkipBracketsLeft(tail);
	}else{
		tail=(char*)malloc(strlen(temp)+1);
		strcpy(tail,"<");
		strcat(tail,strstr(temp,"/")+1);
		*strstr(tail,">")=0;
		temp=MatchTagLeft(temp,tail);
		free(tail);
	}
	
	if (hbrace && temp==strstr(temp,"<munder")){
		Insert(temp,"<munder accentunder=\"true\">");
		p("<mrow>");
	}else{
		if (hbrace && temp==strstr(temp,"<mover")){
			Insert(temp,"<mover accent=\"true\">");
			p("<mrow>");
		}else{
				Insert(temp,"<msup><mrow>");
				p("</mrow><mrow>");
		}
	}
	if (mathOp) p("<mo>");
}

void beginSubScript(){
	char*temp=strrchr(doc_math,0),*tail,*lock;
	while (strstr(temp,"</")!=temp) {
		if (temp==doc_math) {
			if (mathOp){	//a decorated operator
				Insert(temp,"<msub><mrow>");
				p("</mo></mrow><mrow><mo>");
			}else	//the author used $_
				Insert(temp,"<msub><mrow><mi> </mi></mrow><mrow>");
			return; 
		}
		if (strstr(temp,"<mrow")==temp || strstr(temp,"<mtd")==temp) {
			temp=strstr(temp,">");temp++;
			Insert(temp,"<msub><mrow><mi> </mi></mrow><mrow>");
			return; //the author used {}_ 
		}
		temp--;
	}
	
	if ((tail=strstr(temp," RD "))){
		temp=SkipBracketsLeft(tail);
	}else{
		tail=(char*)malloc(strlen(temp)+1);
		strcpy(tail,"<");
		strcat(tail,strstr(temp,"/")+1);
		*strstr(tail,">")=0;
		lock=temp=MatchTagLeft(temp,tail);
		free(tail);
	}
	
	if (temp==strstr(temp,"<msup")){
		lock=MatchTagRight(temp);
		while (lock!=strstr(lock,"</")) lock--;
		*lock=0;
		temp++;temp++;
		Insert(temp,"sub");//make it a <msubsup> tag
		p("<mrow>");
	}else{
		if (hbrace && temp==strstr(temp,"<munder")){
			Insert(temp,"<munder accentunder=\"true\">");
			p("<mrow>");
		}else{
			if (hbrace && temp==strstr(temp,"<mover")){
				Insert(temp,"<mover accent=\"true\">");
				p("<mrow>");
			}else{
					Insert(temp,"<msub><mrow>");
					p("</mrow><mrow>");
			}
		}
	}
	if (mathOp) p("<mo>");
}

void endSubScript(){
	char*temp=strrchr(doc_math,0),*tail,*lock;
	if (mathOp) p("</mo>");
	p("</mrow>");
	
	temp=MatchTagLeft(temp,"<mrow");

	while (strstr(temp,"</mrow")!=temp) {
		if (temp!=doc_math) temp--;
		else die("error: can't reach first argument of 'subscript'\n");
	}
	temp=MatchTagLeft(temp,"<mrow");

	if (temp!=doc_math) {
		temp--;
		while (strstr(temp,"<")!=temp) temp--;
	}
	if (temp==strstr(temp,"</mrow>")){
		temp=MatchTagLeft(temp,"<mrow");
		if (temp!=doc_math) temp--;
		while (strstr(temp,"<")!=temp) {
			if (temp!=doc_math) temp--;
			else die("error: can't delimit first argument of 'subscript'\n");
		}
	}

	if (temp==strstr(temp,"<msubsup")){
		temp=strstr(temp,"<mrow>");
		temp=MatchTagRight(temp);
		lock=temp;
		temp=MatchTagRight(temp);
		tail=(char*)malloc(strlen(temp)+1);
		strcpy(tail,temp);
		*temp=0;
		Insert(lock,tail);
		free(tail);
		p("</msubsup>");
	}
	else
		if (temp==strstr(temp,"<munder")) p("</munder>");
		else {
			if (temp==strstr(temp,"<mover")) p("</mover>");
			else	p("</msub>");
		}
		
	if (mathOp) decorated=1;
}


void endSuperScript()
{
	char*temp=strrchr(doc_math,0);
	if (mathOp) p("</mo>");
	p("</mrow>");
	
	temp=MatchTagLeft(temp,"<mrow");

	while (strstr(temp,"</mrow")!=temp) {
		if (temp!=doc_math) temp--;
		else die("error:\n can't reach first argument of 'superscript'\n");
	}
	temp=MatchTagLeft(temp,"<mrow");

	if (temp!=doc_math) {
		temp--;
		while (strstr(temp,"<")!=temp) temp--;
	}
	if (temp==strstr(temp,"</mrow>")){
		temp=MatchTagLeft(temp,"<mrow");
		if (temp!=doc_math) temp--;
		while (strstr(temp,"<")!=temp) {
			if (temp!=doc_math) temp--;
			else die("error:\n can't delimit first argument of 'superscript'\n");
		}
	}
	
	if (temp==strstr(temp,"<munder")) p("</munder>");
	else {
		if (temp==strstr(temp,"<mover")) p("</mover>");
		else	p("</msup>");
	}
	
	if (mathOp) decorated=1;
}

void endMAccent(){
	char*temp=strrchr(doc_math,0),*tail;
	while (strstr(temp,"</mrow")!=temp) temp--;
	temp=MatchTagLeft(temp,"<mrow");
	tail=(char*)malloc(strlen(temp)+1);
	strcpy(tail,temp);*temp=0;
	while (strstr(temp,"</mrow")!=temp) {
		if (temp!=doc_math) temp--;
		else die("error in MAccent\n");
	}
	temp=MatchTagLeft(temp,"<mrow");
	Insert(temp,tail);
	free(tail);
}

void fixDigits(){
	char*temp=strrchr(doc_math,0);
	char dsep='.';
	//if there are previous digits don't put any <mn
	if (temp==doc_math){p("<mn>");return ;}
	while(*temp!='<'){
		temp--;
		if (temp==doc_math){p("<mn>");return ;}
	}
	if (temp==strstr(temp,"</mn>")) {
		*temp=0;return;
	}
	//if noninteger, unwrap the separator
	if (temp==strstr(temp,"</mo>")) {
		temp--;
		if (*temp=='.'){ //noninteger number, XXX localize separator
			dsep=*temp;
			temp=MatchTagLeft(temp,"<mo");
			temp--;
			if (temp==doc_math){p("<mn>");return ;}
			while(*temp!='<'){
				temp--;
				if (temp==doc_math){p("<mn>");return ;}
			}
		}
		if (temp==strstr(temp,"</mn")) {
			*temp++=dsep;
			*temp=0;
			return;			
		}
	}
	p("<mn>");
}

void precomposedNegative(unsigned int single, unsigned int composed){
//choose the precomposed negated operators where available
		if(combiningUnicode==0x0338) { 
				combiningUnicode=0;
				pmt(composed);
			}
		else	pmt(single);
}

void contractTextAccent(){
//mapping a character-accent combining pair into a single
//unicode character, if the accented character 
//is already available in the Unicode spec

	unsigned char*temp=(unsigned char*)strrchr(doc_text,0);
	unsigned char test=*(--temp);
	switch (test){
		case 'a':
			switch (combiningUnicode){
				case 0x0300:
					*temp=0;
					p(ul2utf8(0xE0));//a with grave
				break;
				case 0x0301:
					*temp=0;
					p(ul2utf8(0xE1));//a with acute
				break;
				case 0x030C:
					*temp=0;
					p(ul2utf8(0x01CE));//a with caron
				break;
				case 0x0306:
					*temp=0;
					p(ul2utf8(0x0103));//a with breve
				break;
				case 0x0304:
					*temp=0;
					p(ul2utf8(0x0101));//a with macron
				break;
				case 0x030A:
					*temp=0;
					p(ul2utf8(0x00E5));//a with ring above
				break;
				case 0x0302:
					*temp=0;
					p(ul2utf8(0xE2));//a with circumflex
				break;
				case 0x0307:
					*temp=0;
					p(ul2utf8(0x0227));//a with dot above
				break;
				case 0x0342:
					*temp=0;
					p(ul2utf8(0x00E3));//a with tilde
				break;
				case 0x0308:
					*temp=0;
					p(ul2utf8(0x00E4));//a with diaeresis
				break;
				default:
					p(ul2utf8(combiningUnicode)); //leave them combined 
			};
			break;
		case 'A':
			switch (combiningUnicode){
				case 0x0300:
					*temp=0;
					p(ul2utf8(0xC0));//A with grave
				break;
				case 0x0301:
					*temp=0;
					p(ul2utf8(0xC1));//A with acute
				break;
				case 0x030C:
					*temp=0;
					p(ul2utf8(0x01CD));//A with caron
				break;
				case 0x0306:
					*temp=0;
					p(ul2utf8(0x0102));//A with breve
				break;
				case 0x0304:
					*temp=0;
					p(ul2utf8(0x0100));//A with macron
				break;
				case 0x030A:
					*temp=0;
					p(ul2utf8(0x00C5));//A with ring above
				break;
				case 0x0302:
					*temp=0;
					p(ul2utf8(0xC2));//A with circumflex
				break;
				case 0x0307:
					*temp=0;
					p(ul2utf8(0x0226));//A with dot above
				break;
				case 0x0342:
					*temp=0;
					p(ul2utf8(0x00C3));//A with tilde
				break;
				case 0x0308:
					*temp=0;
					p(ul2utf8(0x00C4));//A with diaeresis
				break;
				default:
					p(ul2utf8(combiningUnicode)); //leave them combined 
			};
			break;
		case 'e':
			switch (combiningUnicode){
				case 0x0300:
					*temp=0;
					p(ul2utf8(0xE8));//a with grave
				break;
				case 0x0301:
					*temp=0;
					p(ul2utf8(0xE9));//e with acute
				break;
				case 0x030C:
					*temp=0;
					p(ul2utf8(0x011B));//e with caron
				break;
				case 0x0306:
					*temp=0;
					p(ul2utf8(0x0115));//e with breve
				break;
				case 0x0304:
					*temp=0;
					p(ul2utf8(0x0113));//e with macron
				break;
				case 0x0302:
					*temp=0;
					p(ul2utf8(0xEA));//e with circumflex
				break;
				case 0x0307:
					*temp=0;
					p(ul2utf8(0x0117));//e with dot above
				break;
				case 0x0308:
					*temp=0;
					p(ul2utf8(0xEB));//e with diaeresis
				break;
				default:
					p(ul2utf8(combiningUnicode)); //leave them combined 
			};
			break;
		case 'E':
			switch (combiningUnicode){
				case 0x0300:
					*temp=0;
					p(ul2utf8(0xC8));//E with grave
				break;
				case 0x0301:
					*temp=0;
					p(ul2utf8(0xC9));//E with acute
				break;
				case 0x030C:
					*temp=0;
					p(ul2utf8(0x011A));//E with caron
				break;
				case 0x0306:
					*temp=0;
					p(ul2utf8(0x0114));//E with breve
				break;
				case 0x0304:
					*temp=0;
					p(ul2utf8(0x0112));//E with macron
				break;
				case 0x0302:
					*temp=0;
					p(ul2utf8(0xCA));//E with circumflex
				break;
				case 0x0307:
					*temp=0;
					p(ul2utf8(0x0116));//E with dot above
				break;
				case 0x0308:
					*temp=0;
					p(ul2utf8(0x00CB));//E with diaeresis
				break;
				default:
					p(ul2utf8(combiningUnicode)); //leave them combined 
			};
			break;
		case 177://the dotless i case
			temp--;
			if (*(unsigned char*)temp==196){
				switch (combiningUnicode){
					case 0x0300:
						*temp=0;
						p(ul2utf8(0xEC));//i with grave
					break;
					case 0x0301:
						*temp=0;
						p(ul2utf8(0xED));//i with acute
					break;
					case 0x0302:
						*temp=0;
						p(ul2utf8(0xEE));//i with circumflex
					break;
					case 0x0304:
						*temp=0;
						p(ul2utf8(0x012B));//i with macron
					break;
					case 0x0306:
						*temp=0;
						p(ul2utf8(0x012D));//i with breve
					break;
					case 0x0307:
						*temp=0;
						p(ul2utf8(0x0131));//i with_out_ dot above
					break;
					case 0x0308:
						*temp=0;
						p(ul2utf8(0x00EF));//i with diaeresis
					break;
					case 0x030C:
						*temp=0;
						p(ul2utf8(0x01D0));//i with caron
					break;
					case 0x0342:
						*temp=0;
						p(ul2utf8(0x0129));//i with tilde
					break;
					default:
						p(ul2utf8(combiningUnicode)); //leave them combined 
				};
			}
			break;
		case 'I':
			switch (combiningUnicode){
				case 0x0300:
					*temp=0;
					p(ul2utf8(0xCC));//I with grave
				break;
				case 0x0301:
					*temp=0;
					p(ul2utf8(0xCD));//I with acute
				break;
				case 0x0302:
					*temp=0;
					p(ul2utf8(0xCE));//I with circumflex
				break;
				case 0x0304:
					*temp=0;
					p(ul2utf8(0x012A));//I with macron
				break;
				case 0x0306:
					*temp=0;
					p(ul2utf8(0x012C));//I with breve
				break;
				case 0x0307:
					*temp=0;
					p(ul2utf8(0x0130));//I with dot above
				break;
				case 0x030C:
					*temp=0;
					p(ul2utf8(0x01CF));//I with caron
				break;
				case 0x0342:
					*temp=0;
					p(ul2utf8(0x0129));//I with tilde
				break;
				case 0x0308:
					*temp=0;
					p(ul2utf8(0x00CF));//I with diaeresis
				break;
				default:
					p(ul2utf8(combiningUnicode)); //leave them combined 
			};
			break;
		case 'o':
			switch (combiningUnicode){
				case 0x0300:
					*temp=0;
					p(ul2utf8(0xF2));//o with grave
				break;
				case 0x0301:
					*temp=0;
					p(ul2utf8(0xF3));//o with acute
				break;
				case 0x0302:
					*temp=0;
					p(ul2utf8(0xF4));//o with circumflex
				break;
				case 0x0306:
					*temp=0;
					p(ul2utf8(0x014F));//o with breve
				break;
				case 0x0304:
					*temp=0;
					p(ul2utf8(0x014D));//o with macron
				break;
				case 0x0307:
					*temp=0;
					p(ul2utf8(0x022F));//o with dot above
				break;
				case 0x0308:
					*temp=0;
					p(ul2utf8(0x00F6));//o with diaeresis
				break;
				case 0x030B:
					*temp=0;
					p(ul2utf8(0x0151));//o with Hungarian umlaut
				break;
				case 0x030C:
					*temp=0;
					p(ul2utf8(0x01D2));//o with caron
				break;
				case 0x0342:
					*temp=0;
					p(ul2utf8(0x00F5));//o with tilde
				break;
				default:
					p(ul2utf8(combiningUnicode)); //leave them combined 
			};
			break;
		case 'O':
			switch (combiningUnicode){
				case 0x0300:
					*temp=0;
					p(ul2utf8(0xD2));//O with grave
				break;
				case 0x0301:
					*temp=0;
					p(ul2utf8(0xD3));//O with acute
				break;
				case 0x0302:
					*temp=0;
					p(ul2utf8(0xD4));//O with circumflex
				break;
				case 0x0304:
					*temp=0;
					p(ul2utf8(0x014C));//O with macron
				break;
				case 0x0306:
					*temp=0;
					p(ul2utf8(0x014E));//O with breve
				break;
				case 0x0307:
					*temp=0;
					p(ul2utf8(0x022E));//O with dot above
				break;
				case 0x0308:
					*temp=0;
					p(ul2utf8(0x00D6));//O with diaeresis
				break;
				case 0x030B:
					*temp=0;
					p(ul2utf8(0x0150));//O with Hungarian umlaut
				break;
				case 0x030C:
					*temp=0;
					p(ul2utf8(0x01D1));//O with caron
				break;
				case 0x0342:
					*temp=0;
					p(ul2utf8(0x00D5));//O with tilde
				break;
				default:
					p(ul2utf8(combiningUnicode)); //leave them combined 
			};
			break;
		case 'u':
			switch (combiningUnicode){
				case 0x0300:
					*temp=0;
					p(ul2utf8(0xF9));//u with grave
				break;
				case 0x0301:
					*temp=0;
					p(ul2utf8(0xFA));//u with acute
				break;
				case 0x030C:
					*temp=0;
					p(ul2utf8(0x01D4));//u with caron
				break;
				case 0x0306:
					*temp=0;
					p(ul2utf8(0x016D));//u with breve
				break;
				case 0x0304:
					*temp=0;
					p(ul2utf8(0x016B));//u with macron
				break;
				case 0x030A:
					*temp=0;
					p(ul2utf8(0x016F));//u with ring above
				break;
				case 0x0302:
					*temp=0;
					p(ul2utf8(0xFB));//u with circumflex
				break;
				case 0x030B:
					*temp=0;
					p(ul2utf8(0x0171));//u with Hungarian umlaut
				break;
				case 0x0308:
					*temp=0;
					p(ul2utf8(0x00FC));//u with diaeresis
				break;
				default:
					p(ul2utf8(combiningUnicode)); //leave them combined 
			};
			break;
		case 'U':
			switch (combiningUnicode){
				case 0x0300:
					*temp=0;
					p(ul2utf8(0xD9));//u with grave
				break;
				case 0x0301:
					*temp=0;
					p(ul2utf8(0xDA));//u with acute
				break;
				case 0x030C:
					*temp=0;
					p(ul2utf8(0x01D3));//u with caron
				break;
				case 0x0306:
					*temp=0;
					p(ul2utf8(0x016C));//u with breve
				break;
				case 0x0304:
					*temp=0;
					p(ul2utf8(0x016A));//u with macron
				break;
				case 0x030A:
					*temp=0;
					p(ul2utf8(0x016E));//u with ring above
				break;
				case 0x0302:
					*temp=0;
					p(ul2utf8(0xDB));//u with circumflex
				break;
				case 0x030B:
					*temp=0;
					p(ul2utf8(0x0170));//u with Hungarian umlaut
				break;
				case 0x0308:
					*temp=0;
					p(ul2utf8(0xDC));//u with diaeresis
				break;
				default:
					p(ul2utf8(combiningUnicode)); //leave them combined 
			};
			break;
		case 'c':
			switch (combiningUnicode){
				case 0x0301:
					*temp=0;
					p(ul2utf8(0x0107));//c with acute
				break;
				case 0x0302:
					*temp=0;
					p(ul2utf8(0x109));//c with circumflex
				break;
				case 0x0307:
					*temp=0;
					p(ul2utf8(0x010B));//c with dot above
				break;
				case 0x030C:
					*temp=0;
					p(ul2utf8(0x010D));//c with caron
				break;
				default:
					p(ul2utf8(combiningUnicode)); //leave them combined 
			};
			break;
		case 'C':
			switch (combiningUnicode){
				case 0x0301:
					*temp=0;
					p(ul2utf8(0x0106));//C with acute
				break;
				case 0x0302:
					*temp=0;
					p(ul2utf8(0x108));//C with circumflex
				break;
				case 0x0307:
					*temp=0;
					p(ul2utf8(0x010A));//C with dot above
				break;
				case 0x030C:
					*temp=0;
					p(ul2utf8(0x010C));//C with caron
				break;
				default:
					p(ul2utf8(combiningUnicode)); //leave them combined 
			};
			break;
		case 'd':
			switch (combiningUnicode){
				case 0x030C:
					*temp=0;
					p(ul2utf8(0x010F));//d with caron
				break;
				default:
					p(ul2utf8(combiningUnicode)); //leave them combined 
			};
			break;
		case 'D':
			switch (combiningUnicode){
				case 0x030C:
					*temp=0;
					p(ul2utf8(0x010E));//D with caron
				break;
				default:
					p(ul2utf8(combiningUnicode)); //leave them combined 
			};
			break;
		case 'g':
			switch (combiningUnicode){
				case 0x0302:
					*temp=0;
					p(ul2utf8(0x011D));//g with circumflex
				break;
				case 0x0306:
					*temp=0;
					p(ul2utf8(0x011F));//g with breve
				break;
				case 0x0307:
					*temp=0;
					p(ul2utf8(0x0121));//g with dot above
				break;
				case 0x0327:
					*temp=0;
					p(ul2utf8(0x0122));//g with cedilla
				break;
				default:
					p(ul2utf8(combiningUnicode)); //leave them combined 
			};
			break;
		case 'G':
			switch (combiningUnicode){
				case 0x0302:
					*temp=0;
					p(ul2utf8(0x011C));//G with circumflex
				break;
				case 0x0306:
					*temp=0;
					p(ul2utf8(0x011D));//G with breve
				break;
				case 0x0307:
					*temp=0;
					p(ul2utf8(0x0120));//G with dot above
				break;
				case 0x0327:
					*temp=0;
					p(ul2utf8(0x0122));//G with cedilla
				break;
				default:
					p(ul2utf8(combiningUnicode)); //leave them combined 
			};
			break;
		case 'h':
			switch (combiningUnicode){
				case 0x0302:
					*temp=0;
					p(ul2utf8(0x0125));//h with circumflex
				break;
				default:
					p(ul2utf8(combiningUnicode)); //leave them combined 
			};
			break;
		case 'H':
			switch (combiningUnicode){
				case 0x0302:
					*temp=0;
					p(ul2utf8(0x0124));//H with circumflex
				break;
				default:
					p(ul2utf8(combiningUnicode)); //leave them combined 
			};
			break;
		case 'k':
			switch (combiningUnicode){
				case 0x0327:
					*temp=0;
					p(ul2utf8(0x0137));//l with cedilla
				break;
				default:
					p(ul2utf8(combiningUnicode)); //leave them combined 
			};
			break;
		case 'K':
			switch (combiningUnicode){
				case 0x0327:
					*temp=0;
					p(ul2utf8(0x0136));//L with cedilla
				break;
				default:
					p(ul2utf8(combiningUnicode)); //leave them combined 
			};
			break;
		case 'l':
			switch (combiningUnicode){
				case 0x0301:
					*temp=0;
					p(ul2utf8(0x013A));//l with acute
				break;
				case 0x0327:
					*temp=0;
					p(ul2utf8(0x013C));//l with cedilla
				break;
				case 0x0337:
					*temp=0;
					p(ul2utf8(0x0142));//l with stroke
					inhibitspace=1;
				break;
				default:
					p(ul2utf8(combiningUnicode)); //leave them combined 
			};
			break;
		case 'L':
			switch (combiningUnicode){
				case 0x0301:
					*temp=0;
					p(ul2utf8(0x0139));//L with acute
				break;
				case 0x0327:
					*temp=0;
					p(ul2utf8(0x013B));//L with cedilla
				break;
				case 0x0337:
					*temp=0;
					p(ul2utf8(0x0141));//L with stroke
					inhibitspace=1;
				break;
				default:
					p(ul2utf8(combiningUnicode)); //leave them combined 
			};
			break;
		case 'n':
			switch (combiningUnicode){
				case 0x0300:
					*temp=0;
					p(ul2utf8(0x01F9));//n with grave
				break;
				case 0x0301:
					*temp=0;
					p(ul2utf8(0x0144));//n with acute
				break;
				case 0x030C:
					*temp=0;
					p(ul2utf8(0x0148));//n with caron
				break;
				case 0x0327:
					*temp=0;
					p(ul2utf8(0x0146));//n with cedilla
				break;
				case 0x0303:
					*temp=0;
					p(ul2utf8(0x00F1));//n with tilde
				break;
				default:
					p(ul2utf8(combiningUnicode)); //leave them combined 
			};
			break;
		case 'N':
			switch (combiningUnicode){
				case 0x0300:
					*temp=0;
					p(ul2utf8(0x01F8));//N with grave
				break;
				case 0x0301:
					*temp=0;
					p(ul2utf8(0x0143));//N with acute
				break;
				case 0x030C:
					*temp=0;
					p(ul2utf8(0x0147));//N with caron
				break;
				case 0x0327:
					*temp=0;
					p(ul2utf8(0x0145));//N with cedilla
				break;
				case 0x0342:
					*temp=0;
					p(ul2utf8(0x00D1));//n with tilde
				break;
				default:
					p(ul2utf8(combiningUnicode)); //leave them combined 
			};
			break;
		case 'r':
			switch (combiningUnicode){
				case 0x0301:
					*temp=0;
					p(ul2utf8(0x0155));//r with acute
				break;
				case 0x030C:
					*temp=0;
					p(ul2utf8(0x0159));//r with caron
				break;
				case 0x0327:
					*temp=0;
					p(ul2utf8(0x0157));//r with cedilla
				break;
				default:
					p(ul2utf8(combiningUnicode)); //leave them combined 
			};
			break;
		case 'R':
			switch (combiningUnicode){
				case 0x0301:
					*temp=0;
					p(ul2utf8(0x0154));//R with acute
				break;
				case 0x030C:
					*temp=0;
					p(ul2utf8(0x0158));//R with caron
				break;
				case 0x0327:
					*temp=0;
					p(ul2utf8(0x0156));//R with cedilla
				break;
				default:
					p(ul2utf8(combiningUnicode)); //leave them combined 
			};
			break;
		case 's':
			switch (combiningUnicode){
				case 0x0301:
					*temp=0;
					p(ul2utf8(0x15B));//s with acute
				break;
				case 0x0302:
					*temp=0;
					p(ul2utf8(0x15D));//s with circumflex
				break;
				case 0x030C:
					*temp=0;
					p(ul2utf8(0x0161));//s with caron
				break;
				case 0x0327:
					*temp=0;
					p(ul2utf8(0x015F));//S with cedilla
					//p(ul2utf8(0x0219));//S with comma
				break;
				default:
					p(ul2utf8(combiningUnicode)); //leave them combined 
			};
			break;
		case 'S':
			switch (combiningUnicode){
				case 0x0301:
					*temp=0;
					p(ul2utf8(0x15A));//S with acute
				break;
				case 0x0302:
					*temp=0;
					p(ul2utf8(0x15C));//S with circumflex
				break;
				case 0x030C:
					*temp=0;
					p(ul2utf8(0x0160));//S with caron
				break;
				case 0x0327:
					*temp=0;
					p(ul2utf8(0x015E));//S with cedilla
					//p(ul2utf8(0x0218));//S with comma
				break;
				default:
					p(ul2utf8(combiningUnicode)); //leave them combined 
			};
			break;
		case 't':
			switch (combiningUnicode){
				case 0x030C:
					*temp=0;
					p(ul2utf8(0x0165));//t with caron
				break;
				case 0x0327:
					*temp=0;
					p(ul2utf8(0x0163));//t with cedilla 
					//p(ul2utf8(0x021B));//t with comma
				break;
				default:
					p(ul2utf8(combiningUnicode)); //leave them combined 
			};
			break;
		case 'T':
			switch (combiningUnicode){
				case 0x030C:
					*temp=0;
					p(ul2utf8(0x0164));//T with caron
				break;
				case 0x0327:
					*temp=0;
					p(ul2utf8(0x0162));//T with cedilla
					//p(ul2utf8(0x021A));//T with comma
				break;
				default:
					p(ul2utf8(combiningUnicode)); //leave them combined 
			};
			break;
		case 'w':
			switch (combiningUnicode){
				case 0x0302:
					*temp=0;
					p(ul2utf8(0x0175));//w with circumflex
				break;
				default:
					p(ul2utf8(combiningUnicode)); //leave them combined 
			};
			break;
		case 'W':
			switch (combiningUnicode){
				case 0x0302:
					*temp=0;
					p(ul2utf8(0x0174));//w with circumflex
				break;
				default:
					p(ul2utf8(combiningUnicode)); //leave them combined 
			};
			break;
		case 'y':
			switch (combiningUnicode){
				case 0x0302:
					*temp=0;
					p(ul2utf8(0x0177));//y with circumflex
				break;
				case 0x0308:
					*temp=0;
					p(ul2utf8(0x00FF));//y with diaeresis
				break;
				default:
					p(ul2utf8(combiningUnicode)); //leave them combined 
			};
			break;
		case 'Y':
			switch (combiningUnicode){
				case 0x0302:
					*temp=0;
					p(ul2utf8(0x0176));//Y with circumflex
				break;
				case 0x0308:
					*temp=0;
					p(ul2utf8(0x0178));//Y with diaeresis
				break;
				default:
					p(ul2utf8(combiningUnicode)); //leave them combined 
			};
			break;
		case 'z':
			switch (combiningUnicode){
				case 0x0301:
					*temp=0;
					p(ul2utf8(0x017A));//z with acute
				break;
				case 0x0307:
					*temp=0;
					p(ul2utf8(0x017C));//z with dot above
				break;
				case 0x030C:
					*temp=0;
					p(ul2utf8(0x017E));//z with caron
				break;
				default:
					p(ul2utf8(combiningUnicode)); //leave them combined 
			};
			break;
		case 'Z':
			switch (combiningUnicode){
				case 0x0301:
					*temp=0;
					p(ul2utf8(0x0179));//Z with acute
				break;
				case 0x0307:
					*temp=0;
					p(ul2utf8(0x017B));//z with dot above
				break;
				case 0x030C:
					*temp=0;
					p(ul2utf8(0x017D));//z with caron
				break;
				default:
					p(ul2utf8(combiningUnicode)); //leave them combined 
			};
			break;
		case 0x01://holder for big circle in cmsy, this is for the copyright symbol
			switch (combiningUnicode){//this should be 'c'
				case 'c':
					*temp=0;
					p(ul2utf8(0x00A9));//copyright sign
				break;
				default:
					p(ul2utf8(combiningUnicode)); //leave them combined 
			};
			break;
		default:
			p(ul2utf8(combiningUnicode)); //leave them combined 
	}
	combiningUnicode=0;
}

void AddPHint(int start){
	char* temp;
	if (!fakesp){strcat(doc_text," ");fakesp=1;}
	if (!pHints || (mathmode && !mathText)) return;
	if (start){
		strcat(doc_text,"<ph f=\""); strcat(doc_text,theFont.name);strcat(doc_text,"\">");
		pHint++;	//allow nested elements containing phints
	}	else{
		if (pHint){
			temp=strrchr(doc_text,0);
			if (temp!=doc_text){
				temp--;
				if (temp!=doc_text && *temp=='>'){
					do{
						temp--;
					}while(temp!=doc_text && *temp!='<');
					
					if (temp==strstr(temp,"<ph ")) {
						*temp=0;
						pHint--;
						return;
					}
				}
			}
			strcat(doc_text,"</ph>");pHint--;
		}
	}
}

void printFigureFileName(){
	char*filename=(char*)malloc(strlen(yytext)+1), *temp;
	temp=strstr(yytext," figFileName: ")+strlen(" figFileName: ");
	if (temp==NULL) die("\nin epsffile, expected ' figFileName: '\n");
	strcpy(filename,temp);
	temp=strrchr(filename,'.');
	if (temp) 
		*temp=0;
	else
		*strstr(filename," :figFileName ")=0;
	AddPHint(0);
	p("<source>");
	p(filename);
	p("</source>");
	free(filename);
	AddPHint(1);
}

void printEPSFigureFileName(){
	char*filename=(char*)malloc(strlen(yytext)+1), *temp;
	temp=strstr(yytext,"file=")+strlen("file=");
	if (temp==NULL) die("\nin epsfig, expected 'file='\n");
	strcpy(filename,temp);
	temp=strrchr(filename,'.');
	if (temp) 
		*temp=0;
	else
		*strstr(filename," :epsfigFileName ")=0;
	AddPHint(0);
	p("<source>");
	p(filename);
	p("</source>");
	AddPHint(1);
	free(filename);
}

void printRef(){
	char*ref=(char*)malloc(strlen(yytext)+1), *temp;
	char s[5]="";
	strcpy(ref,strstr(yytext,"@")+1);
	*strrchr(ref,'@')=0;
	temp=ref;
	p("<sref>");
	while(*temp){
		switch (*temp){
		case '<':
			strcpy(s,"&lt;");
			break;
		case '>':
			strcpy(s,"&gt;");
			break;
		default:
			*s=*temp;
			s[1]=0;
		}
		p(s);
		temp++;
	}	
	p("</sref>");
	free(ref);
}

void printId(){
	char*label=(char*)malloc(strlen(yytext)+1), *temp;
	char s[5]="";
	strcpy(label,strstr(yytext,"@")+1);
	*strrchr(label,'@')=0;
	temp=label;
	p("<id>");
	while(*temp){
		switch (*temp){
		case '<':
			strcpy(s,"&lt;");
			break;
		case '>':
			strcpy(s,"&gt;");
			break;
		default:
			*s=*temp;
			s[1]=0;
		}
		p(s);
		temp++;
	}	
	p("</id>");
	free(label);
}

void printOption(){
	char*option;
	if (!mathmode){
		option=(char*)malloc(strlen(yytext)+1);
		strcpy(option,strstr(yytext,":")+1);
		*strrchr(option,':')=0;
		p("<option>");
		p(option);
		p("</option>");
		free(option);
	}
}

void printFType(){
	char*type=(char*)malloc(strlen(yytext)+1);
	strcpy(type,strstr(yytext,":")+1);
	*strrchr(type,':')=0;
	p("<type>");
	p(type);
	p("</type>");
	free(type);
}


void printAbsLang(){
	char*label=(char*)malloc(strlen(yytext)+1);
	strcpy(label,strstr(yytext,"@")+1);
	*strrchr(label,'@')=0;
		AddPHint(0);
		p("<language type=\"");
		p(label);
		p("\"/>");
		AddPHint(1);
	free(label);
}

void printBkgColor(){
	char*label=(char*)malloc(strlen(yytext)+1);
	strcpy(label,strstr(yytext,"@")+1);
	*strrchr(label,'@')=0;
	AddPHint(0);
	p("<background color=\"");
	p(label);
	p("\"/>");
	AddPHint(1);
	free(label);
}

void printEnvType(){
	char*type=(char*)malloc(strlen(yytext)+1);
	strcpy(type,strstr(yytext,"@")+1);
	*strrchr(type,'@')=0;
	p("<type>");
	p(type);
	p("</type>");
	free(type);
}

void printSectType(){
	char*ref=(char*)malloc(strlen(yytext)+1);
	strcpy(ref,strstr(yytext,":")+1);
	*strrchr(ref,':')=0;
	p("<type>");
	p(ref);
	p("</type>");
	free(ref);
}

void printCiteSRef(){
	char* peek,*temp,*ref;
	int commas=0;
	peek=yytext;
	while((peek=strchr(peek,','))){
		commas++;peek++;
	}
	ref=(char*)malloc(strlen(yytext)+commas*strlen("</sref><sref>")+1);
	p("<sref>");
	peek=strchr(yytext,'@')+1;
	temp=ref;
	while (*peek!='@'){
		if (*peek==' '){ 
			peek++; continue;
		}
		if (*peek==','){
			strcpy(temp,"</sref><sref>");
			temp=strrchr(temp,0);
		}else
			*temp++=*peek;
		peek++;
	}
	*temp=0;
	p(ref);
	p("</sref>");
	free(ref);
}

void wrap(int open){
//pops/inserts phantom parentheses to fix the 
//well-formedness of math spread over cells
int i;
char* temp;
//fprintf (stderr,"%d,%s\n",open, doc_math);
	if (open>0){
		for (i=0;i<Wraps[depth];i++)
			p("<mrow><mrow>");
		return;
	}
	if (open==0){
		for (i=0;i<Wraps[depth];i++)
			p("</mrow></mrow>");
		return;
	}
	if (open<0){
		if ((temp=strstr(doc_math,"<mtd"))){
			temp=strchr(temp,'>'); temp++;
			Insert(temp,"<mrow><mrow>");
		}else
			Insert(doc_math,"<mrow><mrow>");
		return;
	}
}