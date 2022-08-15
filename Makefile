install_flex:
	sudo apt install texinfo
	sudo apt install help2man
	sudo apt install libtool
	sudo apt install autopoint
	sudo apt install bison
	git clone https://github.com/westes/flex
	cd flex && bash autogen.sh && ./configure && make && sudo make install && sudo cp src/flex /usr/bin/

install_sds:
	git clone https://github.com/antirez/sds
	cp sds/sds* .

base:
	flex -d -CFa scanner.l
	gcc -O3 lex.S1_.c basic_resub.c main.c -lfl -o mmap_flex.out 
	./mmap_flex.out test
