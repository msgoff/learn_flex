#include <stdio.h>
#include <string.h>
int main(){

	int arr[26][1];
	char *test;
	test="hello this is a test";
	int i = 0;
	int ws = 0;
	memset(arr, 0, sizeof(arr));
	for(i=0;i<strlen(test);i++){
		if(((test[i]-97) >=0) && ((test[i]-97) < 26)){
			arr[test[i]-97][0]++;
		}
	}
	
	for(i=0;i<26;i++){
		if(arr[i][0] > 0){
			printf("%c:%d    ",i+97,arr[i][0]);
			ws+=4;
			if(ws>=80){
				printf("\n");
				ws=0;
			}
		}
	}
	
	printf("\n");
	return 0;
}
