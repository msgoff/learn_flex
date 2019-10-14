# learn_flex

String Library for C  
https://github.com/antirez/sds.git   

run make and that will start a repl like environment  

make
flex 1.l
gcc -lfl lex.yy.c sds.c
./a.out
#input  
some_string_1 = 5                  
#output  
some__replace_stringring_1 = 5


or you can run ./a.out <some_file  for transformations to be completed against a file  
