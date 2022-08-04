%{
#include <stdio.h>
int	a=0,b=0,c=0,d=0,e=0,f=0,g=0,h=0,i=0,j=0,k=0;
int	l=0,m=0,n=0,o=0,p=0,q=0,r=0,s=0,t=0,u=0,v=0,w=0;
int	x=0,y=0,z=0,space=0,total_count=0;
%}

%%
a	{	a++; total_count++;	}
b	{	b++; total_count++;	}
c	{	c++; total_count++;	}
d	{	d++; total_count++;	}
e	{	e++; total_count++;	}
f	{	f++; total_count++;	}
g	{	g++; total_count++;	}
h	{	h++; total_count++;	}
i	{	i++; total_count++;	}
j	{	j++; total_count++;	}
k	{	k++; total_count++;	}
l	{	l++; total_count++;	}
m	{	m++; total_count++;	}
n	{	n++; total_count++;	}
o	{	o++; total_count++;	}
p	{	p++; total_count++;	}
q	{	q++; total_count++;	}
r	{	r++; total_count++;	}
s	{	s++; total_count++;	}
t	{	t++; total_count++;	}
u	{	u++; total_count++;	}
v	{	v++; total_count++;	}
w	{	w++; total_count++;	}
x	{	x++; total_count++;	}
y	{	y++; total_count++;	}
z	{	z++; total_count++;	}
[\ ] 	{	space++; total_count++;	}
\n	;
.	;

%%

int main()
{
	
	yylex();
	printf("a:%.2f\tb:%.3f\tc:%.3f\td:%.3f\n",1.0*a/total_count,1.0*b/total_count,1.0*c/total_count,1.0*d/total_count);
	printf("e:%.3f\tf:%.3f\tg:%.3f\th:%.3f\n",1.0*e/total_count,1.0*f/total_count,1.0*g/total_count,1.0*h/total_count);
	printf("i:%.3f\tj:%.3f\tk:%.3f\tl:%.3f\n",1.0*i/total_count,1.0*j/total_count,1.0*k/total_count,1.0*l/total_count);
	printf("m:%.3f\tn:%.3f\to:%.3f\tp:%.3f\n",1.0*m/total_count,1.0*n/total_count,1.0*o/total_count,1.0*p/total_count);
	printf("q:%.3f\tr:%.3f\ts:%.3f\tt:%.3f\n",1.0*q/total_count,1.0*r/total_count,1.0*s/total_count,1.0*t/total_count);
	printf("u:%.3f\tv:%.3f\tw:%.3f\tx:%.3f\n",1.0*u/total_count,1.0*v/total_count,1.0*w/total_count,1.0*x/total_count);
	printf("y:%.3f\tz:%.3f\tspace:%.3f\ttotal_count:%d\n",1.0*y/total_count,1.0*z/total_count,1.0*space/total_count,total_count);
	
	
	return 0;

}
