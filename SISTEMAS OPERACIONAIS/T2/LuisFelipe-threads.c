/*

	UNIVERSIDADE FEDERAL DE SANTA MARIA
		CENTRO DE TECNOLOGIA
	CURSO DE ENGENHARIA DE COMPUTAÇÃO

		Sistemas Operacionais	
	
	Autor: Luis Felipe de Deus
	Data:10/10/17
	Atualização:17/10/17
	
	Obejtivo: Efetuar o calculo de PI de forma sequencial e por meio de Threads
		  para constatar o desempenho, explorando o paralelismo dividindo o programa em Threads 
		  e executando as parcelas simultaneamente, em um PC com mais de um core 
		  O Programa deve ter como entrada iteracoes e Numero de Theads Ex 1e10 8
		  

*/
//Bibliotecas
#include <stdio.h>
#include <stdlib.h> 
#include <pthread.h>
#include <time.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>

//Constante de refencia PI
#define REF 3.141592653589793

//Estrutura Global
typedef struct{
   int idThread;
   int nThreads;
} t_Args;

//Variaveis Globais
unsigned long int iteracoes = 0;	//Varaivel que contem o numero de iteracoes 1*10^x (vem como parametro)
int n_threads;				//Variavel que contem o numero de threds (vem como parametro)
long double res_thread[50];		//Vetor que contem em cada posicao o valor de PI da respectiva Thread
long double soma_thread;		//Variavel que contem a soma do valor de PI calculado de cada Thread
long double res_sequencial;		//Variavel que contem o resultado da soma sequencial de PI

//Prototipo da funcao de tempo 
double difTime(struct timespec t0, struct timespec t1);	

//Inicio da funcao sequencial
void sequencial()
{	
	//Variaveis locais
	int numerador = 0;
	unsigned long int n = 0;
	double denominador,result;

	for(n = 0; n<iteracoes; n++)
	{
		if(n%2 ==0) numerador = 4;
		else
		numerador = -4;

		denominador = (2*n)+1;
		result = numerador/denominador;
		res_sequencial = res_sequencial + result;
		
	}
	
}//Fim sequencial

//Inicio funcao calculo que calcula PI pelas Threads
void *calculo (void *arg)
{
	t_Args *args = (t_Args *) arg;

	printf("Sou a thread %d de %d threads\n", args->idThread, args->nThreads);

	//Variaveis locais
	int numerador = 0;
	unsigned long int k = 0;
	double somatorio,denominador,result = 0.0;
	
	k = args->idThread;	//Para cada thread, k comeca no numero do id da thread

	while(k <= iteracoes)
	{
		
		if(k%2 ==0) numerador = 4;
		else
		numerador = -4;

		denominador = (2*k)+1;
		result = numerador/denominador;
		somatorio = somatorio + result;
		k= k + args->nThreads;
		
	}

	res_thread[args->idThread] = somatorio;	//Salva o valor no vetor da thread

	//Libera a memoria alocada e sai da thread
  	free(arg);
 	pthread_exit(NULL);
	
}//Fim funcao calculo

