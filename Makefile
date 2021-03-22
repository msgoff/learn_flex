find:
	flex -Cf -8 find.l
	gcc -lfl -O3 lex.yy.c
