all:
	flex edit_distance.l
	gcc -lfl lex.yy.c sds.c
	./a.out edit_distance_test

clean:
		rm a.out
		rm lex.yy.c
