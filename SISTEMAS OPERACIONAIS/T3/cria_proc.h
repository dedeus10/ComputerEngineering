#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define TAM 10000   //Tamanho maximo do ID

//Referencia ao arquivo do Trace
FILE *trace;

//Variavel global para o ID
int id_proc = -1;

//Definição da stuct processos
struct processos
{
    int id;                             //Armazena o ID do processo
    int CPU_time;                       //Armazena o quanto o processo vai executar
    int prioridade_I_O;                 //Armazena a pioridade no I/O

    int t_turnaround;                   //Armazena o tempo de turnaround
    int t_espera;                       //Armazena o tempo de espera pela CPU
    int criacao;                        //Armazena o tempo de criação do processo

    int t_usou_cpu;                     //Armazena o tempo que o processo usou a CPU
    int t_pegou_cpu;                    //Armazena o tempo em que o processo pegou a CPU

    int flag_processo_acabou;           //Flag que fiz que o processo acabou

    int entrada_na_arrive;              //Armazena o tempo de entrada na fila arrive
    int espera_na_arrive;               //Armazena o tempo de espera na fila arrive
    int flag_saiu_arrive;               //Flag que diz que o processo saiu da arrive

    int entrada_na_ready;               //Armazena o tempo de entrada da fila ready
    int espera_na_ready;                //Armazena o tempo de espera na fila ready
    int flag_saiu_ready;                //Flag para dizer que o processo saiu da fila ready

    int entrada_na_lista;               //Armazena o tempo de entrada na lista
    int espera_na_lista;                //Armazena o tempo de espera na lista
    int flag_saiu_lista;                //Flag para dizer que o processo saiu da lista


};

//Função que gera numeros aleatorios para prioridade  e burst time
int aleatorio(int faixa, int id_proc)
{
    unsigned int n_aleatorio = 0;

    n_aleatorio = rand()%faixa;

    if(n_aleatorio <0) n_aleatorio*-1;

    return n_aleatorio;
}

//Função que cria processos
int cria_processo(struct processos p[TAM], int contador_global_tempo)
{

    int faixa = 10;             //Delimita a faixa do random para o cpu time
    int faixa_priority = 20;    //Delimita a faixa do random para a prioridade

    //Incrementa o ID do proc
    id_proc++;

    //Armazena o ID no campo da struct
    p[id_proc].id = id_proc;
    fprintf(trace,"\nGT[%d]->O ID criado e' %d \n",contador_global_tempo, p[id_proc].id);
    printf("\nGT[%d]->O ID criado e' %d \n",contador_global_tempo, p[id_proc].id);

    //Gera o aleatorio do tempo de CPUe armazena no campo da struct
    p[id_proc].CPU_time = aleatorio(faixa,id_proc);
    fprintf(trace,"GT[%d]->O Burst Time do ID [%d] e' %d \n",contador_global_tempo,id_proc, p[id_proc].CPU_time);
    printf("GT[%d]->O Burst Time do ID [%d] e' %d \n",contador_global_tempo,id_proc, p[id_proc].CPU_time);

    //Gera o aleatorio do tempo de prioridade e armazena no campo da struct
    p[id_proc].prioridade_I_O = aleatorio(faixa_priority,id_proc);
    fprintf(trace,"GT[%d]->A Prioridade do ID [%d]e' %d \n",contador_global_tempo,id_proc, p[id_proc].prioridade_I_O);
    printf("GT[%d]->A Prioridade do ID [%d]e' %d \n",contador_global_tempo,id_proc, p[id_proc].prioridade_I_O);

    //Recebe inicialização
    p[id_proc].t_turnaround = contador_global_tempo;
    p[id_proc].criacao = contador_global_tempo;

    //Por default recebe 0;
    p[id_proc].t_espera = 0;
    p[id_proc].t_usou_cpu = 0;
    p[id_proc].flag_processo_acabou = 0;
    p[id_proc].entrada_na_arrive = -1;
    p[id_proc].espera_na_arrive = 0;
    p[id_proc].flag_saiu_arrive = 0;
    p[id_proc].entrada_na_ready = -1;
    p[id_proc].espera_na_ready = 0;
    p[id_proc].flag_saiu_ready = 0;
    p[id_proc].flag_saiu_lista = 0;
    p[id_proc].espera_na_lista = 0;
    p[id_proc].entrada_na_lista = -1;

    //Retorna o campo do ID do processo gerado
    return(p[id_proc].id);

}