//Inicio da funcao main
int main(int argc, char *argv[])
{
	//Estrutura usada para a funcao temporal
	struct timespec tempoInicioS, tempoFimS,tempoInicioT, tempoFimT;
	
	t_Args *arg;

	//Variaveis locais
	int t, i, expoente = 0;
	char *exp;
	unsigned int parametros[50] = {0};
	unsigned long int intervalo_thread = 0;

	printf("\n\n");
	printf("Foram passados %d argumentos são eles: \n", argc );

	//Loop para conversão dos parametros informados (String -> int)
	for(i = 1; i<(argc);i++)
	{
		exp = strchr(argv[1],'e'); 	//Procura argv na primeira string Ex 1e8 e retorna o ponteiro para End dps da primeira ocorrencia
		expoente = atoi(&(exp[1]));	// variavel expoente contem o expoente apos o 'e'
		
		parametros[i] = atoi(argv[i]); //Vetor recebe argumentos convertidos para inteiro

		//Tratamento de erro numero negativo
		if(parametros[1] < 0)
		{
			printf("Numero negativo deu ruim \n");
			exit(0);
		}

		else 
		printf("Argumento [%d] Passado:  %d \n\n",i, parametros[i]);
	}
		printf("O expoente vale: %d \n\n\n", expoente);
	
	
	n_threads = parametros[2]; 	//Pega o numero de threads
	printf("O numero de threads e' %d \n",n_threads);
 	//Faz a potencia do expoente 10 ^ x
	for(i = 0; i<expoente;i++)
	{
		if(i==0) iteracoes = 1;
		iteracoes = iteracoes *10;
	}

	pthread_t tid[n_threads]; 		//Declaração de id para thread's
	iteracoes = parametros[1] * iteracoes;	//Junto o parametro com a parte de potenciação Ex 1*10^8
	printf("O numero de iteracoes e' %ld \n",iteracoes);
		
	//Dividi quantas interacoes cada thread vai executar
	intervalo_thread = iteracoes/n_threads;
	printf("O numero de iteracoes para cada thread e %ld \n",intervalo_thread);

	printf("\n\n\n");	
	printf("###########################\n");	
	printf("COMECANDO EXECUC SEQUENCIAL\n");
	
	clock_gettime(CLOCK_MONOTONIC_RAW, &tempoInicioS);
	//Chamada da funcao sequencial
	sequencial();
	clock_gettime(CLOCK_MONOTONIC_RAW, &tempoFimS);

	printf("\n\n"); 
	printf("--Apresentacao de resultados --\n\n"); 
	printf("O valor de PI Sequencial--> %.15Lf \n", res_sequencial);
	printf("A referencia e'-----------> %.15f \n\n", REF);
	printf("O tempo de exec sequencial foi %lfs\n", difTime(tempoInicioS, tempoFimS));

	printf("\n\n\n");	
	printf("###########################\n");	
	printf("COMECANDO EXECUC THREAD\n\n");
	clock_gettime(CLOCK_MONOTONIC_RAW, &tempoInicioT);
	
	for(t=0; t<n_threads; t++) 
	{
		printf("Aloca e preenche argumentos para thread %d\n", t);
		arg = malloc(sizeof(t_Args));	//Aloca memoria para a thread
		if (arg == NULL) 
		{
			printf("erro ao alocar memoria\n"); 
			exit(-1);
		}
		
		arg->idThread = t; 		//Salva na struct o id da thread 
		arg->nThreads = n_threads; 	//Salva na struct quantas threads tem
	
			
		printf("Criando a thread %d\n", t);
		if (pthread_create(&tid[t], NULL, calculo, (void*) arg))	
		{
			printf("erro ao criar thread\n"); 
			exit(-1);
		}
	
	
		
	}	//Fim for criacao threads
	
	

	//For para garantir que as threads terminem antes da main funcao Join
	for(t=0; t<n_threads; t++)
	{
		pthread_join(tid[t],NULL);
		printf("Join na Thread %d \n", t);
	}//FIm for Join nas threads

	clock_gettime(CLOCK_MONOTONIC_RAW, &tempoFimT);

	printf("\n\n");
	printf("--Apresentacao de resultados --\n\n"); 
	printf("O tempo de exec THREAD foi %lfs\n", difTime(tempoInicioT, tempoFimT));
	printf("\n\n"); 
	for(t=0; t<n_threads; t++)
	{
		 soma_thread = res_thread[t]+soma_thread;
		printf("thread %d -> %.15Lf \n",t, res_thread[t]);
	}// Fim for 

	printf("\n\n");
	printf("O valor de PI com THREADS e' --> %.15Lf \n", soma_thread);
	printf("A referencia de e'-------------> %.15f \n\n\n", REF);
	printf("--Comparando Resultados-- \n\n");
	printf("O valor de PI Sequencial-------> %.15Lf \n", res_sequencial);
	printf("O valor de PI com THREADS e' --> %.15Lf \n", soma_thread);
	printf("A referencia e'----------------> %.15f \n\n", REF);

	printf("O tempo de exec sequencial foi--> %lfs\n", difTime(tempoInicioS, tempoFimS));	
	printf("O tempo de exec THREAD foi -----> %lfs\n\n\n", difTime(tempoInicioT, tempoFimT));
	printf("Main terminou\n");
	pthread_exit(NULL);	
	
}// Fim main

//Funcao temporal
double difTime(struct timespec t0, struct timespec t1)
{
	return ((double)t1.tv_sec - t0.tv_sec) + ((double)(t1.tv_nsec-t0.tv_nsec)* 1e-9);
}

