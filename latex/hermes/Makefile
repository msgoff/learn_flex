all:
	lex hermes.l
	yacc -d hermes.y
	gcc -c *.c
	gcc -o test *.o -lfl
