%{



char * int_defs[3];
%}

%s c_code

%%
c_ { BEGIN(c_code);}

<c_code>_header {
int_defs[0] = "\tint i;";
int_defs[1] = "\tint j;";
int_defs[2] = "\tint k;";
	FILE * fp;
	fp = fopen("/tmp/c_code.c","w");
	fprintf(fp,"#include <stdio.h>\n");
	fprintf(fp,"\n");
	fprintf(fp,"int main(int argc,char* argv[]){\n");
	fprintf(fp,int_defs[0]);
	fprintf(fp,"\n");
	fprintf(fp,int_defs[1]);
	fprintf(fp,"\n");
	fprintf(fp,int_defs[2]);
	fprintf(fp,"\n");

	fclose(fp);
	}


<c_code>_footer {
	FILE * fp;
	fp = fopen("/tmp/c_code.c","a");
	fprintf(fp,"\treturn 0;");
	fprintf(fp,"\n");
	fprintf(fp,"}\n");
	fclose(fp);
}


<c_code>_for {
	FILE * fp;
	fp = fopen("/tmp/c_code.c","a");
	fprintf(fp,"\tfor(;;){\n\t}\n");
	fclose(fp);
	}


.	;
\n	;
	
%%

int main(){
	yylex();
	return 0;
}
