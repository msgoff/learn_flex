while read f;
	do echo $f;
		echo $f|./a.out ;
		echo ;
	done < <(cat latex_repl.l|cut -d '{' -f1 |tr -d ' ')|tee out

