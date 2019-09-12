
/*

	UNIVERSIDADE FEDERAL DE SANTA MARIA
		CENTRO DE TECNOLOGIA
	CURSO DE ENGENHARIA DE COMPUTAÇÃO

		Sistemas Operacionais

	Autor: Luis Felipe de Deus
	Data:19/11/17
	Atualização: 29/11/17

	Obejtivo: Criar um servidor de impressão para uma empresa que necessita sincronizar as solicitações dos setores
		  O programa deve usar as primitivas de semáforos para sincronizar as ações onde uma impressora
		  imprimi qualquer uma das N solicitações, uma por vez, existem MAX impressoras definidas pelo usuario
		  o tempo de imprimir e gerar a impressão é definido pelo software randomicamente.


*/
//Bibliotecas
#include <stdio.h>
#include <stdlib.h>

#include <pthread.h>
#include <semaphore.h>

#include <time.h>
#include <sys/wait.h>
#include <unistd.h>

#include "buffer.h"	//Header para o buffer implementado como uma fila dinâmica


//Definições
#define TAM 100000 		    //Tamanho da struct data
#define X 2			        //Vezes que FAST é mais rapida que SLOW
/* //Descomentar para forçar valores E comentar variaveis abaixo e cod na MAIN
#define FAST 1			    //Tempo para impressão das impressoras T1	(mudar para rand)
#define SLOW (X*FAST)		//Tempo para impressão das impressoras T2	(mudar para rand)
#define GENERATOR 1		    //Tempo de espera para encaminhar solicitação (mudar para rand)
#define SOLIC_POR_SETOR 10	//Numero de Solicitações por Setor
*/

#define MAX_SOLICIT 10		//Numero maximo de solicitações (Criterio de parada)

int FAST;
int SLOW;
int GENERATOR;
int SOLIC_POR_SETOR;
//Estrutura Global para a thread
typedef struct
{
    int idThread;		    //Id da thread/Impressora
    int time_printOut;		//Tempo para imprimir (Depende do tipo)
    int type;			    //Tipo da impressora


} t_Args;

//Estrutura Global para os dados da solicitação
struct data
{
    int sector;		//Setor da solicitação
    int ID;			//ID da solicitação
    int flag_exec;		//Flag se foi ou não atendida
};



//declaração dos semaforos
sem_t empty;
sem_t full;
sem_t mutex;

struct data d[TAM];

//Prototipos das funções
double difTime(struct timespec t0, struct timespec t1);
int tratamento_falhas(int id_item);
int solict_generator();
void print_out(int id, int impressora_ID, int type, int time);
void insert_item(int id_item);
int remove_item();
int verifica_se_tudo_foi_atendido();
void *producer (void* arg);
void *consumer (void* arg);

//Variaveis Globais
int control = 0;				//Controla o incremento do numero de setores
int set = 0;					//Variavel que incrementa os setores
int IDent = -1;					//Variavel usada para endereçar e salvar na struct data
int N_printers = 0;				//Numero de impressoras (Atualizada na entrada do software)
int true_= 1;					//Serve para parada da thread producer
int true__ =1;					//Serva para parada das threads das impressoras
int contador_falhas = 0;		//Contador de falhas de impressão
int contador_sucessos = 0;		//Contador de impressoes realizadas com sucesso
int vet_dataSet[TAM];			//Salva o numero de falhas por setor
int total_solicitacoes = 0;		//Contem o numero total de solicitacoes
int chance = 15;				//Chance de dar erro na impressao %


//---------Generator-------------//
int solict_generator()
{
    //Gera a solicitação para um setor
    IDent++;

    d[IDent].sector = set;
    d[IDent].ID = IDent;
    d[IDent].flag_exec = 0;

    if(control == (SOLIC_POR_SETOR-1))	//Se ja foram as solicitações daquele setor incrementa setores
    {
        control = 0;
        set++;
    }
    else control++;

    printf("SOLICITACAO[ ID:%d SE:%d ] ENCAMINHADA\n",d[IDent].ID, d[IDent].sector);
    if(IDent == (MAX_SOLICIT-1)) true_ = 0;

    return d[IDent].ID;
}

