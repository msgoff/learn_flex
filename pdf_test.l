%{
//currently only filters out pdfs that are encrypted according to poppler-utils pdfinfo
char filename[256];
int title_matched=0;
int subject_matched=0;
int keywords_matched=0;
int author_matched=0;
int creator_matched=0;
int producer_matched=0;
int creationdate_matched=0;
int moddate_matched=0;
int tagged_matched=0;
int userproperties_matched=0;
int suspects_matched=0;
int form_matched=0;
int javascript_matched=0;
int pages_matched=0;
int encrypted_matched=0;
int page_size_matched=0;
int page_rot_matched=0;
int file_size_matched=0;
int optimized_matched=0;
int pdf_version_matched=0;

typedef struct Pdfinfo {
char title[256];
char subject[256];
char keywords[256];
char author[256];
char creator[256];
char producer[256];
char creationdate[256];
char moddate[256];
char tagged[256];
char userproperties[256];
char suspects[256];
char form[256];
char javascript[256];
char pages[256];
char encrypted[256];
char page_size[256];
char page_rot[256];
char file_size[256];
char optimized[256];
char pdf_version[256];


} Pdfinfo;


void update_Pdfinfo(char* field,char* text){
	strcpy(field,"asdf");

}

void print_Pdfinfo(Pdfinfo* testcase){
	
	printf("%s",testcase->title);
	printf("%s",testcase->subject);
	// printf("%s",testcase->keywords);
	// printf("%s",testcase->author);
	// printf("%s",testcase->creator);
	// printf("%s",testcase->producer);
	// printf("%s",testcase->creationdate);
	// printf("%s",testcase->moddate);
	// printf("%s",testcase->tagged);
	// printf("%s",testcase->userproperties);
	// printf("%s",testcase->suspects);
	// printf("%s",testcase->form);
	// printf("%s",testcase->javascript);
	// printf("%s",testcase->pages);
	// printf("%s",testcase->encrypted);
	// printf("%s",testcase->page_size);
	// printf("%s",testcase->page_rot);
	// printf("%s",testcase->file_size);
	// printf("%s",testcase->optimized);
	// printf("%s",testcase->pdf_version);
}




%}










%%


"Tagged:         no"	{ ; }
"UserProperties: no"	{ ; }
"Suspects:       no"	{ ; }
"JavaScript:     no"	{ ; }
	
"Page rot:       0"	{ ; }
"Optimized:      no"	{ ; }

Subject:[ ]+ { BEGIN(0); }
Keywords:[ ]+ { BEGIN(0); }
Author:[ ]+ { BEGIN(0); }
Creator:[ ]+ { BEGIN(0); }
Producer:[ ]+ { BEGIN(0); }
CreationDate:[ ]+ { BEGIN(0); }
ModDate:[ ]+ { BEGIN(0); }
Tagged:[ ]+ { BEGIN(0); }
UserProperties:[ ]+ { BEGIN(0); }
Suspects:[ ]+ { BEGIN(0); }
Form:[ ]+ { BEGIN(0); }
JavaScript:[ ]+yes { 
	printf("JavaScript detected");	
	char cmd[128];
	memset(cmd,'\0',128);
	strcpy(cmd,"rsync -axr --progress --remove-source-files ");
	strcat(cmd,filename);
	strcat(cmd," /dev/shm/javascript_pdfs/");
	FILE* cptr;
	cptr=popen(cmd,"r");
	pclose(cptr);

}
Pages:[ ]+ { BEGIN(0); }
Encrypted:[ ]+yes {
	printf("PDF is Encrypted");	
	char cmd[128];
	memset(cmd,'\0',128);
	strcpy(cmd,"rsync -axr --progress --remove-source-files ");
	strcat(cmd,filename);
	strcat(cmd," /dev/shm/encrypted_pdfs/");
	FILE* cptr;
	cptr=popen(cmd,"r");
	pclose(cptr);
}
Page[ ]+size:[ ]+ { BEGIN(0); }
Page[ ]+rot:[ ]+ { BEGIN(0); }
File[ ]+size:[ ]+ { BEGIN(0); }
Optimized:[ ]+ { BEGIN(0); }

.	;


%%


int main(int argc, char** argv){
	if(argc!=2) {puts("pass a filename as argument"); return -1;}
	char cmd[256];
	//strcpy(asdf.pdf_version,"asdf");
	Pdfinfo *asdf;
	update_Pdfinfo(asdf->title,"hello");
	update_Pdfinfo(asdf->subject,"hello");
	print_Pdfinfo(asdf);
	
	if (strlen(argv[1])>=256){
		printf("filename maxlex is 256\n");
		return -1;
	}
	memset(filename,'\0',256);
	strncpy(filename,argv[1],strlen(argv[1]));
	memset(cmd,'\0',256);
	strcpy(cmd,"pdfinfo ");
	strcat(cmd,argv[1]);
	yyin=popen(cmd,"r");
	yylex();

	return 0;
}
