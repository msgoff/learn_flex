gmp:
	sudo apt install lunzip
	wget https://gmplib.org/download/gmp/gmp-6.2.1.tar.lz
	lunzip gmp-6.2.1.tar.lz
	tar -xf gmp-6.2.1.tar
	cd gmp-6.2.1 && ./configure && make && make check && sudo make install 

install_flex:
	sudo apt install texinfo
	sudo apt install help2man
	sudo apt install autopoint
	sudo apt install bison
	git clone https://github.com/westes/flex
	cd flex && bash autogen.sh && ./configure && make && sudo make install && sudo cp src/flex /usr/bin/

sds:
	git clone https://github.com/antirez/sds.git
	cp sds/sds* . 

edit_distance:
	flex -Cf edit_distance.l
	gcc -lfl -g lex.yy.c sds.c -lm -o edit_distance.out
	./edit_distance.out < edit_distance_test
