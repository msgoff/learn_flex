#include <stdio.h>
#include "xxhash.h"

int main() {
  XXH64_hash_t const seed = 0;
  char f[1];
  f[0] = 'a';
  size_t i = 0;
  for (i; i < 40000000; i++) {
    XXH64_hash_t hash = XXH64(f, sizeof(f), seed);
    //printf("%016llx\n", (unsigned long long)hash);
  }
  return 0;
}
