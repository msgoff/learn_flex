all:
	rm -rf *.c
	rm -rf *.o
	rm -rf a.out
	lex ch3-01.l
	yacc -d ch3-01.y
	gcc -c *.c
	gcc *.o -lfl
