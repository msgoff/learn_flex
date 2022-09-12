%{

char filename[256];
%}

%%
0	{
		char mvcmd[256];
		memset(mvcmd,'\0',256);
		strcat(mvcmd,"rsync -axr ");
		strcat(mvcmd,filename);
		strcat(mvcmd," trash/ --remove-source-files");
		FILE *fp;
		fp=popen(mvcmd,"r");
		pclose(fp);
		return 0;
		}

1	{
		char mvcmd[256];
		memset(mvcmd,'\0',256);
		strcat(mvcmd,"rsync -axr ");
		strcat(mvcmd,filename);
		strcat(mvcmd," keep/  --remove-source-files");
		FILE *fp;
		fp=popen(mvcmd,"r");
		pclose(fp);
		return 0;
	}
q	{ return 0; }
\n	;

%%


int main(int argc, char** argv){

	if(argc!=2) return -1;
	memset(filename,'\0',256);
	strcpy(filename,argv[1]);


	char cmd[256];
	memset(cmd,'\0',256);
	printf("make 2 directories, keep, trash, pass a file as an argument. 0 for trash, anything else for keep");
	strcpy(cmd,"xpdf ");
	strcat(cmd,argv[1]);
	FILE *fp;
	fp=popen(cmd,"r");
	pclose(fp);
	printf("keep,trash,1,0\n?");
	yylex();

	

}
