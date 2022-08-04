#install_flex:
#	git clone https://github.com/westes/flex
#	cd flex && bash autogen.sh && ./configure && make && make install

all:
	flex -CFa scanner.l
	gcc -O3 lex.S1_.c main.c -lfl -o mmap_flex.out 


