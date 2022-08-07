cat source.csv |
	grep -vP '^\s+"source":\s+\[' |
	sed -r 's/^\s+"//g'|
	sed -r 's/^\s+\]//g'|
	sed -r 's/#\s+"/#/g'|
	sed -r 's/^#\s+\]//g'|
	sed -r 's/^#{2,}/#/g'|
	sed -r 's/\\n",//g'|
	sed -r 's/"$//g'

