all:
	lex read_file.l
	gcc -lfl lex.yy.c sds.c
	./a.out test.tex
