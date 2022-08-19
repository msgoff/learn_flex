gmp:
	wget https://gmplib.org/download/gmp/gmp-6.2.1.tar.lz


install_flex:
	sudo apt install texinfo
	sudo apt install help2man
	git clone https://github.com/westes/flex
	cd flex && bash autogen.sh && ./configure && make && sudo make install && sudo cp src/flex /usr/bin/

