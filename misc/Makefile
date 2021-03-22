1:
	flex -Cf 1.l
	gcc -lfl lex.yy.c ../utils/sds_gcc_10/sds.c -I ../utils/sds_gcc_10/


read_file:
	gcc read_file.c test_read_file.c

python_3_7:
	rm -rf call_python
	rm -rf /tmp/some_file
	touch /tmp/some_file
	echo "hello\nworld" > /tmp/some_file
	gcc call_python.c -L/usr/lib/python3.7/config-3.7m-x86_64-linux-gnu -L/usr/lib -lpython3.7m -lcrypt -lpthread -ldl  -lutil -lm  -Xlinker -export-dynamic -Wl,-O1 -Wl,-Bsymbolic-functions -I/usr/local/include -I/usr/include/python3.7m/ -o call_python
	./call_python
python_3_6:
	rm -rf call_python
	rm -rf /tmp/some_file
	touch /tmp/some_file
	echo "hello\nworld" > /tmp/some_file
	gcc call_python.c  -L/usr/lib/python3.6/config-3.6m-x86_64-linux-gnu -L/usr/lib -lpython3.6m -lpthread -ldl  -lutil -lm  -Xlinker -export-dynamic -Wl,-O1 -Wl,-Bsymbolic-functions -I/usr/include/python3.6m/ -o call_python
	./call_python