//----------Consume------------//
void print_out(int id, int impressora_ID, int type, int time)
{
    //Função que imprime a solicitação
    int fail = -1;
    int aux;

    //Estrutura usada para a funcao temporal
    struct timespec tempoInicioS, tempoFimS,tempoInicioT, tempoFimT;
    if(id != -1 && !d[id].flag_exec)
    {
    	//Inicia o contador de tempo
    	clock_gettime(CLOCK_MONOTONIC_RAW, &tempoInicioT);

    	printf("\nIMPRIMINDO SOLICITACAO: [%d] do SETOR: [%d] na IMPRESSORA: [%d] \n",d[id].ID, d[id].sector, impressora_ID);
	printf("Impressora Adquirida é do tipo [T%d] -- T0->FAST | T1->SLOW \n\n",type);

	//Tempo de imprimir
	sleep(time);

	if(!type)	//Se for do tipo T0 pode falhar
	{
        	fail = tratamento_falhas(d[id].ID); //Verifica se falhou ou não
	}
	if(fail == 1)	//Falhou
	{
        	printf("Impressao FALHOU [SOL: %d SET: %d] \n",d[id].ID, d[id].sector);
	}
	else
	{
        	printf("\n\n####  ACABOU IMPRESSAO SOL[%d] | SET[%d] ####### - IMPRESSORA [%d] desocupada\n",d[id].ID, d[id].sector, impressora_ID);
        	clock_gettime(CLOCK_MONOTONIC_RAW, &tempoFimT);
        	printf("SOL: %d SET: %d IMP %d --> Demorou %.2lf (s) para impressao \n",d[id].ID, d[id].sector, impressora_ID, difTime(tempoInicioT, tempoFimT));
        	contador_sucessos++;	//Incrementa sucessos de impressao
        	aux = d[id].sector;	//Salva referencia do Setor
        	vet_dataSet[aux]++;	//Incrementa vetor na posição do Setor para saber quantas impressões terminaram por setor
		if(vet_dataSet[aux] == (SOLIC_POR_SETOR) || id == (MAX_SOLICIT-1)) printf("Todas as Solicitacoes do SETOR [%d] foram atendidas\n",aux);
        	d[id].flag_exec = 1;

    	}

     }
	printf("\n");
}

//-----------Tratamento de Falhas-----------//
int tratamento_falhas(int id_item)
{
    int random;
    int acerto = 0;

    srand(time(NULL));

    random = rand()%99;		//Gera um numero random de 0 a 99 (cada numero tem 1% de chance)

    if(random < chance)		//Se o numero gerado for menor que a chance (tipo 15%, numeros de 0 a 14 cada um com 1% de chance)
    {
        acerto = 1;		    //Seta flag
    }


    if(acerto)
    {
        sem_wait(&empty);		    //Decrementa o contador empty
        sem_wait(&mutex);		    //Entra na região critica

        contador_falhas++;	    	//Incrementa falhas
        insere_buff(id_item);		//Poe o item no buffer
        total_solicitacoes++;		//incrementa solicitações

        sem_post(&mutex);		    //Sai da região critica
        sem_post(&full);		    //Incrementa o contador de lugares preenchidos
        return 1;
    }
    return 0;
}

//----------insert - SEÇÃO CRITICA---------------//
void insert_item(int id_item)
{
    //Insere um item no buffer
    insere_buff(id_item);
    total_solicitacoes++;
    printf("Item com ID %d INSERIDO no buffer\n", id_item);
}

//---------remove - SEÇÃO CRITICA -------------//
int remove_item()
{
    //Remove um item do buffer
    int id_item;

    id_item = principal_buffer->ID_buffer;
    exclui_buff();
    printf("Item com ID %d RETIRADO do buffer\n", id_item);

    return id_item;
}


//-----------THREADS-------------//
void *producer (void* arg)
{

    int i;
    int id_item;
    while(true_ == 1)
    {
        id_item = solict_generator();	//Gera algo pra por no buffer

        sem_wait(&empty);		//Decrementa o contador empty
        sem_wait(&mutex);		//Entra na região critica

        insert_item(id_item);		//Poe o item no buffer

        sem_post(&mutex);		//Sai da região critica
        sem_post(&full);		//Incrementa o contador de lugares preenchidos

        sleep(GENERATOR);		//Tempo de gerar encaminhar solicitação

    }
    //Libera a memoria alocada e sai da thread
    free(arg);
    pthread_exit(NULL);
}

void *consumer(void* arg)
{
    int id_item;
    int  i;
    // int true__ =1;
    t_Args *args = (t_Args *) arg;
    printf("Sou a thread %d de %d threads\n", args->idThread, N_printers);

    while(true__ == 1)
    {

        sem_wait(&full);		//Decrementa o contador full
        sem_wait(&mutex);		//Entra na região critica

        if(true__)id_item = remove_item();	//pega item do buffer

        sem_post(&mutex);		//Sai da região critica
        sem_post(&empty);		//Incrementa o contador de lugares vazios

        print_out(id_item,args->idThread, args->type, args->time_printOut);	//Imprime
        true__ = verifica_se_tudo_foi_atendido();

        if(!true__)
        {
            id_item = -1;
            for(i=0; i<N_printers; i++)	sem_post(&full);	//Libera as threads dos semaforos
        }


    }

    //Libera a memoria alocada e sai da thread
    free(arg);
    pthread_exit(NULL);
}

