#include "xxhash.h"
#include <stdio.h>
#include <string.h>

/* hash a symbol */
static unsigned long long tokenHash(char token[]) {
  XXH64_hash_t const seed = 0;
  XXH64_hash_t hash = XXH64(token, strlen(token) * sizeof(*token), seed);
  return hash;
}

int main() {
  char f[10];
  memcpy(f, "hello",strlen("hello"));
  printf("%016llx", tokenHash(f));
  return 0;
}
