all:
	flex 1.l
	gcc -lfl lex.yy.c sds.c
	./a.out
clean:
	rm -f a.out
	rm -f lex.yy.c