//----------Verifica Fim de Execução----------
int verifica_se_tudo_foi_atendido()
{
    int i;
    int acaba_tudo = 0;

    for(i=0; i<MAX_SOLICIT; i++)    //Percorre todas as solicitaçoes
    {
        if(!d[i].flag_exec)         //Veririca as flag se ja foram executadas ou não
        {
            acaba_tudo = 1;         //Se uma delas nao foi executada
            i = MAX_SOLICIT;        //Quebra o loop e retorna 1 para continuar
        }
    }

    return acaba_tudo;
}


//-----------MAIN-------------//
int main(int argc, char *argv[])
{
    t_Args *arg;
    pthread_t p;
    int i;

    //Tratamento de entrada

    N_printers = atoi(argv[1]); //Recebe o numero de impressoras
    if(N_printers <=0)
    {
        printf("Nenhuma impressora Solicitada --Erro--\n");
        exit(0);
    }
    printf("Numero de impressoras: %d\n", N_printers);
    printf("\n\n");

    //Inicialização dos semaforos
    sem_t semaphore;
    sem_init(&mutex,0,1);
    sem_init(&full,0,0);
    sem_init(&empty,0,N_printers);

    
    //Gera numero aleatorio de tempo para imprimir tipo T0
    srand(time(NULL));
    FAST = rand()%5;
    GENERATOR = rand()%5;
    //Tipo T1 é X vezes mais lenta que T0
    SLOW = X*FAST;
    
    SOLIC_POR_SETOR = rand()%10;

    printf("Time Fast: 	%d\n",FAST);
    printf("Time Slow: 	%d\n",SLOW);
    printf("Time Generator: %d\n",GENERATOR);
    printf("FAST e' %dx mais rapida que SLOW:\n",X);
    printf("Serao executadas %d solicitacoes/setor\n\n",SOLIC_POR_SETOR);
	
    printf("A chance de dar erro de impressao e' %d%%\n\n",chance);

    arg = malloc(sizeof(t_Args));	//Aloca memoria para a thread Producer
    //Cria Thread Producer
    pthread_create(&p, NULL, producer, (void*) arg);

    //Threads para impressoras
    pthread_t tid[N_printers]; 		//Declaração de id para thread's
    for(i = 1; i<=N_printers; i++)
    {
        arg = malloc(sizeof(t_Args));	//Aloca memoria para a thread
        if (arg == NULL)
        {
            printf("erro ao alocar memoria\n");
            exit(-1);
        }

        arg->idThread = i; 		//Salva na struct o id da thread

        if(i%2 ==0)	//Se for par é tipo 0 (FAST)
        {
            arg->type = 0; 			//Salva na struct o tipo da impressora
            arg->time_printOut = FAST; 	//Salva na struct o tempo de impressão
        }
        else		//Se for impar é tipo 1 (SLOW)
        {
            arg->type = 1; 			//Salva na struct o tipo da impressora
            arg->time_printOut = SLOW; 	//Salva na struct o tempo de impressão
        }


        if (pthread_create(&tid[i], NULL, consumer, (void*) arg))
        {
            printf("erro ao criar thread\n");
            exit(-1);
        }
    }

    //Join na thread do producer
    pthread_join(p,NULL);

    //Join nas threads das impressoras
    for(i=1; i<=N_printers; i++)
    {
        pthread_join(tid[i],NULL);
        printf("Join na Thread %d \n", i);
    }

    printf("----------- RESULTADOS ---------\n\n");
    printf("O numero de falhas nas impressoras T0 foi:   %d\n", contador_falhas);
    printf("O numero de sucessos de impressao foi:	     %d\n", contador_sucessos);
    printf("O numero total de solicitacoes foi:    	     %d\n", total_solicitacoes);
    printf("\nImpressoes por Setor\n");
    for(i = 0; i<=set; i++)
    {
        printf("O total de impressoes do SETOR [%d] foi: %d\n",i,vet_dataSet[i]);
    }

    return 0;


}// Fim main


//Funcao temporal
double difTime(struct timespec t0, struct timespec t1)
{
    return ((double)t1.tv_sec - t0.tv_sec) + ((double)(t1.tv_nsec-t0.tv_nsec)* 1e-9);
}

