#include<stdio.h>
#include<stdlib.h>

#define ERROR 0

char sym;  //������ʱ�洢�ļ��ж����ĵ����ַ�
FILE *fp;  //��ȡ�ļ���ָ��

//���ս������ķ���
void e();
void g();
void t();
void s();
void f();
//��ȡ�ļ��е���һ���ַ�
void advance();
int main()
{
	
	if((fp=fopen("�����ļ�.txt","r"))==NULL)//��ȡ�ļ����ݣ��������ļ�ָ�룬��ָ��ָ���ļ��ĵ�һ���ַ�
	{   
		fprintf(stderr,"error opening.\n");
		exit(1);
	}
	e();

	return 0;
}
//��Ӧ����ʽ��1��E->TG
void e()
{
	advance();
	t();
	g();
	if(sym=='#')
	{
		printf("�����Ϊ�Ϸ����ַ���\n");
	}
	else
	{
		printf("�Ƿ��ַ���");
	}
	
}
//��Ӧ����ʽ��2��G->+TG ��3��G->��  �� �������κδ���

void g()
{
	if(sym =='+')
	{
		printf("+");
		advance();
		t();
		g();
	}
}
//��Ӧ����ʽ  ��4��T->FS
void t()
{
	f();
	s();
}
// ��Ӧ����ʽ��5��S->*FS ��6��S->��
void s()
{
	if(sym=='*')
	{
		printf("*");
		advance();
		f();
		s();
	}
}
//��Ӧ����ʽ��7��F->(E)  ��8��F->i

void f()
{
	if(sym=='(')
	{
		advance();
		e();
		if(sym==')')
			advance();
		else 
		{
			printf("�Ƿ��ַ���");
			exit(ERROR);
		}
	}
	else if(sym=='i') 
	{
		printf("i");
		advance();
	}
	else
	{
		printf("�Ƿ��ַ���");
		exit(ERROR);
	}
}
void advance()
{
	sym=fgetc(fp);// ��������������һ���ַ�	
}
