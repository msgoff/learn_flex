all:
	git clone https://github.com/antirez/sds
	cp sds/sds* .
	flex -CFa s1.l
	flex -CFa s2.l
	gcc -O3 -g lex.S1_.c lex.S2_.c main.c sds.c -lfl -o mmap_flex.out 

clean:
	rm lex*
	rm S*
	rm *.out
