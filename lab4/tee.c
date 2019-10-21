#include <stdio.h>
#include <string.h>
#include <stdlib.h>
//read from standard input and write to standard output and files
int main(int argc, char **argv) {
    //printf("%s %d\n", argv[argc-1], argc);
	if(argc==1){
		system("tee");
	}else{
		char string[100000]="";
		strncat(string, "tee",4);
		for(int i=0;i<argc;i++){
			strncat(string, " ",2);
			strncat(string, argv[i], 255);
		}
		system(string);
	}
	return 0;
}
