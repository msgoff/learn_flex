#include "utils.h"
#include <stdio.h>
int main(int argc, char* argv[]){
	if(argc==2){
	char *fp;	
	fp = ReadFile(argv[1]);
	if(fp){
		printf("%s",fp);
	}
	} else {
		printf("arg1:file_name\n");
	}
	return 0;
}
