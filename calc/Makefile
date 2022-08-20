all:
	bison -d expr.y
	flex expr.l
	gcc expr.tab.c lex.yy.c -lm -lfl
