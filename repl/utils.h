void dot_file(char* file_name,char *r_w_a,char *text){
  FILE *f = fopen(file_name, r_w_a);
  if (f == NULL)
  {
      printf("Error opening file!\n");
      exit(1);
  }
  fprintf(f,"%s","graph {\n");
  fprintf(f, "%s\n", text);
  fprintf(f,"%s","}\n");
  fclose(f);
}

