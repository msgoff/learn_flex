all:
	sudo apt install libncursesw5-dev -y
	sudo apt install libprotobuf-dev -y
	sudo apt install libprotobuf-c-dev  -y
	sudo apt install protobuf-c-compiler  -y
	sudo apt install protobuf-compiler  -y
	sudo apt install pkg-config  -y
	sudo apt install libbsd-dev -y
	sudo apt install iproute2 -y
	sudo apt install libnftables-dev  -y
	sudo apt install libcap-dev -y
	sudo apt install libnet1-dev -y
	sudo apt install libaio-dev -y
	sudo apt install asciidoc xmlto libnl-3-dev libcap-dev -y
	git clone https://github.com/checkpoint-restore/criu.git
	@cd criu && make && sudo make install
