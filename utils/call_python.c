#include <Python.h>
//https://www6.software.ibm.com/developerworks/education/l-pythonscript/l-pythonscript-ltr.pdf
int
main(int argc, char *argv[])
{
	Py_Initialize();
        PyRun_SimpleString("import re");
        PyRun_SimpleString("f = open('/tmp/some_file','r')");
        PyRun_SimpleString("data = f.readlines()");
        PyRun_SimpleString("f.close()");
	PyRun_SimpleString("for line in data:print(line)");
	Py_Finalize();	
	return 0;
}
