# learn_flex

Learning how to write lexers and parsers with Flex. 
I have learned the most about flex by exploring the test cases 
https://github.com/westes/flex/tests
	alloc_extra_c99.l
	alloc_extra_nr.l
	bison_nr_scanner.l
	bison_yylloc_scanner.l
	bison_yylval_scanner.l
	c_cxx_nr.lll
	c_cxx_r.lll
	cxx_basic.ll
	cxx_multiple_scanners_1.ll
	cxx_multiple_scanners_2.ll
	cxx_restart.ll
	cxx_yywrap.ll
	header_nr_scanner.l
	header_r_scanner.l
	include_by_buffer.direct.l
	include_by_push.direct.l
	include_by_reentrant.direct.l
	mem_c99.l
	mem_nr.l
	mem_r.l
	multiple_scanners_nr_1.l
	multiple_scanners_nr_2.l
	multiple_scanners_r_1.l
	multiple_scanners_r_2.l
	prefix_c99.l
	prefix_nr.l
	prefix_r.l
	pthread.l
	quotes.l
	rescan_nr.direct.l
	rescan_r.direct.l
	state_buf.direct.lll
	state_buf_multiple.direct.lll
	string_c99.l
	string_nr.l
	string_r.l
	top.l
	yyextra_c99.l
	yyextra_nr.l
	yywrap_r.i3.l


A good example of a calculator and how to use Flex  
gmp-6.2.1/demos/calc/calclex.l  


C++ RE-flex is compatiable with flex and has several good examples in RE-flex/examples directory
https://github.com/Genivia/RE-flex.git 

for more advanced examples 
please see postgres and yara 
https://github.com/postgres/postgres
	./src/fe_utils/psqlscan.l
	./src/interfaces/ecpg/preproc/pgc.l
	./src/bin/psql/psqlscanslash.l
	./src/bin/pgbench/exprscan.l
	./src/backend/utils/adt/jsonpath_scan.l
	./src/backend/utils/misc/guc-file.l
	./src/backend/replication/syncrep_scanner.l
	./src/backend/replication/repl_scanner.l
	./src/backend/bootstrap/bootscanner.l
	./src/backend/parser/scan.l
	./src/test/isolation/specscanner.l
	./contrib/seg/segscan.l
	./contrib/cube/cubescan.l


https://github.com/virustotal/yara
	./libyara/hex_lexer.l  
	./libyara/re_lexer.l  
	./libyara/lexer.l 


Most of the grammars here are action-free and with a few modifications can be made to work with flex. 
https://github.com/antlr/grammars-v4 



