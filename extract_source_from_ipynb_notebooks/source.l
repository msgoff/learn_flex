%{
int balanced;
int count;
char filename[256];
char results_filename[256];
int print_count;
int prefix_comment;
%}
%{
int balanced;
int count;
char filename[256];
char results_filename[256];
int print_count;

%}

%x SOURCE CELL_TYPE
%%

^[ ]+\"cell_type\"":"[ ]+ 	{ BEGIN(CELL_TYPE); }
<CELL_TYPE>\"markdown\" 	{ prefix_comment=1; BEGIN(0); }
<CELL_TYPE>\"code\" 		{ prefix_comment=0; BEGIN(0); }


^[ ]+\"source\"":"[ ]+"["  {
	yymore();
	balanced--;
	BEGIN(SOURCE);
}

<SOURCE>"[" { yymore(); balanced--;}
<SOURCE>"]" { balanced++; if(balanced==0){
		if(print_count==0){
			fprintf(yyout,"%s\n",yytext);
		}
		count++;
		BEGIN(0);
	} else { 
		yymore();
	}
}
<SOURCE>^[ ]+\"\\n\"	;
<SOURCE>. { yymore(); }
<SOURCE>\n {
	if(prefix_comment==1){ 
	char tmp[yyleng+2]; 
	memset(tmp,'\0',yyleng+2); strncpy(tmp,yytext,yyleng-1); strcat(tmp,"\n#"); 
	printf("%s\n",tmp);
	fprintf(yyout,tmp);
} else {
	yymore();
}
}

.	;
\n	;
%%
int main(int argc, char** argv){
        //argument 1, filename, required
        //argument 2, count only, optional
        if(argc==3 && strcmp(argv[2],"--count")==0){
                print_count=1;
        }
        memset(filename,'\0',256);
        memset(results_filename,'\0',256);
        if(strlen(argv[1])<256){
                strcpy(filename,argv[1]);
        } else {exit(-1);}
        strncpy(results_filename,argv[0],strlen(argv[0])-4); //remove the file extension
        strcat(results_filename,".csv");
        //printf("%s",results_filename);
        yyin=fopen(argv[1],"r");
        yyout=fopen(results_filename,"a+");
        yylex();
        if(argc==3 && strcmp(argv[2],"--count")==0){
                printf("%d",count);
        }
        return 0;
}

