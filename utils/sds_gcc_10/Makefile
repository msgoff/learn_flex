all: sds-test

sds-test: sds.c sds.h testhelp.h
	$(CC) -o sds-test sds.c -Wall -std=c99 -pedantic -O2 -DSDS_TEST_MAIN
	@echo ">>> Type ./sds-test to run the sds.c unit tests."
	sed -i 's/const char \*SDS_NOINIT/extern const char *SDS_NOINIT/g' sds.h

clean:
	rm -f sds-test
