install_flex:
	sudo apt install texinfo
	sudo apt install help2man
	git clone https://github.com/westes/flex
	cd flex && bash autogen.sh && ./configure && make && make install && sudo cp src/flex /usr/bin/

base:
	flex -CFa scanner.l
	gcc -O3 lex.S1_.c main.c -lfl -o mmap_flex.out 


