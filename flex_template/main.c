#include "xxhash.h"
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <unistd.h>
#include "xxhash.h"
#include "template.h"


char *buffer;
struct stat s;

/* hash a symbol */
static unsigned long long tokenHash(char token[]) {
  XXH64_hash_t const seed = 0;

  XXH64_hash_t hash = XXH64(token, strlen(token) * sizeof(*token), seed);
  return hash;
}

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
		  buf = template_scan_string(buffer);
		  template_switch_to_buffer(buf);
	    	  templatelex();
		  // fwrite(buffer, s.st_size, 1, stdout);
    printf("%016llx:%s\n", tokenHash(buffer), buffer);
    munmap(buffer, s.st_size);
	   	  
	  }

	  close(fd);
  
	return EXIT_SUCCESS;
}
