#include <ctype.h>
#include <err.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <unistd.h>
#include "globals.h"
#include "S1_flex.h"
#include "S2_flex.h"
#ifndef array
	#define ARRAY_MAX_LEN 10000
	sds checksum_s1[ARRAY_MAX_LEN];
	sds filepath_s1[ARRAY_MAX_LEN];
	int array_idx_s1;
	sds checksum_s2[ARRAY_MAX_LEN];
	sds filepath_s2[ARRAY_MAX_LEN];
	int array_idx_s2;
#endif

int main(int argc, char **argv) {
  if(argc!=3){
  	printf("input two files of sha256 sums");
	return -1;
  }
  struct stat s;
  char *buffer;
  int fd;
  fd = open(argv[1], O_RDONLY);
  if (fd < 0)
    return EXIT_FAILURE;
  fstat(fd, &s);
  /* PROT_READ disallows writing to buffer: will segv */
  buffer = mmap(0, s.st_size, PROT_READ, MAP_PRIVATE, fd, 0);
  //read file ok -> then process with flex
  if (buffer != (void *)-1) {
    yybuffer buff1;
    buff1 = S1__scan_string(buffer);
    S1__switch_to_buffer(buff1);
    S1_lex();
    S1__delete_buffer(buff1);
    munmap(buffer, s.st_size);
  }
  close(fd);
  fd = open(argv[2], O_RDONLY);
  if (fd < 0)
    return EXIT_FAILURE;
  fstat(fd, &s);
  /* PROT_READ disallows writing to buffer: will segv */
  buffer = mmap(0, s.st_size, PROT_READ, MAP_PRIVATE, fd, 0);
  //read file ok -> then process with flex
  if (buffer != (void *)-1) {
    yybuffer buff2;
    buff2 = S2__scan_string(buffer);
    S2__switch_to_buffer(buff2);
    S2_lex();
    S2__delete_buffer(buff2);
    munmap(buffer, s.st_size);
  }
  close(fd);
  for(int i =0;i<array_idx_s1;i++){
  	for(int j=0;j<array_idx_s2;j++){
		if(strcmp(checksum_s1[i],checksum_s2[j]) == 0){
			printf("\n%s->\t%s",filepath_s1[i],filepath_s2[j]);
		}
	}
  }      
  for(int i =0;i<array_idx_s1;i++){
  	sdsfree(checksum_s1[i]);
  	sdsfree(filepath_s1[i]);
  }
  
  for(int j =0;j<array_idx_s2;j++){
  	sdsfree(checksum_s2[j]);
  	sdsfree(filepath_s2[j]);
  }

   return 0;
}
