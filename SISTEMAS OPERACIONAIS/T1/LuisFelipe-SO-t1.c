/*

	UNIVERSIDADE FEDERAL DE SANTA MARIA
		CENTRO DE TECNOLOGIA
	CURSO DE ENGENHARIA DE COMPUTAÇÃO

		Sistemas Operacionais	
	
	Autor: Luis Felipe de Deus
	Data:16/09/17
	Atualização:21/09/17
	
	Obejtivo: Criação de uma arvore de processos via chamada Fork
			Os Pais devem esperar os filhos terminarem

					PAI 1

		Filho1-Pai2				Filho1-Pai2

	Filho2-Pai3	Filho2-Pai3		Filho2-Pai3	Filho2-Pai3
	
	  Filho3	   Filho3		   Filho3  	    Filho3

*/

//Bibliotecas
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <errno.h>
#include <time.h>

pid_t idProcesso1, idProcesso2, idProcesso;	//Id utilizados 
	
	//Variaveis Globais
	int estado, i,numero_geracoes = 0;
	int j = 1;
	int geracao = 1;
	int filhos_por_geracao[10] = {0};	
	
	//Protótipos de funções
	void cria_filho();

//Função principal
int main (int argc, char *argv[])
{
	int l = 0;	//Variavel local para o pai de todos terminar o tempo de criação

	//contagem de tempo da criação da arvore
	clock_t start_t, end_t, total_t;
	start_t = clock();

	printf("Foram passados %d argumentos são eles: \n", argc-1 ); 	// -1 pq o parametro argv[0] é o caminho local
	numero_geracoes = argc-1; 

	if(numero_geracoes < 0) numero_geracoes = 0; 
	
	//Loop para conversão dos parametros informados (String -> int)
	for(i = 1; i<(argc);i++)
	{
		
		filhos_por_geracao[i] = atoi(argv[i]); //Vetor recebe argumentos convertidos para inteiro

		//Tratamento de Erros de parametros
		if(filhos_por_geracao[i] <= 0)
		{
			printf("Ocorreu um Erro de Parametros \n");
			printf("Fechando Programa... \n");
			exit(0);
		}
		else 
		printf("Argumentos [%d] Passado:  %d \n\n",i, filhos_por_geracao[i]);
		
	}
	

	//Condição para pegar somente o primeiro processo, o pai de todos
	if(l == 0) 
	{
	   l=1;
	   idProcesso1  = getpid();	
	}
	
	// Loop para criação da primeira geração de filhos
	for(i = 0; i<filhos_por_geracao[1];i++)
	{
		if(idProcesso1 == getpid())
		cria_filho();
		
	}

	
	printf("SOU O ID [%d] E ESTOU TERMINANDO...\n", getpid());	
	if(idProcesso1 == getpid()) //Se for o processo pai de todos, encerra a contagem de tempo e fecha a arvores
	{
	
	   end_t = clock();
	   total_t = end_t - start_t;
	   printf("\n\n");		
       	   printf("TEMPO DE CRIACAO DA ARVORE: TIME = %ld ns \n",total_t);
	}
	exit(0);
	
}//Fecha main


//Inicio da função que  cria os filhos
void cria_filho()
{
	
	printf("Sou o PAI da %d GERACAO e vou Forkar meu ID e' [%d]\n", geracao, getpid());
	idProcesso = fork();
																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																												
		
	if(idProcesso < 0)
	{
		fprintf(stderr,"fork deu ruim\n");
		exit(errno);
	}
	else if(idProcesso !=0) //Pai
	{
		printf("Vou esperar meu filho gerar seus filhos...\n");
		printf("\n\n");
		wait(&estado);
		printf("\n\n");
		printf("Sou o PAI da %d GERACAO e vou continuar sou o ID [%d], FILHO DO [%d]\n", geracao, getpid(), getppid());
	}
	else if(idProcesso == 0) //Filho
	{
			
		printf("Sou o FILHO da %d GERACAO, meu ID = [%d], meu pai eh [%d]\n",geracao, getpid(), getppid());
		if(j < numero_geracoes)
		{			
			j++;
			idProcesso2 = getpid(); 
			geracao++;
			for(i = 0; i<filhos_por_geracao[j];i++)
			{
				if(idProcesso2 == getpid())
				cria_filho();
						
			} //Fecha for
						
		}//Fecha if

			
	}//Fecha else if
}//Fecha função cria_filho

