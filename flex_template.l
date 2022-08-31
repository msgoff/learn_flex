%{
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <unistd.h>

char *buffer;
struct stat s;

%}

%%


%%


int main(int argc, char **argv) {
	
	  if(argc!=2) return -1;
	  YY_BUFFER_STATE buf;

	  int fd = open(argv[1], O_RDONLY);
	  if (fd < 0)
	    return EXIT_FAILURE;
	  fstat(fd, &s);
	  /* PROT_READ disallows writing to buffer: will segv */
	  buffer = mmap(0, s.st_size, PROT_READ, MAP_PRIVATE, fd, 0);

	  if (buffer != (void *)-1) {
		  buf = yy_scan_string(buffer);
		  yy_switch_to_buffer(buf);
	    	  yylex();
		  // fwrite(buffer, s.st_size, 1, stdout);
		  munmap(buffer, s.st_size);
	   	  
	  }

	  close(fd);
  
	return EXIT_SUCCESS;
}
