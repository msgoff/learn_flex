all:
	flex flex_template.l
	gcc xxhash.c main.c lex.template.c -lfl

clean:
	rm lex.template.c
	rm template.h
	rm a.out
