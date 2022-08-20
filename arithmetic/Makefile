get_max:
	flex get_max.l
	gcc -lfl lex.yy.c 
	./a.out <get_max_test

parser:
	rm -rf *.o
	rm -rf *.c
	rm -rf *.h
	lex symbol_table.l
	yacc -d expression_parser.y
	gcc -c lex.yy.c y.tab.c
	gcc -o expression_validation lex.yy.o y.tab.o -lfl
