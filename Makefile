all:
	flex -CFa scanner.l
	gcc -O3 lex.S1_.c main.c -lfl -o mmap_flex.out 


