install_flex:
	sudo apt install libtool
	sudo apt install autopoint
	sudo apt install texinfo
	sudo apt install help2man
	git clone https://github.com/westes/flex
	cd flex && bash autogen.sh && ./configure && make && sudo make install && sudo cp src/flex /usr/bin/

install_sds:
	git clone https://github.com/antirez/sds
	cp sds/sds* .

base:
	flex -CFa scanner.l
	gcc -g -O3 lex.S1_.c  main.c -lfl -o mmap_flex.out 
	./mmap_flex.out test

clean:
	rm mmap_flex.out
	rm lex.S1_.c
	rm base_flex.h
